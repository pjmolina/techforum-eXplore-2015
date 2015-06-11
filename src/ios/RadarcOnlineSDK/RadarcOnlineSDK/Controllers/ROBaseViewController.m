//
//  ROBaseViewController.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/9/14.
//

#import "ROBaseViewController.h"
#import "ROTableViewCell.h"
#import "ROCollectionViewCell.h"
#import "UIView+RO.h"
#import "ROStyle.h"
#import "ROItemCell.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "ROPagination.h"
#import "RONavigationAction.h"
#import "RORSSDatasource.h"
#import "ROHtmlDatasource.h"
#import "ROCollectionLocalDatasource.h"
#import <Colours/Colours.h>
#import "NSString+RO.h"
#import "ROChartView.h"
#import "UIAlertView+RO.h"
#import "RONavMenuBasicTableViewController.h"
#import "ROTextTableViewCell.h"
#import "ROImageTableViewCell.h"
#import "ROPhoneAction.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "ROFeedItem.h"
#import "ROCellConstants.h"
#import "ROHeaderTableViewCell.h"
#import "NSBundle+RO.h"
#import "UIImage+RO.h"
#import "ROFilter.h"

static NSInteger const kCollectionNumColsDefault                    = 2;

static CGFloat const kCollectionMarginSection                       = 5.0f;
static CGFloat const kCollectionMinimumInteritemSpacingForSection   = 2.5f;
static CGFloat const kCollectionMinimumLineSpacingForSection        = 5.0f;

@interface ROBaseViewController () <ROFormDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ROChartView *chartView;

@property (nonatomic, assign) ROTableViewCellStyle tableViewCellStyle;
@property (nonatomic, assign) ROCollectionViewCellStyle collectionViewCellStyle;
@property (nonatomic, assign) ROChartType chartType;

@property (nonatomic, strong) NSString *cellIdentifier;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSCache *imagesCache;

@property (nonatomic, strong) UISearchBar *searchBar;

- (void)loadDataView;
- (void)loadTableView;
- (void)loadDetailView;
- (void)loadCollectionView;
- (void)loadWebView;
- (void)loadChartView;
- (void)configureDatasource;
- (void)refreshData;
- (void)loadData;
- (void)refreshDataWithPagination;
- (void)loadDataWithPagination;
- (SVInfiniteScrollingView *)infiniteScrollingView;
- (void)showsInfiniteScroll:(BOOL)shows;
- (void)navigateToDetailAtIndexPath:(NSIndexPath *)indexPath;

- (ROTableViewCell *)cellAtTableView:(UITableView *)tableView style:(ROTableViewCellStyle)cellStyle identifier:(NSString *)identifier;

- (UITableViewCell *)tableView:(UITableView *)tableView detailCellForIndexPath:(NSIndexPath *)indexPath;

- (ROHeaderTableViewCell *)headerCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)configureHeaderCell:(ROHeaderTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForHeaderCellAtIndexPath:(NSIndexPath *)indexPath;

- (ROTextTableViewCell *)textCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)configureTextCell:(ROTextTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForTextCellAtIndexPath:(NSIndexPath *)indexPath;

- (ROImageTableViewCell *)imageCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)configureImageCell:(ROImageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)setImageForCell:(ROImageTableViewCell *)cell item:(ROItemCell *)item;
- (ROImageTableViewCell *)remoteImageCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)configureRemoteImageCell:(ROImageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)setRemoteImageForCell:(ROImageTableViewCell *)cell item:(ROItemCell *)item atIndexPath:(NSIndexPath *)indexPath;
- (void)setImageActionForCell:(ROImageTableViewCell *)cell action:(NSObject<ROAction> *)action;

- (CGFloat)tableView:(UITableView *)tableView detailHeightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)heightForImageCellAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForRemoteImageCellAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)calculateHeightForConfiguredImageCell:(ROImageTableViewCell *)sizingCell;
- (CGFloat)calculateHeightForConfiguredRemoteImageCell:(ROImageTableViewCell *)sizingCell atIndexPath:(NSIndexPath *)indexPath;

- (void)clearImageCache;
- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath atTableView:(UITableView *)tableView;
- (NSString *)keyAtIndexPath:(NSIndexPath *)indexPath;

- (void)openFilter;

@end

@implementation ROBaseViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_imagesCache) {
        [_imagesCache removeAllObjects];
        _imagesCache = nil;
    }
    [self loadDataView];
    [self configureView];
    [self registerCells];
    [self configureDatasource];
    if (_showSearchBar) {
        [self addSearchBar];
    }
    
    if (self.filterController) {
        self.filterController.formDelegate = self;
    }
}

