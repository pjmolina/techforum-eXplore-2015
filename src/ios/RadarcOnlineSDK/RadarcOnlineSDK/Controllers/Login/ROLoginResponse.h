//
//  ROLoginResponse.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 8/20/14.
//
//

#import <Foundation/Foundation.h>
#import "ROModel.h"

@interface ROLoginResponse : NSObject <ROModelDelegate>

@property (nonatomic, assign) double expirationTime;
@property (nonatomic, strong) NSString *token;

@end
