//
//  RONavMenuBasicTableViewController.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/25/14.
//

#import "ROBaseViewController.h"
#import "RONavigationBasicController.h"

/**
 Basic navigation based to ui table view
 */
@interface RONavMenuBasicTableViewController : ROBaseViewController

/**
 Constructor with page and callback for actions
 @param page Page setup
 @param callback the callback for actions
 @return Class instance
 */
- (id)initWithPage:(ROPage *)page callback:(ROActionCallback)callback;

/**
 Show the destination view controller
 @param destinationViewController Destination view controller
 */
- (void)showDestinationViewcontroller:(id)destinationViewController;

@end
