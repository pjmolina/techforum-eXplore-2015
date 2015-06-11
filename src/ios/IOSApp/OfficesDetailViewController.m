//
//  OfficesDetailViewController.h
//  EXplore101
//
//  This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
//

#import "OfficesDetailViewController.h"
#import "ROPhoneAction.h"
#import "ROTextStyle.h"
#import "ROPage.h"
#import "ROImageCellDescriptor.h"
#import "ROTextCellDescriptor.h"
#import "ROHeaderCellDescriptor.h"
#import "ROOptionsFilter.h"
#import "ROSingleDataLoader.h"
#import "AppnowSchema3Item.h"
#import "OfficesDS.h"

@interface OfficesDetailViewController () <ROCustomTableViewDelegate>

@property (nonatomic, strong) ROOptionsFilter *optionsFilter;

@end

@implementation OfficesDetailViewController

- (id)init
{
    self = [super init];
    if (self) {


        self.dataLoader = [[ROSingleDataLoader alloc] initWithDatasource:self.page.ds 
                                                           optionsFilter:self.optionsFilter];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.customTableViewDelegate = self;
    
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
    return [[ROPage alloc] initWithLabel:nil
                            atLayoutType:ROLayoutDetailVertical
                       atControllerClass:[self class]
                            atDatasource:[OfficesDS new]];
}

#pragma mark - ROCustomTableViewDelegate

- (void)configureWithDataItem:(AppnowSchema3Item *)item
{
    self.title = item.name;
   
    self.items = @[                            
                   [ROImageCellDescriptor imageString:item.imageUrl action:nil],
                   [ROTextCellDescriptor text:[NSString stringWithFormat:@"%@%@", @"City: ", item.city] action:nil textStyle:[ROTextStyle style:ROFontSizeStyleMedium bold:NO italic:NO textAligment:NSTextAlignmentLeft]],
                   [ROTextCellDescriptor text:item.address action:nil textStyle:[ROTextStyle style:ROFontSizeStyleMedium bold:NO italic:NO textAligment:NSTextAlignmentLeft]],
                   [ROTextCellDescriptor text:item.name action:nil textStyle:[ROTextStyle style:ROFontSizeStyleMedium bold:NO italic:NO textAligment:NSTextAlignmentLeft]],
                   [ROTextCellDescriptor text:item.phone action:[[ROPhoneAction alloc] initWithValue:item.phone] textStyle:[ROTextStyle style:ROFontSizeStyleMedium bold:NO italic:NO textAligment:NSTextAlignmentLeft]]
                  ];
}

@end
