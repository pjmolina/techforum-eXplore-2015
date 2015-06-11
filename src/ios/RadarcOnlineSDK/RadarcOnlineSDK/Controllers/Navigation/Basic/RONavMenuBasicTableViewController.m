//
//  RONavMenuBasicTableViewController.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/25/14.
//

#import "RONavMenuBasicTableViewController.h"
#import "ROPage.h"
#import "ROItemCell.h"

@interface RONavMenuBasicTableViewController ()
@property (nonatomic, strong) ROActionCallback callback;
@end

@implementation RONavMenuBasicTableViewController

- (id)initWithPage:(ROPage *)page callback:(ROActionCallback)callback;
{
    self = [super initWithPage:page];
    if(self){
        self.callback = callback;
    }
    return self;
}

- (void)didSelectAtIndexPath:(NSIndexPath *)indexPath
{
    ROPage *page = [self.allPages objectAtIndex:indexPath.row];
    id viewController = [page viewController];
    // check if it's a controller navigation or an action
    if(viewController){
        [self showDestinationViewcontroller:viewController];
    } else if(self.callback){
        self.callback(indexPath.row);
    }
}

#pragma mark - RONavMenuBasicTableViewController

- (void)setAllPages:(NSArray *)allPages
{
    super.allPages = allPages;
    NSMutableArray *itemsTmp = [[NSMutableArray alloc] initWithCapacity:allPages.count];
    for (NSInteger i=0; i!= [allPages count]; i++) {
        if ([[allPages objectAtIndex:i] isKindOfClass:[ROPage class]]) {
            ROPage *page = (ROPage *)[allPages objectAtIndex:i];
            [itemsTmp addObject:[[ROItemCell alloc] initWithText1:page.label]];
        }
    }
    self.items = [itemsTmp copy];
}

- (void)showDestinationViewcontroller:(id)destinationViewController
{
    [self.navigationController pushViewController:destinationViewController animated:YES];
}

@end
