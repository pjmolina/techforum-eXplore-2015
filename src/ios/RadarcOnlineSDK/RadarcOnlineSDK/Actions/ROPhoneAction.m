//
//  ROPhoneAction.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 11/05/14.
//

#import "ROPhoneAction.h"
#import "UIImage+RO.h"

@implementation ROPhoneAction

- (id)initWithValue:(NSString *)phoneNumber
{
    NSMutableString *uri = [[NSMutableString alloc] initWithString:@"telprompt:"];
    if (phoneNumber) {
        [uri appendString:[phoneNumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    self = [super initWithUri:uri
                       atIcon:[UIImage ro_imageNamed:@"phone"]];
    if (self) {
        _phoneNumber = phoneNumber;
    }
    return self;
}

@end
