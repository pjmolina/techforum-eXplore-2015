//
//  ROKillSwitchControllerViewController.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 10/2/14.
//
//

#import <UIKit/UIKit.h>

typedef void (^KSSuccessBlock)();

@interface ROKillSwitchViewController : UIViewController
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *message;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *logoimage;

/**
 Sets the success callback for a timed out application
 @param success The success block
 */
- (void)setOnSuccessBlock:(KSSuccessBlock)success;

- (id)initWithTimeout:(int) timeout;

- (BOOL)checkTrialStatus;

- (void)showExpiredTrialMessage;

@end
