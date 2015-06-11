//
//  ROCollectionViewController.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 16/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROCollectionViewController.h"
#import "ROCollectionViewCell.h"
#import "ROPage.h"
#import "ROCellConstants.h"
#import "NSBundle+RO.h"
#import "ROStyle.h"
#import "SVProgressHUD.h"
#import "SVPullToRefresh.h"
#import "ROError.h"
#import "UIColor+RO.h"
#import "ROBehavior.h"
#import "RORefreshBehavior.h"

static NSInteger const kNumbersOfColumns                            = 2;

static CGFloat const kCollectionMarginSection                       = 5.0f;
static CGFloat const kCollectionMinimumInteritemSpacingForSection   = 2.5f;
static CGFloat const kCollectionMinimumLineSpacingForSection        = 5.0f;

@interface ROCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/**
 *  Prototype cell identifier
 */
@property (nonatomic, strong) NSString *cellIdentifier;

/**
 Collection view cell style
 */
@property (nonatomic, assign) ROCollectionViewCellStyle cellStyle;

/**
 * Reset cell values
 */
- (void)resetCell:(UICollectionViewCell *)cell;

@end

@implementation ROCollectionViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.behaviors addObject:[RORefreshBehavior behaviorViewController:self]];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (_collectionView) {
        if (_collectionView.superview) {
            [_collectionView removeFromSuperview];
        }
        _collectionView = nil;
    }
}

- (void)viewDidLoad
{
    // Add collectionView before [super viewDidLoad]
    
    [self.view addSubview:self.collectionView];
    
    NSDictionary *viewsBindings = NSDictionaryOfVariableBindings(_collectionView);
    
    // align tableView from the left and right
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsBindings]];
    
    // align tableView from the top and bottom
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsBindings]];
    
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // Register cell
    NSString *nibName = nil;
    switch (self.page.layoutType) {
        case ROLayoutMenuMosaic:
            nibName = kCollectionCellPhotoTitleNibName;
            _cellIdentifier = kCollectionCellPhotoTitleReuseIdentifier;
            _cellStyle = ROCollectionViewCellStylePhotoTitle;
            break;
        default: {
            nibName = kCollectionCellPhotoNibName;
            _cellIdentifier = kCollectionCellPhotoReuseIdentifier;
            _cellStyle = ROCollectionViewCellStylePhoto;
            break;
        }
    }
    
    [self.collectionView registerNib:[UINib nibWithNibName:nibName
                                                    bundle:[NSBundle ro_resourcesBundle]]
          forCellWithReuseIdentifier:_cellIdentifier];
    
    if (self.page.ds) {
        // Pagination
        __weak typeof(self) weakSelf = self;
        [self.collectionView addInfiniteScrollingWithActionHandler:^{
            
            [weakSelf loadMore];
            
        }];
        UIActivityIndicatorViewStyle indicatorStyle = UIActivityIndicatorViewStyleWhite;
        if ([[[ROStyle sharedInstance] backgroundColor] ro_lightStyle]) {
            indicatorStyle = UIActivityIndicatorViewStyleGray;
        }
        [self.collectionView.infiniteScrollingView setActivityIndicatorViewStyle:indicatorStyle];
    }
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:flowLayout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.tintColor = [[ROStyle sharedInstance] accentColor];
        _collectionView.userInteractionEnabled = YES;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundView = nil;
        _collectionView.backgroundColor = [[ROStyle sharedInstance] backgroundColor];
    }
    return _collectionView;
}

- (UIEdgeInsets)insetsSection
{
    if (UIEdgeInsetsEqualToEdgeInsets(_insetsSection, UIEdgeInsetsZero)) {
        _insetsSection = UIEdgeInsetsMake(kCollectionMarginSection, kCollectionMarginSection, kCollectionMarginSection,kCollectionMarginSection);  // top, left, bottom, right
    }
    return _insetsSection;
}

- (void)resetCell:(UICollectionViewCell *)cell
{
    NSArray* subviews = [cell subviews];
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            label.text = nil;
        } else if ([subview isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)subview;
            imageView.image = nil;
        }
    }
}

#pragma mark - Load data

- (void)loadData
{
    if (self.page.ds) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        __weak typeof(self) weakSelf = self;
        [self.dataLoader refreshDataSuccessBlock:^(NSArray *items) {
            
            [SVProgressHUD dismiss];
            [weakSelf loadDataSuccess:items];
            
        } failureBlock:^(ROError *error) {
            
            [SVProgressHUD dismiss];
            [weakSelf loadDataError:error];
            
        }];
    }
}

- (void)loadMore
{
    __weak typeof(self) weakSelf = self;
    [self.dataLoader loadDataSuccessBlock:^(NSArray *items) {
        
        if ([weakSelf.items count] < [items count]) {
            weakSelf.collectionView.showsInfiniteScrolling = YES;
        } else {
            weakSelf.collectionView.showsInfiniteScrolling = NO;
        }
        if (weakSelf.collectionView.infiniteScrollingView) {
            [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        }
        [weakSelf loadDataSuccess:items];
        
    } failureBlock:^(ROError *error) {
        
        if (weakSelf.collectionView.infiniteScrollingView) {
            [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        }
        [weakSelf loadDataError:error];
        
    }];
}

- (void)loadDataSuccess:(NSArray *)items
{
    self.items = items;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.collectionView reloadData];
        
    });
    for (NSObject<ROBehavior> *behavior in self.behaviors) {
        [behavior onDataSuccess];
    }
}

- (void)loadDataError:(ROError *)error
{
    [error show];
}

#pragma mark Collection view layout things

- (NSInteger)collectionNumCols
{
    if (_numberOfColumns == 0) {
        _numberOfColumns = kNumbersOfColumns;
    }
    return _numberOfColumns;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat with = self.view.frame.size.width - kCollectionMinimumLineSpacingForSection * 2;
    CGFloat withCols = floorf(with / self.collectionNumCols) - (self.collectionNumCols - 1) * kCollectionMinimumInteritemSpacingForSection;
    return CGSizeMake(withCols, withCols);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kCollectionMinimumInteritemSpacingForSection;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kCollectionMinimumLineSpacingForSection;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionView performBatchUpdates:nil completion:nil];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.insetsSection;
}

#pragma mark - Collection View Data Sources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ROCollectionViewCell *cell = (ROCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    cell.style = _cellStyle;
    cell.backgroundColor = [UIColor clearColor];  // Adding this fixes the issue for iPad
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [[[ROStyle sharedInstance] accentColor] colorWithAlphaComponent:0.1f];
    cell.selectedBackgroundView = selectedView;
    if (indexPath.row < [self.items count]) {
        [self resetCell:cell];
        [self.collectionViewDelegate configureCell:cell atIndexPath:indexPath];
    }
    return cell;
}

@end
