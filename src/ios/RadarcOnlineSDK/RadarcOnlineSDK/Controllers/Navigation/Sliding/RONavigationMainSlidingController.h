//
//  RONavigationMainSlidingController.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/25/14.
//

#import <UIKit/UIKit.h>

/**
 Navigation main view.
 */
@interface RONavigationMainSlidingController : UINavigationController

/**
 Configure view controller and load the navigation menu button
 */
- (void)configureViewController;

/**
 Show or hide the navigation menu
 */
- (void)revealNavigationMenu;

/**
 Show or hide the options menu
 */
- (void)revealOptionsMenu;

/**
 Load top view controller 
 @param viewController View controller
 */
- (void)setTopViewController:(id)viewController;

@end
