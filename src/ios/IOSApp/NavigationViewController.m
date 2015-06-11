//
//  NavigationViewController.h
//  EXplore101
//
//  This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
//

#import "NavigationViewController.h"
#import "ROPage.h"
#import "OfficesViewController.h"
#import "CountriesViewController.h"
#import "SolutionsViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (id)init {
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    NSString *name = [info objectForKey:@"CFBundleDisplayName"];
    self = [super initWithPage:[[ROPage alloc] initWithLabel:name
                                                atLayoutType:ROLayoutMenuTitle
                                                 atImageName:nil
                                           atControllerClass:[self class]
                                                atDatasource:nil]];
    if (self) {
        self.pages = @[
                       [OfficesViewController entryPage],
                       [CountriesViewController entryPage],
                       [SolutionsViewController entryPage]
                      ];
    }
    return self;
}

@end
