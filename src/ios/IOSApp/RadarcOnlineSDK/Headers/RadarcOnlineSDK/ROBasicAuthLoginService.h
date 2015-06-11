//
//  ROBasicAuthLoginService.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L.
//
//

#import <Foundation/Foundation.h>
#import "ROLoginService.h"

@interface ROBasicAuthLoginService : NSObject <ROLoginService>
+ (instancetype)sharedInstance:(NSURL *)baseUrl;
-(instancetype)initWithBaseUrl:(NSURL *)baseUrl;
@end