- (void)openFilter
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.filterController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_showSearchBar && _collectionView) {
        [_collectionView setContentOffset:CGPointMake(0, 44)];
    }
    
    if (self.filterController) {
        
        UIBarButtonItem *filterItem = [[UIBarButtonItem alloc] initWithImage:[UIImage ro_imageNamed:@"filter"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self action:@selector(openFilter)];
        
        self.navigationItem.rightBarButtonItem = filterItem;
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_showSearchBar) {
        [self.view endEditing:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (_imagesCache) {
        [_imagesCache removeAllObjects];
        _imagesCache = nil;
    }
    if (_items) {
        _items = nil;
    }
    if (_allPages) {
        _allPages = nil;
    }
    if (_webView) {
        _webView = nil;
    }
    if (_tableView) {
        _tableView = nil;
    }
    if (_detailTableView) {
        _detailTableView = nil;
    }
    if (_collectionView) {
        _collectionView = nil;
    }
    if (_chartView) {
        _chartView = nil;
    }
    if (_dataView) {
        [_dataView removeFromSuperview];
        _dataView = nil;
    }
}

- (ROOptionsFilter *)optionsFilter
{
    if (!_optionsFilter) {
        _optionsFilter = [ROOptionsFilter new];
    }
    return _optionsFilter;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
        _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchBar.delegate = self;
        _searchBar.barTintColor = [[ROStyle sharedInstance] applicationBarBackgroundColor];
        NSArray *subviews = _searchBar.subviews.count == 1 ? [_searchBar.subviews.firstObject subviews] : _searchBar.subviews;
        for (id view in subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)view;
                textField.clearButtonMode = UITextFieldViewModeNever;
                break;
            }
        }
    }
    return _searchBar;
}

#pragma mark - Form delegate

- (void)formSubmitted
{
    self.optionsFilter.filters = self.filterController.filters;
    
    [self refreshDatasource];
}

#pragma mark - Web view delegate

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_tableView == tableView || _detailTableView == tableView) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableView == tableView || _detailTableView == tableView) {
        return [self.items count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ROItemCell *itemCell = [self itemCellAtIndexPath:indexPath];
    if (_tableView == tableView) {
        ROTableViewCell *cell = [self cellAtTableView:tableView style:_tableViewCellStyle identifier:_cellIdentifier];
        cell.item = itemCell;
        if (self.allPages && [self.allPages count] != 0) {
            cell.userInteractionEnabled = YES;
            if (! ([[RONavigationViewController sharedInstance] navigationType] == RONavigationTypeSliding
                   && [self isKindOfClass:[RONavMenuBasicTableViewController class]] )) {
                
                UIImage *image = [UIImage ro_imageNamed:@"arrow"];
                UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [iconImageView setTintColor:[[ROStyle sharedInstance] accentColor]];
                cell.accessoryView = iconImageView;
            }
        }
        return cell;
    } else if (_detailTableView == tableView) {
        return [self tableView:tableView detailCellForIndexPath:indexPath];
    }
    // Return default cell
    return [self textCellAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [[[ROStyle sharedInstance] tableViewCellHeightMin] floatValue];
    if (_tableView == tableView) {
        height = [self tableView:tableView listHeightForRowAtIndexPath:indexPath];
    } else if (_detailTableView == tableView) {
        height = [self tableView:tableView detailHeightForRowAtIndexPath:indexPath];
    }
    return height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableView == tableView || _detailTableView == tableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self didSelectAtIndexPath:indexPath];
    }
}

#pragma mark Collection view layout things

- (NSInteger)collectionNumCols
{
    if (_collectionNumCols == 0) {
        _collectionNumCols = kCollectionNumColsDefault;
    }
    return _collectionNumCols;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_collectionView == collectionView) {
        CGFloat with = self.view.frame.size.width - kCollectionMinimumLineSpacingForSection * 2;
        CGFloat withCols = floorf(with / self.collectionNumCols) - (self.collectionNumCols - 1) * kCollectionMinimumInteritemSpacingForSection;
        return CGSizeMake(withCols, withCols);
    } else {
        return CGSizeZero;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (_collectionView == collectionView) {
        return kCollectionMinimumInteritemSpacingForSection;
    } else {
        return 0.0f;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (_collectionView == collectionView) {
        return kCollectionMinimumLineSpacingForSection;
    } else {
        return 0.0f;
    }
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (_collectionView == collectionView) {
        float top = kCollectionMarginSection;
        if (_showSearchBar) {
            top += self.searchBar.frame.size.height;
        }
        return UIEdgeInsetsMake(top, kCollectionMarginSection, kCollectionMarginSection,kCollectionMarginSection);  // top, left, bottom, right
    } else {
        return UIEdgeInsetsZero;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (_collectionView) {
        [_collectionView performBatchUpdates:nil completion:nil];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self fixSearchBarToScrollView:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self fixSearchBarToScrollView:scrollView];
}

- (void)fixSearchBarToScrollView:(UIScrollView *)scrollView
{
    if (_showSearchBar && _collectionView) {
        CGFloat yOffset  = scrollView.contentOffset.y;
        CGFloat searchBarHeight = self.searchBar.frame.size.height;
        if (yOffset <= 0) {
            [scrollView setContentOffset:CGPointZero animated:YES];
        } else if (yOffset < searchBarHeight / 2) {
            [scrollView setContentOffset:CGPointMake(0, searchBarHeight) animated:YES];
        } else if (yOffset < searchBarHeight) {
            [scrollView setContentOffset:CGPointZero animated:YES];
        }
    }
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_collectionView == collectionView) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        [self didSelectAtIndexPath:indexPath];
    }
}

#pragma mark - Collection View Data Sources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_collectionView == collectionView) {
        return [self.items count];
    } else {
        return 0;
    }
}

// The cell that is returned must be retrieved from a call to - dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_collectionView == collectionView) {
        ROCollectionViewCell *cell = (ROCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell = [[ROCollectionViewCell alloc] initWithROStyle:_collectionViewCellStyle];
        } else {
            cell.style = _collectionViewCellStyle;
        }
        cell.item = [self itemCellAtIndexPath:indexPath];
        return cell;
    } else {
        return nil;
    }
}

