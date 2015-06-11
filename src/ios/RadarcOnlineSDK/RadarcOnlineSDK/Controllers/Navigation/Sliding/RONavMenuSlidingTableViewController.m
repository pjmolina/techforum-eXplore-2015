//
//  RONavMenuSlidingTableViewController.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/25/14.
//

#import "RONavMenuSlidingTableViewController.h"
#import "RONavigationMainSlidingController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface RONavMenuSlidingTableViewController ()

@end

@implementation RONavMenuSlidingTableViewController

#pragma mark - RONavMenuSlidingTableViewController

- (void)showDestinationViewcontroller:(id)destinationViewController
{
    ECSlidingViewController *slidingController = self.slidingViewController;
    RONavigationMainSlidingController *nav = (RONavigationMainSlidingController *)slidingController.topViewController;
    [nav setTopViewController:destinationViewController];
    [slidingController resetTopViewAnimated:YES onComplete:^{

    }];
}

@end
