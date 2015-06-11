//
//  RONavigationMenuSlidingController.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/25/14.
//

#import "RONavigationMenuSlidingController.h"
#import "RONavMenuSlidingTableViewController.h"
#import "ROPage.h"

@interface RONavigationMenuSlidingController ()

@end

@implementation RONavigationMenuSlidingController

#pragma mark - RONavigationMenuSlidingController

- (id)initWithPages:(NSArray *)pages atPage:(ROPage *)page callback:(ROActionCallback)callback
{
    if (!page) {
        page = [[self class] entryPage];
    }
    RONavMenuSlidingTableViewController *menuTableViewController =
            [[RONavMenuSlidingTableViewController alloc] initWithPage:page
                                                             callback:callback];
    menuTableViewController.allPages = pages;
    self = [super initWithRootViewController:menuTableViewController];
    if (self) {
        self.navigationBar.translucent = NO;
    }
    return self;
}

@end
