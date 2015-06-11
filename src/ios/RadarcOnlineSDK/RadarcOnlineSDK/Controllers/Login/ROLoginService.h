//
//  ROLoginService.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L.
//
//

#import <Foundation/Foundation.h>
#import "ROLoginResponse.h"

typedef void (^ROLoginServiceSuccessBlock)(ROLoginResponse *loginResponse);
typedef void (^ROLoginServiceFailureBlock)(NSError *error, NSHTTPURLResponse *response);

@protocol ROLoginService <NSObject>

/**
 Logs in a user, given its username and password. Upon login or failure, a corresponding callback is called
 */
- (void) loginUser:(NSString *)userName withPassword:(NSString *)password withAppId:(NSString *)appId
           success:(ROLoginServiceSuccessBlock)success
           failure:(ROLoginServiceFailureBlock)failure;

@end
