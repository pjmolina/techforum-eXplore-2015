//
//  ROPhoneAction.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 11/05/14.
//

#import "ROUriAction.h"
#import "ROAction.h"

/**
 Call to phone number
 */
@interface ROPhoneAction : ROUriAction<ROAction>

/**
 Phone number has call
 */
@property (nonatomic, strong) NSString *phoneNumber;

/**
 Constructor with phone number value
 @param phoneNumber Phone number
 @return Class instance
 */
- (id)initWithValue:(NSString *)phoneNumber;

@end