#pragma mark - ROBaseViewController

- (NSArray *)items
{
    if (!_items) {
        _items = [NSArray new];
    }
    return _items;
}

- (NSCache *)imagesCache
{
    if (!_imagesCache) {
        _imagesCache = [NSCache new];
    }
    return _imagesCache;
}

- (void)loadDataView
{
    switch (self.page.layoutType) {
        case ROLayoutDetailVertical: {
            [self loadDetailView];
            break;
        }
        case ROLayoutListPhotoTitleBottomDescription: {
            _tableViewCellStyle = ROTableViewCellStylePhotoTitleBottomDescription;
            _cellIdentifier = kTableCellPTBDReuseIdentifier;
            [self loadTableView];
            break;
        }
        case ROLayoutListPhotoTitleDescription: {
            _tableViewCellStyle = ROTableViewCellStylePhotoTitleDescription;
            _cellIdentifier = kTableCellPTDReuseIdentifier;
            [self loadTableView];
            break;
        }
        case ROLayoutListTitleDescription: {
            _tableViewCellStyle = ROTableViewCellStyleTitleDescription;
            _cellIdentifier = kTableCellTDReuseIdentifier;
            [self loadTableView];
            break;
        }
        case ROLayoutMenuTitle: {
            _tableViewCellStyle = ROTableViewCellStyleTitle;
            _cellIdentifier = kTableCellTReuseIdentifier;
            [self loadTableView];
            break;
        }
        case ROLayoutMenuIconTitle: {
            _tableViewCellStyle = ROTableViewCellStylePhotoTitle;
            _cellIdentifier = kTableCellPTReuseIdentifier;
            [self loadTableView];
            break;
        }
        case ROLayoutAlbum: {
            _collectionViewCellStyle = ROCollectionViewCellStylePhoto;
            _cellIdentifier = kCollectionCellPhotoReuseIdentifier;
            [self loadCollectionView];
            break;
        }
        case ROLayoutMenuMosaic: {
            _collectionViewCellStyle = ROCollectionViewCellStylePhotoTitle;
            _cellIdentifier = kCollectionCellPhotoTitleReuseIdentifier;
            [self loadCollectionView];
            break;
        }
        case ROLayoutWeb: {
            [self loadWebView];
            break;
        }
        case ROLayoutChartBars: {
            _chartType = ROChartTypeBar;
            [self loadChartView];
            break;
        }
        case ROLayoutChartLines: {
            _chartType = ROChartTypeLine;
            [self loadChartView];
            break;
        }
        case ROLayoutChartPie: {
            _chartType = ROChartTypePie;
            [self loadChartView];
            break;
        }
        default:
            break;
    }
}

- (void)loadTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 8, 0, 0)];
    }
    [self.view addSubview:_tableView];
    _dataView = _tableView;
}

- (void)loadDetailView
{
    _detailTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _detailTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _detailTableView.backgroundColor = [UIColor clearColor];
    _detailTableView.delegate = self;
    _detailTableView.dataSource = self;
    _detailTableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_detailTableView];
    _dataView = _detailTableView;
}

- (void)loadCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame
                                         collectionViewLayout:flowLayout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    _dataView = _collectionView;
}
 
- (void)loadWebView
{
    _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    _webView.allowsInlineMediaPlayback = YES;
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    _dataView = _webView;
}

- (void)loadChartView
{
    _chartView = [[ROChartView alloc] initWithFrame:self.view.frame];
    _chartView.foregroundColor = [[ROStyle sharedInstance] foregroundColor];
    _chartView.backgroundColor = [[ROStyle sharedInstance] backgroundColor];
    _chartView.fontName = [[ROStyle sharedInstance] fontName];
    _chartView.fontSize = [[[ROStyle sharedInstance] fontSize] floatValue];
    _chartView.chartType = _chartType;
    [self.view addSubview:_chartView];
    _dataView = _chartView;
}

- (void)configureView
{
    [super configureView];
    UIImage *backgroundImage = [[ROStyle sharedInstance] backgroundImage];
    if (backgroundImage) {
        if (_tableView) {
            [_tableView ro_setBackgroundImage:backgroundImage];
        }
        if (_detailTableView) {
            [_detailTableView ro_setBackgroundImage:backgroundImage];
        }
        if (_collectionView) {
            [_collectionView ro_setBackgroundImage:backgroundImage];
        }
        if (_webView) {
            [self.view ro_setBackgroundImage:backgroundImage];
        }
    }
}

