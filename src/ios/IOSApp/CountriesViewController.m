//
//  CountriesViewController.h
//  EXplore101
//
//  This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
//

#import "CountriesViewController.h"
#import "CountriesDetailViewController.h"
#import "UILabel+RO.h"
#import "ROTextStyle.h"
#import "ROTableViewCell.h"
#import "RONavigationAction.h"
#import "ROPage.h"
#import "ROListDataLoader.h"
#import "ROOptionsFilter.h"
#import "AppnowItem.h"
#import "CountriesDS.h"

@interface CountriesViewController () <ROTableViewDelegate>

@property (nonatomic, strong) ROOptionsFilter *optionsFilter;

@end

@implementation CountriesViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.dataLoader = [[ROListDataLoader alloc] initWithDatasource:self.page.ds 
                                                         optionsFilter:self.optionsFilter];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableViewDelegate = self;
    
    [self loadData];
}

- (ROOptionsFilter *)optionsFilter
{
    if (!_optionsFilter) {
        _optionsFilter = [ROOptionsFilter new];
    }
    return _optionsFilter;
}

+ (ROPage *)entryPage
{
    return [[ROPage alloc] initWithLabel:NSLocalizedString(@"countries", nil)
                            atLayoutType:ROLayoutListTitleDescription
                       atControllerClass:[self class]
                            atDatasource:[CountriesDS new]];
}

#pragma mark - Data delegate

- (void)loadData
{
    [super loadData];
}

- (void)loadDataSuccess:(id)dataObject
{
    [super loadDataSuccess:dataObject];
}

- (void)loadDataError:(ROError *)error
{
    [super loadDataError:error];
}

#pragma mark - ROTableViewDelegate

- (void)configureCell:(ROTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    AppnowItem *item = self.items[(NSUInteger)indexPath.row];
    cell.text1Label.text = item.name;

    [cell.text1Label ro_style:[ROTextStyle style:ROFontSizeStyleMedium
                                            bold:NO
                                          italic:NO
                                    textAligment:NSTextAlignmentLeft]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppnowItem *item = self.items[(NSUInteger)indexPath.row];
    RONavigationAction *navAction = [[RONavigationAction alloc] initWithValue:[CountriesDetailViewController class]];
    navAction.detailObject = item;
    [navAction doAction];   
}

@end
