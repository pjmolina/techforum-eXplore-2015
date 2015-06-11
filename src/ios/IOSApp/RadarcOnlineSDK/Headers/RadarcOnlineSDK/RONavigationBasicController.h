//
//  RONavigationBasicController.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/25/14.
//

#import <UIKit/UIKit.h>

typedef void (^ROActionCallback)(NSInteger index);

@class ROPage;

/**
 Basic navigation based to ui table view that link to other views and show it in the same view
 */
@interface RONavigationBasicController : UINavigationController

/**
 Constructor with pages and page config
 @param pages Pages navigation
 @param page Page config
 @return Class instance
 */
- (id) initWithPages:(NSArray *)pages atPage:(ROPage *)page callback:(ROActionCallback)callback;

/**
 Entry page.
 @return Entry page
 */
+ (ROPage *)entryPage;

@end