- (void)registerCells
{
    if (_tableView) {
        [_tableView registerNib:[UINib nibWithNibName:kTableCellTNibName
                                               bundle:[NSBundle ro_resourcesBundle]] forCellReuseIdentifier:kTableCellTReuseIdentifier];
        
        [_tableView registerNib:[UINib nibWithNibName:kTableCellPTNibName
                                               bundle:[NSBundle ro_resourcesBundle]] forCellReuseIdentifier:kTableCellPTReuseIdentifier];
        
        [_tableView registerNib:[UINib nibWithNibName:kTableCellTDNibName
                                               bundle:[NSBundle ro_resourcesBundle]] forCellReuseIdentifier:kTableCellTDReuseIdentifier];
        
        [_tableView registerNib:[UINib nibWithNibName:kTableCellPTDNibName
                                               bundle:[NSBundle ro_resourcesBundle]] forCellReuseIdentifier:kTableCellPTDReuseIdentifier];
        
        [_tableView registerNib:[UINib nibWithNibName:kTableCellPTBDNibName
                                               bundle:[NSBundle ro_resourcesBundle]] forCellReuseIdentifier:kTableCellPTBDReuseIdentifier];
    }
    if (_collectionView) {
        [_collectionView registerNib:[UINib nibWithNibName:kCollectionCellPhotoNibName
                                                    bundle:[NSBundle ro_resourcesBundle]]
          forCellWithReuseIdentifier:kCollectionCellPhotoReuseIdentifier];
        
        [_collectionView registerNib:[UINib nibWithNibName:kCollectionCellPhotoTitleNibName
                                                    bundle:[NSBundle ro_resourcesBundle]]
          forCellWithReuseIdentifier:kCollectionCellPhotoTitleReuseIdentifier];
    }
    if (_detailTableView) {
        
        [ROTextTableViewCell registerInTableView:self.detailTableView];
        
        [_detailTableView registerNib:[UINib nibWithNibName:kDetailCellImageNibName
                                                     bundle:[NSBundle ro_resourcesBundle]]
               forCellReuseIdentifier:kDetailImageCellReuseIdentifier];
        
        [ROHeaderTableViewCell registerInTableView:self.detailTableView];
    }
}

- (ROItemCell *)itemCellAtIndexPath:(NSIndexPath *)indexPath
{
    ROItemCell *itemCell = nil;
    if ([self.items objectAtIndex:indexPath.row]) {
        if ([[self.items objectAtIndex:indexPath.row] isKindOfClass:[ROItemCell class]]) {
            itemCell = [self.items objectAtIndex:indexPath.row];
        } else {
            itemCell = [[ROItemCell alloc] initWithText1:[[self.items objectAtIndex:indexPath.row] description]];
        }
    }
    return itemCell;
}

- (ROItemCell *)menuItemNavigationAtControllerClass:(Class)class atIconName:(NSString *)iconName
{
    return [[ROItemCell alloc] initWithText1:[class entryPage].label
                             atImageResource:iconName
                                    atAction:[[RONavigationAction alloc] initWithValue:class]];
}

- (ROItemCell *)detailItemNavigationAtControllerClass:(Class)class atIconName:(NSString *)iconName atObj:(id)obj
{
    RONavigationAction *navAction = [[RONavigationAction alloc] initWithValue:class];
    navAction.detailObject = obj;
    return [[ROItemCell alloc] initWithText1:[class entryPage].label
                             atImageResource:iconName
                                    atAction:navAction];
}

- (void)didSelectAtIndexPath:(NSIndexPath *)indexPath
{
    ROItemCell *item = [self itemCellAtIndexPath:indexPath];
    if (item && item.action) {
        [item.action doAction];
    } else if (_allPages && [_allPages count] != 0) {
        [self navigateToDetailAtIndexPath:indexPath];
    }
}

- (void)navigateToDetailAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [self.items objectAtIndex:indexPath.row];
    if (obj) {
        if ([_allPages count] != 0) {
            ROPage *page = [_allPages objectAtIndex:0];
            ROBaseViewController *destinationController = [[page controllerClass] new];
            [destinationController setObj:obj];
            if (destinationController) {
                RONavigationAction *navigationAction = [[RONavigationAction alloc] initWithValue:destinationController];
                [navigationAction doAction];
            }
        }
    } else {
        NSLog(@"Generic object not exists in %s", __PRETTY_FUNCTION__);
    }
}

- (void)doDatasourceSuccess:(NSArray *)items
{
    if ([self.items count] == 0) {
        [SVProgressHUD dismiss];
    }
    if ([items count] == 0) {
        if ([self.items count] == 0) {
            dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5);
            dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Empty result", nil)];
                
            });
        }
    } else {
        self.items = items;
    }
    [self reloadData];
}

- (void)doDatasourceFailure:(NSError *)error atResponse:(NSHTTPURLResponse *)response
{
#ifdef DEBUG
    if (error && error.localizedDescription) {
        NSLog(@"Error in: %s\n%@", __PRETTY_FUNCTION__, error.localizedDescription);
    }
#endif
    [SVProgressHUD dismiss];
    
    NSString *msg = NSLocalizedString(@"There was a problem retrieving data", nil);
    if (response && response.statusCode == 401) {
        msg = NSLocalizedString(@"Authorization required", nil);
    }
    [UIAlertView ro_showWithErrorMessage:msg];
}

- (void)reloadData
{
    if (_detailTableView){
        if([self.items count] > 0){
            // for details, get the first item
            [self setObj:[self.items objectAtIndex:0]];
        }
    }
    if ([self.dataView respondsToSelector:@selector(reloadData)]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.dataView reloadData];
            
        });
    } else if (_webView) {
        if ([self.items count] != 0) {
            NSString *html = nil;
            if ([[self.items objectAtIndex:0] isKindOfClass:[NSString class]]) {
                html = [self.items objectAtIndex:0];
            } else {
                html = [[self.items objectAtIndex:0] description];
#ifdef DEBUG
                NSLog(@"Item must be NSString when datasource is ROHtmlDatasource.\nClass actual: %@\nFixed in %s", NSStringFromClass([self class]),__PRETTY_FUNCTION__);
#endif
            }
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSURL *baseURL = [NSURL fileURLWithPath:path];
            [_webView loadHTMLString:html baseURL:baseURL];
        }
    } else if (_chartView) {
        if ([self.items count] != 0) {
            [self configureChartData:_chartView];
            [_chartView setNeedsDisplay];
        }
    }
}

