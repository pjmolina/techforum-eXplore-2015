//
//  RONavigationViewController.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/24/14.
//

#import "ROViewController.h"
#import "ROLoginViewController.h"
#import "ROKillSwitchViewController.h"

@class ECSlidingViewController;
@class RONavigationBasicController;
@class RONavigationPageControlViewController;

/**
 Navigation type options
 */
typedef NS_ENUM(NSInteger, RONavigationType) {
    /** Navigation basic based to table view */
    RONavigationTypeBasic,
    /** Navigation sliding based to table view on the left and show the main view in the front */
    RONavigationTypeSliding,
    /** Navigation custom, you can be create new navigation menu */
    RONavigationTypeCustom
};

/**
 block type for action (ie logout) callbacks in navigation tables
 */
typedef void (^ROActionCallback)(NSInteger index);

/**
 Main navigation controller.
 Allows create and show the main navigation menu
 */
@interface RONavigationViewController : ROViewController

/**
 Main navigation
 */
@property (nonatomic, strong) id mainNavigationViewController;

/**
 Login View Controller
 */
@property (nonatomic, strong) ROLoginViewController *loginViewController;

/**
 Kill switch controller
 */
@property (nonatomic, strong) ROKillSwitchViewController *ksViewController;

/**
 Retrieve main navigation depends of the navigation type
 */
@property (nonatomic, assign) RONavigationType navigationType;

/**
 Retrieve UI Navigation view controller
 @return Navigation view controller
 */
@property (nonatomic, strong) UINavigationController *navigationController;

/**
 Pages navigation
 */
@property (nonatomic, strong) NSArray *pages;

/**
 actions
 */
@property (nonatomic, strong) NSArray *actions;

/**
 Singleton
 @return Class instance
 */
+ (instancetype)sharedInstance;

/**
 Retrieve sliding navigation controller
 @return Sliding navigation controller
 */
- (ECSlidingViewController *)retrieveNavigationSlidingWithActionCallback:(ROActionCallback) callback;

/**
 Retrieve basic navigation controller
 @return Basic navigation controller
 */
- (RONavigationBasicController *)retrieveNavigationBasicWithActionCallback:(ROActionCallback) callback;

/**
 Retrieve custom navigation controller
 @return Custom navigation controller
 */
- (id)retrieveNavigationCustomWithActionCallback:(ROActionCallback) callback;

@end
