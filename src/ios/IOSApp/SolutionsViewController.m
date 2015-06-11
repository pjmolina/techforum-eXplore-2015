//
//  SolutionsViewController.h
//  EXplore101
//
//  This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
//

#import "SolutionsViewController.h"
#import "SolutionsDetailViewController.h"
#import "UILabel+RO.h"
#import "ROTextStyle.h"
#import "ROTableViewCell.h"
#import "RONavigationAction.h"
#import "ROPage.h"
#import "ROListDataLoader.h"
#import "ROOptionsFilter.h"
#import "AppnowSchema2Item.h"
#import "SolutionsDS.h"

@interface SolutionsViewController () <ROTableViewDelegate>

@property (nonatomic, strong) ROOptionsFilter *optionsFilter;

@end

@implementation SolutionsViewController

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
    return [[ROPage alloc] initWithLabel:NSLocalizedString(@"solutions", nil)
                            atLayoutType:ROLayoutListTitleDescription
                       atControllerClass:[self class]
                            atDatasource:[SolutionsDS new]];
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
    AppnowSchema2Item *item = self.items[(NSUInteger)indexPath.row];
    cell.text1Label.text = item.service;
    cell.text2Label.text = item.category;

    [cell.text1Label ro_style:[ROTextStyle style:ROFontSizeStyleMedium
                                            bold:NO
                                          italic:NO
                                    textAligment:NSTextAlignmentLeft]];

    [cell.text2Label ro_style:[ROTextStyle style:ROFontSizeStyleSmall
                                            bold:NO
                                          italic:NO
                                    textAligment:NSTextAlignmentLeft]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppnowSchema2Item *item = self.items[(NSUInteger)indexPath.row];
    RONavigationAction *navAction = [[RONavigationAction alloc] initWithValue:[SolutionsDetailViewController class]];
    navAction.detailObject = item;
    [navAction doAction];   
}

@end