- (void)configureChartData:(ROChartView *)chartView {
    // Override
}

- (void)refreshDatasource
{
    self.items = [NSArray new];
    if (self.obj) {
        
        [self loadDataDetail];
        
    } else {
        
        if (self.page.ds) {
            
            if (_webView) {
                
                [self loadData];
                
            } else if (_chartView) {
                
                if ([self.page.ds conformsToProtocol:@protocol(ROPagination)]) {
                    
                    [self loadDataWithPagination];

                } else {
                    
                    [self loadData];
                }
                
            } else {
                
                if ([[self.page.ds class] conformsToProtocol:@protocol(ROPagination)]&& self.page.layoutType != ROLayoutDetailVertical) {
                    
                    _pageNum = 0;
                    [self loadDataWithPagination];

                } else {

                    [self loadData];
                    
                }
            }
        }
    }
}

- (void)configureDatasource
{
    if (self.obj) {
        
        [self loadDataDetail];
        
    } else {
        if (self.page.ds) {
            if (_webView) {
                [self loadData];
            } else if (_chartView) {
                if ([self.page.ds conformsToProtocol:@protocol(ROPagination)]) {
                    [self loadDataWithPagination];
                } else {
                    [self loadData];
                }
            } else {
                if ([self.page.ds hasPullToRefresh]) {
                    _refreshControl = [[UIRefreshControl alloc] init];
                    _refreshControl.tintColor = [[ROStyle sharedInstance] foregroundColor];
                    [self.dataView addSubview:_refreshControl];
                }
                if ([[self.page.ds class] conformsToProtocol:@protocol(ROPagination)]&& self.page.layoutType != ROLayoutDetailVertical) {
                    _pageNum = 0;
                    [self loadDataWithPagination];
                    if ([self.page.ds hasPullToRefresh]) {
                        [_refreshControl addTarget:self action:@selector(refreshDataWithPagination) forControlEvents:UIControlEventValueChanged];
                    }
                    __weak typeof(self) weakSelf = self;
                    [self.dataView addInfiniteScrollingWithActionHandler:^{
                        
                        [weakSelf loadDataWithPagination];
                        
                    }];
                    UIActivityIndicatorViewStyle indicatorStyle = UIActivityIndicatorViewStyleWhite;
                    if (![[ROStyle sharedInstance] useStyleLightForColor:[[ROStyle sharedInstance] backgroundColor]]) {
                        indicatorStyle = UIActivityIndicatorViewStyleGray;
                    }
                    [[self infiniteScrollingView] setActivityIndicatorViewStyle:indicatorStyle];
                } else {
                    [self loadData];
                    if ([self.page.ds hasPullToRefresh]) {
                        [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
                    }
                }
            }
        }
    }
}

- (SVInfiniteScrollingView *)infiniteScrollingView
{
    if (_tableView) {
        return _tableView.infiniteScrollingView;
    } else if (_collectionView) {
        return _collectionView.infiniteScrollingView;
    }
    return nil;
}

- (void)showsInfiniteScroll:(BOOL)shows
{
    if (_tableView) {
        _tableView.showsInfiniteScrolling = shows;
    } else if (_collectionView) {
        _collectionView.showsInfiniteScrolling = shows;
    }
    if (shows) {
        [[self infiniteScrollingView] stopAnimating];
    }
}

- (void)refreshData
{
    [self clearImageCache];
    __weak typeof(self) weakSelf = self;
    [weakSelf.page.ds loadWithOptionsFilter:_optionsFilter onSuccess:^(NSArray *objects) {
        
        weakSelf.items = nil;
        [weakSelf doDatasourceSuccess:objects];
        [_refreshControl endRefreshing];
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response) {
        
        [weakSelf doDatasourceFailure:error atResponse:response];
        [_refreshControl endRefreshing];
        
    }];
}

- (void)loadData
{
    if ([self.items count] == 0 && (![self.page.ds isKindOfClass:[ROHtmlDatasource class]] && ![self.page.ds isKindOfClass:[ROCollectionLocalDatasource class]])) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }
    __weak typeof(self) weakSelf = self;
    [weakSelf.page.ds loadWithOptionsFilter:_optionsFilter onSuccess:^(NSArray *objects) {
        
        [weakSelf doDatasourceSuccess:objects];
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response) {
        
        [weakSelf doDatasourceFailure:error atResponse:response];
        
    }];
}

