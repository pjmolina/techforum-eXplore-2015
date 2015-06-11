//
//  OfficesViewController.h
//  EXplore101
//
//  This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
//

#import "OfficesViewController.h"
#import "OfficesDetailViewController.h"
#import "UILabel+RO.h"
#import "ROTextStyle.h"
#import "ROTableViewCell.h"
#import "RONavigationAction.h"
#import "ROPage.h"
#import "ROListDataLoader.h"
#import "ROOptionsFilter.h"
#import "AppnowSchema3Item.h"
#import "OfficesDS.h"

@interface OfficesViewController () <ROTableViewDelegate>

@property (nonatomic, strong) ROOptionsFilter *optionsFilter;

@end

@implementation OfficesViewController

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
    return [[ROPage alloc] initWithLabel:NSLocalizedString(@"offices", nil)
                            atLayoutType:ROLayoutListTitleDescription
                       atControllerClass:[self class]
                            atDatasource:[OfficesDS new]];
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
    AppnowSchema3Item *item = self.items[(NSUInteger)indexPath.row];
    cell.text1Label.text = [NSString stringWithFormat:@"%@%@", item.name, item.city];
    cell.text2Label.text = item.country;

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
    AppnowSchema3Item *item = self.items[(NSUInteger)indexPath.row];
    RONavigationAction *navAction = [[RONavigationAction alloc] initWithValue:[OfficesDetailViewController class]];
    navAction.detailObject = item;
    [navAction doAction];   
}

@end
