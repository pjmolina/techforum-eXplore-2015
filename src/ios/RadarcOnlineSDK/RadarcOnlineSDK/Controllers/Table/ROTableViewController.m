//
//  ROTableViewController_.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 18/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROTableViewController.h"
#import "UIImage+RO.h"
#import "ROStyle.h"
#import "UIImageView+RO.h"
#import "ROCellConstants.h"
#import "NSBundle+RO.h"
#import "UITableViewCell+RO.h"
#import "SVProgressHUD.h"
#import "SVPullToRefresh.h"
#import "ROError.h"
#import "UIColor+RO.h"
#import "ROBehavior.h"
#import "RORefreshBehavior.h"
#import "ROCellConstants.h"
#import "NSString+RO.h"
#import "ROPage.h"

@interface ROTableViewController () <UITableViewDataSource, UITableViewDelegate>

/**
 *  Prototype cell identifier
 */
@property (nonatomic, strong) NSString *cellIdentifier;

/**
 *  Set dynamic height row cell
 */
@property (nonatomic, assign) BOOL dynamicHeightCell;

@property (nonatomic, strong) UITableViewCell *cell;

@property (nonatomic, assign) dispatch_once_t onceCellToken;

/**
 * Reset cell values
 */
- (void)resetCell:(UITableViewCell *)cell;

@end

@implementation ROTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.behaviors addObject:[RORefreshBehavior behaviorViewController:self]];
    }
    return self;
}

- (void)viewDidLoad
{
    // Add tableView before [super viewDidLoad]
    
    [self.view addSubview:self.tableView];
    
    NSDictionary *viewsBindings = NSDictionaryOfVariableBindings(_tableView);
    
    // align tableView from the left and right
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsBindings]];
    
    // align tableView from the top and bottom
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsBindings]];
    
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Register cell
    NSString *nibName = nil;
    switch (self.page.layoutType) {
        case ROLayoutListPhotoTitleBottomDescription: {
            nibName = kTableCellPTBDNibName;
            _cellIdentifier = kTableCellPTBDReuseIdentifier;
            _dynamicHeightCell = YES;
            break;
        }
        case ROLayoutListPhotoTitleDescription: {
            nibName = kTableCellPTDNibName;
            _cellIdentifier = kTableCellPTDReuseIdentifier;
            _dynamicHeightCell = NO;
            break;
        }
        case ROLayoutListTitleDescription: {
            nibName = kTableCellTDNibName;
            _cellIdentifier = kTableCellTDReuseIdentifier;
            _dynamicHeightCell = YES;
            break;
        }
        case ROLayoutMenuIconTitle: {
            nibName = kTableCellPTNibName;
            _cellIdentifier = kTableCellPTReuseIdentifier;
            _dynamicHeightCell = NO;
            break;
        }
            // ROLayoutMenuTitle by default
        default: {
            nibName = kTableCellTNibName;
            _cellIdentifier = kTableCellTReuseIdentifier;
            _dynamicHeightCell = NO;
            break;
        }
    }
    [self.tableView registerNib:[UINib nibWithNibName:nibName
                                               bundle:[NSBundle ro_resourcesBundle]]
         forCellReuseIdentifier:_cellIdentifier];
    
    if (self.page.ds) {
        // Pagination
        __weak typeof(self) weakSelf = self;
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            
            [weakSelf loadMore];
            
        }];
        UIActivityIndicatorViewStyle indicatorStyle = UIActivityIndicatorViewStyleWhite;
        if ([[[ROStyle sharedInstance] backgroundColor] ro_lightStyle]) {
            indicatorStyle = UIActivityIndicatorViewStyleGray;
        }
        [self.tableView.infiniteScrollingView setActivityIndicatorViewStyle:indicatorStyle];
    }
}

- (void)dealloc
{
    if (_tableView) {
        if (_tableView.superview) {
            [_tableView removeFromSuperview];
        }
        _tableView = nil;
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.tableViewStyle];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.userInteractionEnabled = YES;
        _tableView.tintColor = [[ROStyle sharedInstance] accentColor];
        _tableView.separatorColor = [[[ROStyle sharedInstance] accentColor] colorWithAlphaComponent:0.5f];
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [[ROStyle sharedInstance] backgroundColor];
        //_tableView.rowHeight = UITableViewAutomaticDimension;
        //_tableView.estimatedRowHeight = [[[ROStyle sharedInstance] tableViewCellHeightMin] floatValue];
    }
    return _tableView;
}

- (void)resetCell:(UITableViewCell *)cell
{
    NSArray* subviews = [cell.contentView subviews];
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
            weakSelf.tableView.showsInfiniteScrolling = YES;
        } else {
            weakSelf.tableView.showsInfiniteScrolling = NO;
        }
        if (weakSelf.tableView.infiniteScrollingView) {
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        }
        [weakSelf loadDataSuccess:items];
        
    } failureBlock:^(ROError *error) {
        
        if (weakSelf.tableView.infiniteScrollingView) {
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        }
        [weakSelf loadDataError:error];
        
    }];
}

- (void)loadDataSuccess:(NSArray *)items
{
    self.items = items;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        
    });
    for (NSObject<ROBehavior> *behavior in self.behaviors) {
        [behavior onDataSuccess];
    }
}

- (void)loadDataError:(ROError *)error
{
    [error show];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];  // Adding this fixes the issue for iPad
    [cell ro_configureSelectedView];
    if (indexPath.row < [self.items count]) {
        [self resetCell:cell];
        [self.tableViewDelegate configureCell:cell atIndexPath:indexPath];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_once(&_onceCellToken, ^{
        _cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    });
    CGFloat heightDefault = [[[ROStyle sharedInstance] tableViewCellHeightMin] floatValue];
    
    CGFloat height = _cell.bounds.size.height;
    if (_dynamicHeightCell) {
        [self.tableViewDelegate configureCell:_cell atIndexPath:indexPath];
        [_cell setNeedsLayout];
        [_cell layoutIfNeeded];
        CGSize size = [_cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        height = size.height + 1;
    }
    
    return MAX(heightDefault, height);
}

@end