- (void)refreshDataWithPagination
{
    _pageNum = 0;
    [self clearImageCache];
    __weak typeof(self) weakSelf = self;
    __weak id <ROPagination> dsPag = (id<ROPagination>)weakSelf.page.ds;
    [dsPag loadPageNum:_pageNum withOptionsFilter:_optionsFilter onSuccess:^(NSArray *objects) {
        
        weakSelf.items = nil;
        [weakSelf showsInfiniteScroll:YES];
        if (objects && [objects count] != 0) {
            if ([objects count] < [dsPag pageSize]) {
                [weakSelf showsInfiniteScroll:NO];
            }
            [weakSelf doDatasourceSuccess:objects];
            _pageNum++;
        } else {
            [weakSelf doDatasourceSuccess:objects];
            [weakSelf showsInfiniteScroll:NO];
        }
        [_refreshControl endRefreshing];
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response) {
        
        [weakSelf doDatasourceFailure:error atResponse:response];
        [_refreshControl endRefreshing];
        
    }];
}

- (void)loadDataWithPagination
{
    if ([self.items count] == 0) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }
    __weak typeof(self) weakSelf = self;
    __weak id <ROPagination> dsPag = (id<ROPagination>)weakSelf.page.ds;
    [dsPag loadPageNum:_pageNum withOptionsFilter:_optionsFilter onSuccess:^(NSArray *objects) {
        
        if (objects && [objects count] != 0) {
            if ([objects count] < [dsPag pageSize]) {
                [weakSelf showsInfiniteScroll:NO];
            }
            NSArray *newItems = [self.items arrayByAddingObjectsFromArray:objects];
            [weakSelf doDatasourceSuccess:newItems];
            _pageNum++;
        } else {
            [weakSelf doDatasourceSuccess:objects];
            [weakSelf showsInfiniteScroll:NO];
        }
        if ([weakSelf infiniteScrollingView]) {
            [[weakSelf infiniteScrollingView] stopAnimating];
        }
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response) {
        
        [weakSelf doDatasourceFailure:error atResponse:response];
        if ([weakSelf infiniteScrollingView]) {
            [[weakSelf infiniteScrollingView] stopAnimating];
        }
        
    }];
}

- (void)loadDataDetail
{
    NSMutableArray *itemsDetail = [NSMutableArray new];
    NSArray *itemsTmp = self.items;
    for (id item in itemsTmp) {
        if ([item isKindOfClass:[ROItemCell class]]) {
            ROItemCell *itemCell = (ROItemCell *)item;
            if (![itemCell isEmpty]) {
                [itemsDetail addObject:itemCell];
            }
        }
    }
    self.items = [itemsDetail copy];
    if ([self.items count] == 0) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"No items to show", nil)];
    }
}

#pragma mark - Search bar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (!searchBar.showsCancelButton) {
        [searchBar setShowsCancelButton:YES animated:YES];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (searchBar.showsCancelButton) {
        [searchBar setShowsCancelButton:NO animated:YES];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text && [[searchBar.text ro_trim] length] != 0) {
        [self searchBy:searchBar.text];
    } else {
        [self searchBy:nil];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    [self searchBy:nil];
}

- (void)searchBy:(NSString *)searchText
{
    [self.view endEditing:YES];
    self.optionsFilter.searchText = searchText;
    if ([self.page.ds conformsToProtocol:@protocol(ROPagination)]) {
        [self refreshDataWithPagination];
    } else {
        [self refreshData];
    }
}

- (void)addSearchBar
{
    if (_tableView) {
        _tableView.tableHeaderView = self.searchBar;
        [_tableView setContentOffset:CGPointMake(0, self.searchBar.frame.size.height)];
    } else if (_collectionView) {
        [_collectionView setContentOffset:CGPointMake(0, self.searchBar.frame.size.height)];
        [_collectionView addSubview:self.searchBar];
    }
}

#pragma mark - Cells

- (ROTableViewCell *)cellAtTableView:(UITableView *)tableView
                               style:(ROTableViewCellStyle)cellStyle
                          identifier:(NSString *)identifier
{
    ROTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ROTableViewCell alloc] initWithROStyle:cellStyle reuseIdentifier:identifier];
    } else {
        cell.style = cellStyle;
    }
    cell.backgroundColor = [UIColor clearColor];  // Adding this fixes the issue for iPad
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    ROItemCell *itemCell = [self itemCellAtIndexPath:indexPath];
    if ([cell isKindOfClass:[ROTableViewCell class]]) {
        ROTableViewCell *roCell = (ROTableViewCell *)cell;
        roCell.item = itemCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView listHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForCellAtIndexPath:indexPath];
}

- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    static ROTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    });
    sizingCell.style = _tableViewCellStyle;
    [self configureCell:sizingCell forIndexPath:indexPath];
    return [sizingCell requiredRowHeightInTableView:self.tableView];
}

#pragma mark - Detail / Custom view

