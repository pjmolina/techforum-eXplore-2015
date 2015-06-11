//
//  ROLoginViewController.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L.
//
//

#import <UIKit/UIKit.h>
#import "ROViewController.h"

typedef void (^ROLoginSuccessBlock)();
typedef void (^ROLoginFailureBlock)();

@interface ROLoginViewController : ROViewController
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *appNameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *emailTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *passTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *loginButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *appIconImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *loginView;

/**
 Initialize the controller
 @param baseUrl the url base for the login service <urlbase>/login/<appid>
 @param appId the App id
 */
- (id)initWithBaseUrl:(NSString *)baseUrl appId:(NSString *)appId;

/**
 Resets the controller to its initial state
 */
- (void) reset;

/**
 Login button callback
 */
- (IBAction)onLogin:(id)sender;

/**
 Sets the login success or failure callback
 @param success The success block
 @param failure the failure block
 */
- (void)setOnSuccessBlock:(ROLoginSuccessBlock)success onFailureBlock:(ROLoginFailureBlock)failure;

@end
