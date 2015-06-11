//
//  SolutionsDetailViewController.h
//  EXplore101
//
//  This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
//

#import "SolutionsDetailViewController.h"
#import "ROTextStyle.h"
#import "ROShareBehavior.h"
#import "ROPage.h"
#import "ROImageCellDescriptor.h"
#import "ROTextCellDescriptor.h"
#import "ROHeaderCellDescriptor.h"
#import "ROOptionsFilter.h"
#import "ROSingleDataLoader.h"
#import "AppnowSchema2Item.h"
#import "SolutionsDS.h"

@interface SolutionsDetailViewController () <ROCustomTableViewDelegate>

@property (nonatomic, strong) ROOptionsFilter *optionsFilter;

@end

@implementation SolutionsDetailViewController

- (id)init
{
    self = [super init];
    if (self) {

        [self.behaviors addObject:[ROShareBehavior behaviorViewController:self]];

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
                            atDatasource:[SolutionsDS new]];
}

#pragma mark - ROCustomTableViewDelegate

- (void)configureWithDataItem:(AppnowSchema2Item *)item
{
    self.title = item.service;
   
    self.items = @[                            
                   [ROHeaderCellDescriptor text:@"Category"],
                   [ROTextCellDescriptor text:item.category action:nil textStyle:[ROTextStyle style:ROFontSizeStyleMedium bold:NO italic:NO textAligment:NSTextAlignmentLeft]]
                  ];
}

@end