- (UITableViewCell *)tableView:(UITableView *)tableView detailCellForIndexPath:(NSIndexPath *)indexPath
{
    ROItemCell *itemCell = [self itemCellAtIndexPath:indexPath];
    if (itemCell.text1) {
        if ([self.page.ds isKindOfClass:[RORSSDatasource class]]) {
                return [self textCellAtIndexPath:indexPath];
        } else {
            return [self textCellAtIndexPath:indexPath];
        }
    } else if (itemCell.text2) {
        return [self headerCellAtIndexPath:indexPath];
    } else if (itemCell.imageResource) {
        return [self imageCellAtIndexPath:indexPath];
    } else if (itemCell.imageUrl) {
        return [self remoteImageCellAtIndexPath:indexPath];
    }
    return [self textCellAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView detailHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ROItemCell *itemCell = [self itemCellAtIndexPath:indexPath];
    if (itemCell.text1) {
        if ([self.page.ds isKindOfClass:[RORSSDatasource class]]) {
            return [self heightForTextCellAtIndexPath:indexPath];
        } else {
            return [self heightForTextCellAtIndexPath:indexPath];
        }
    } else if (itemCell.text2) {
        return [self heightForHeaderCellAtIndexPath:indexPath];
    } else if (itemCell.imageResource) {
        return [self heightForImageCellAtIndexPath:indexPath];
    } else if (itemCell.imageUrl) {
        return [self heightForRemoteImageCellAtIndexPath:indexPath];
    }
    return [self heightForTextCellAtIndexPath:indexPath];
}

#pragma mark - Header text cell

- (ROHeaderTableViewCell *)headerCellAtIndexPath:(NSIndexPath *)indexPath
{
    ROHeaderTableViewCell *cell = [ROHeaderTableViewCell tableView:self.detailTableView cellForIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];  // Adding this fixes the issue for iPad
    [self configureHeaderCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureHeaderCell:(ROHeaderTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ROItemCell *itemCell = [self itemCellAtIndexPath:indexPath];
    [cell configureCellWithHeaderText:itemCell.text2];
}

- (CGFloat)heightForHeaderCellAtIndexPath:(NSIndexPath *)indexPath
{
    static ROHeaderTableViewCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [self.detailTableView dequeueReusableCellWithIdentifier:kHeaderCellReuseIdentifier];
    });
    [self configureHeaderCell:cell atIndexPath:indexPath];
    return [cell requiredRowHeightInTableView:self.detailTableView];
}

#pragma mark - Detail text cell

- (ROTextTableViewCell *)textCellAtIndexPath:(NSIndexPath *)indexPath
{
    ROTextTableViewCell *cell = [ROTextTableViewCell tableView:self.detailTableView cellForIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];  // Adding this fixes the issue for iPad
    [self configureTextCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureTextCell:(ROTextTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ROItemCell *itemCell = [self itemCellAtIndexPath:indexPath];
    [cell configureCellWithText:itemCell.text1];
    [cell configureCellWithAction:itemCell.action];
}

- (CGFloat)heightForTextCellAtIndexPath:(NSIndexPath *)indexPath
{
    static ROTextTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.detailTableView dequeueReusableCellWithIdentifier:kDetailTextCellReuseIdentifier];
    });
    [self configureTextCell:sizingCell atIndexPath:indexPath];
    return [sizingCell requiredRowHeightInTableView:self.detailTableView];
}

#pragma mark - Detail image cell

