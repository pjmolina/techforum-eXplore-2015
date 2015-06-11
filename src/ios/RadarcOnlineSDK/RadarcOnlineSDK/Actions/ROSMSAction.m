//
//  ROSMSAction.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 11/05/14.
//

#import "ROSMSAction.h"

@implementation ROSMSAction

- (id)initWithValue:(NSString *)phoneNumber
{
    NSMutableString *uri = [[NSMutableString alloc] initWithString:@"sms:"];
    if (phoneNumber) {
        [uri appendString:[phoneNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    self = [super initWithUri:uri atIcon:nil];
    if (self) {
        _phoneNumber = phoneNumber;
    }
    return self;
}

@end
