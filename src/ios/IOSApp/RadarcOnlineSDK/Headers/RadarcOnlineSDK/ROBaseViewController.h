//
//  ROBaseViewController.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/9/14.
//

#import <UIKit/UIKit.h>
#import "ROViewController.h"
#import "ROPage.h"
#import "ROChartView.h"
#import "ROOptionsFilter.h"
#import "ROFormViewController.h"

@class ROItemCell;

/**
 Generic ui view controller
 */
@interface ROBaseViewController : ROViewController<UITableViewDataSource,UITableViewDelegate, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIWebViewDelegate,UISearchBarDelegate>

/**
 Items to load
 */
@property (nonatomic, strong) NSArray *items;

/**
 All child pages
 */
@property (nonatomic, strong) NSArray *allPages;

/**
 Generic object to process
 */
@property (nonatomic, strong) id obj;

/**
 Number of columns when the page is grid type
 */
@property (nonatomic, assign) NSInteger collectionNumCols;

/**
 Data view. Options: UIWebView, UITableView, UICollectionView
 */
@property (nonatomic, strong) id dataView;

/**
 Datasource options filter
 */
@property (nonatomic, strong) ROOptionsFilter *optionsFilter;

/**
 Show search bar
 */
@property (nonatomic, assign) BOOL showSearchBar;

/**
 Filter view controller
 */
@property (nonatomic, strong) ROFormViewController *filterController;

/**
 Register all cell types.
 */
- (void)registerCells;

/**
 Retrieve item cell at index path
 @param indexPath Index path
 @return Item cell
 */
- (ROItemCell *)itemCellAtIndexPath:(NSIndexPath *)indexPath;

/**
 Retrieve menu item
 @param class Controller class
 @param iconName Resource image name
 @return Item cell
 */
- (ROItemCell *)menuItemNavigationAtControllerClass:(Class)class atIconName:(NSString *)iconName;

/**
 Retrieve detail item
 @param class Controller class
 @param iconName Resource image name
 @param obj Generic object to process
 @return Item cell
 */
- (ROItemCell *)detailItemNavigationAtControllerClass:(Class)class atIconName:(NSString *)iconName atObj:(id)obj;

/**
 Event on tap cell at index path
 @param indexPath Index path
 */
- (void)didSelectAtIndexPath:(NSIndexPath *)indexPath;

/**
 Datasource process on success
 @param items Items of datasource
 */
- (void)doDatasourceSuccess:(NSArray *)items;

/**
 Datasource process on failure
 @param error Error loading
 @param response Http response
 */
- (void)doDatasourceFailure:(NSError *)error atResponse:(NSHTTPURLResponse *)response;

/**
 Reload data
 */
- (void)reloadData;

/**
 Refresh datasource
 */
- (void)refreshDatasource;

/**
 Load data in detail view
 */
- (void)loadDataDetail;

/**
 Configure chart data
 @param chartView Chart view
 */
- (void)configureChartData:(ROChartView *)chartView;

@end