- (ROImageTableViewCell *)imageCellAtIndexPath:(NSIndexPath *)indexPath
{
    ROImageTableViewCell *cell = [self.detailTableView dequeueReusableCellWithIdentifier:kDetailImageCellReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    [self configureImageCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureImageCell:(ROImageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ROItemCell *itemCell = [self itemCellAtIndexPath:indexPath];
    [self setImageForCell:cell item:itemCell];
    [self setImageActionForCell:cell action:itemCell.action];
}

- (void)setImageForCell:(ROImageTableViewCell *)cell item:(ROItemCell *)item
{
    UIImage *image = [UIImage imageNamed:item.imageResource];
    if (!image) {
        image = [[ROStyle sharedInstance] noPhotoImage];
    }
    cell.customImageView.image = image;
}

- (ROImageTableViewCell *)remoteImageCellAtIndexPath:(NSIndexPath *)indexPath
{
    ROImageTableViewCell *cell = [self.detailTableView dequeueReusableCellWithIdentifier:kDetailImageCellReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    [self configureRemoteImageCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureRemoteImageCell:(ROImageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ROItemCell *itemCell = [self itemCellAtIndexPath:indexPath];
    [self setRemoteImageForCell:cell item:itemCell atIndexPath:(NSIndexPath *)indexPath];
    [self setImageActionForCell:cell action:itemCell.action];
}

- (void)setRemoteImageForCell:(ROImageTableViewCell *)cell item:(ROItemCell *)item atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath) {
        NSString *key = [self keyAtIndexPath:indexPath];
        UIImage *image = [self.imagesCache objectForKey:key];
        if (image) {
            cell.customImageView.image = image;
        } else {
            __weak typeof(self) weakSelf = self;
            __weak typeof(NSIndexPath) *weakIndexPath = indexPath;
            UIActivityIndicatorViewStyle indicatorStyle = UIActivityIndicatorViewStyleWhite;
            if (![[ROStyle sharedInstance] useStyleLightForColor:[[ROStyle sharedInstance] backgroundColor]]) {
                indicatorStyle = UIActivityIndicatorViewStyleGray;
            }
            [cell.customImageView setImageWithURL:[NSURL URLWithString:item.imageUrl]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (!image) {
                    image = [[ROStyle sharedInstance] noPhotoImage];
                }
                if (weakIndexPath) {
                    NSString *key = [self keyAtIndexPath:weakIndexPath];
                    [weakSelf.imagesCache setObject:image forKey:key];
                }
#ifdef DEBUG
                if (error) {
                    NSLog(@"\n\n%s\nError: %@\n\n", __PRETTY_FUNCTION__, error.debugDescription);
                }
#endif
                [self reloadRowAtIndexPath:weakIndexPath atTableView:weakSelf.detailTableView];
                
            } usingActivityIndicatorStyle:indicatorStyle];
        }
    }
}

- (void)setImageActionForCell:(ROImageTableViewCell *)cell action:(NSObject<ROAction> *)action
{
    cell.userInteractionEnabled = NO;
    [cell.customImageView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    if (action) {
        if ([action isKindOfClass:[ROPhoneAction class]] && (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)) {
            cell.userInteractionEnabled = NO;
        } else {
            cell.userInteractionEnabled = YES;
            if ([action actionIcon]) {
                UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[action actionIcon]];
                iconImageView.center = cell.customImageView.center;
                [iconImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
                [cell.customImageView addSubview:iconImageView];
                NSLayoutConstraint *myConstraint =[NSLayoutConstraint
                                                   constraintWithItem:iconImageView
                                                   attribute:NSLayoutAttributeCenterX
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:cell.customImageView
                                                   attribute:NSLayoutAttributeCenterX
                                                   multiplier:1.0
                                                   constant:0];
                NSLayoutConstraint *myConstraint2 =[NSLayoutConstraint
                                                    constraintWithItem:iconImageView
                                                    attribute:NSLayoutAttributeCenterY
                                                    relatedBy:NSLayoutRelationEqual
                                                    toItem:cell.customImageView
                                                    attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                    constant:0];
                [cell.customImageView addConstraint:myConstraint];
                [cell.customImageView addConstraint:myConstraint2];
            }
        }
    }
}

- (CGFloat)heightForImageCellAtIndexPath:(NSIndexPath *)indexPath
{
    static ROImageTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.detailTableView dequeueReusableCellWithIdentifier:kDetailImageCellReuseIdentifier];
    });
    
    [self configureImageCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredImageCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredImageCell:(ROImageTableViewCell *)sizingCell
{
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.detailTableView.bounds), 0.0f);
    
    CGFloat height = 304.0f;
    UIImage *image = sizingCell.customImageView.image;
    if (image) {
        if (image.size.width > CGRectGetWidth(self.detailTableView.bounds)) {
            float ratio = image.size.width / image.size.height;
            CGSize newSize = CGSizeMake(CGRectGetWidth(self.detailTableView.bounds), CGRectGetWidth(self.detailTableView.bounds) / ratio);
            height = newSize.height;
        } else {
            height = image.size.height;
        }
        height += 8.0f; // Add margin
    }
    return height;
}

- (CGFloat)heightForRemoteImageCellAtIndexPath:(NSIndexPath *)indexPath
{
    static ROImageTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.detailTableView dequeueReusableCellWithIdentifier:kDetailImageCellReuseIdentifier];
    });
    
    [self configureRemoteImageCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredRemoteImageCell:sizingCell atIndexPath:indexPath];
}

- (CGFloat)calculateHeightForConfiguredRemoteImageCell:(ROImageTableViewCell *)sizingCell atIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 304.0f;
    if (indexPath) {
        NSString *key = [self keyAtIndexPath:indexPath];
        UIImage *image = [self.imagesCache objectForKey:key];
        if (image) {
            if (image.size.width > CGRectGetWidth(self.detailTableView.bounds)) {
                float ratio = image.size.width / image.size.height;
                CGSize newSize = CGSizeMake(CGRectGetWidth(self.detailTableView.bounds), CGRectGetWidth(self.detailTableView.bounds) / ratio);
                height = newSize.height;
            } else {
                height = image.size.height;
            }
            height += 8.0f; // Add margin
        }
    }
    return height;
}

- (void)clearImageCache
{
    if (self.items && [self.items count] != 0) {
        for (id item in self.items) {
            if ([item isKindOfClass:[ROItemCell class]]) {
                ROItemCell *itemCell = (ROItemCell *)item;
                if (itemCell.imageUrl) {
                    [[SDImageCache sharedImageCache] removeImageForKey:itemCell.imageUrl fromDisk:YES];
                }
            } else if ([item isKindOfClass:[ROFeedItem class]]) {
                ROFeedItem *itemFeed = (ROFeedItem *)item;
                if (itemFeed.mediaThumbnail) {
                    [[SDImageCache sharedImageCache] removeImageForKey:itemFeed.mediaThumbnail fromDisk:YES];
                }
                if (itemFeed.mediaContent) {
                    [[SDImageCache sharedImageCache] removeImageForKey:itemFeed.mediaContent fromDisk:YES];
                }
                if (itemFeed.mediaContentAlt) {
                    [[SDImageCache sharedImageCache] removeImageForKey:itemFeed.mediaContentAlt fromDisk:YES];
                }
            }
        }
    }
    if (_imagesCache) {
        [_imagesCache removeAllObjects];
        _imagesCache = nil;
    }
}

- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath atTableView:(UITableView *)tableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (indexPath) {
            @try {
                [tableView beginUpdates];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView endUpdates];
            }
            @catch (NSException *exception) {
#ifdef DEBUG
                if (exception && exception.debugDescription) {
                    NSLog(@"\n%s\n%@", __PRETTY_FUNCTION__, exception.debugDescription);
                } else {
                    NSLog(@"\n%s\nERROR to reload detail table view", __PRETTY_FUNCTION__);
                }
#endif
            }
            @finally {}
        }
        
    });
}

- (NSString *)keyAtIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row];
}

@end
