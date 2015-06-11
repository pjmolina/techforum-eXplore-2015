//
//  ROMapSearchAction.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 11/05/14.
//

#import "ROMapSearchAction.h"

@implementation ROMapSearchAction

- (id)initWithValue:(NSString *)location
{
    NSMutableString *uri = [[NSMutableString alloc] initWithString:@"q="];
    if (location) {
        [uri appendString:location];
    }
    self = [super initWithValue:uri];
    if (self) {
        _location = location;
    }
    return self;
}

@end
