//
//  RONavigationMainSlidingController.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/25/14.
//

#import "RONavigationMainSlidingController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "UIImage+RO.h"

@interface RONavigationMainSlidingController ()

/**
 Add navigation menu button to navigation bar
 */
- (void)configureNavOptions;

@end

@implementation RONavigationMainSlidingController

#pragma mark - RONavigationMainSlidingController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self configureViewController];
    }
    return self;
}

- (void)configureViewController
{
    self.navigationBar.translucent = NO;
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    [self configureNavOptions];
}

- (void)revealNavigationMenu
{
    ECSlidingViewController *slidingController = self.slidingViewController;
    if (slidingController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionCentered) {
        [slidingController anchorTopViewToRightAnimated:YES];
    } else {
        [slidingController resetTopViewAnimated:YES];
    }
}

- (void)revealOptionsMenu
{
    ECSlidingViewController *slidingController = self.slidingViewController;
    if (slidingController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionCentered) {
        [slidingController anchorTopViewToLeftAnimated:YES];
    } else {
        [slidingController resetTopViewAnimated:YES];
    }
}

- (void)setTopViewController:(id)viewController
{
    [self setViewControllers:@[viewController]];
    [self configureNavOptions];
}

- (void)configureNavOptions
{
    UIBarButtonItem *navButton = [[UIBarButtonItem alloc] initWithImage:[UIImage ro_imageNamed:@"NavMenu"]
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(revealNavigationMenu)];
    self.topViewController.navigationItem.leftBarButtonItem = navButton;
    if (self.slidingViewController.underRightViewController) {
        UIBarButtonItem *navButton = [[UIBarButtonItem alloc] initWithImage:[UIImage ro_imageNamed:@"NavMenu"]
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(revealOptionsMenu)];
        self.topViewController.navigationItem.rightBarButtonItem = navButton;
    }
}

@end
