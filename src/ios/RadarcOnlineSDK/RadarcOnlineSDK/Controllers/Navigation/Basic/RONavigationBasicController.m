//
//  RONavigationBasicController.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/25/14.
//

#import "RONavigationBasicController.h"
#import "RONavMenuBasicTableViewController.h"
#import "ROPage.h"

@interface RONavigationBasicController ()

@end

@implementation RONavigationBasicController

#pragma mark - RONavigationBasicController

- (id) initWithPages:(NSArray *)pages atPage:(ROPage *)page callback:(ROActionCallback)callback
{
    if (!page) {
        page = [[self class] entryPage];
    }
    RONavMenuBasicTableViewController *menuTableViewController = [[RONavMenuBasicTableViewController alloc] initWithPage:page
                                                                                                                callback:callback];
    menuTableViewController.allPages = pages;
    self = [super initWithRootViewController:menuTableViewController];
    if (self) {
        self.navigationBar.translucent = NO;
    }
    return self;
}

+ (ROPage *)entryPage
{
    ROPage *page = [[ROPage alloc] init];
    page.label = NSLocalizedString(@"Select an option", nil);
    page.layoutType = ROLayoutMenuTitle;
    return page;
}

@end
