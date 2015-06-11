//
//  ROWebContent.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/25/14.
//

#import "ROWebContent.h"

@implementation ROWebContent

- (id)initWithContent:(NSString *)content
{
    self = [super init];
    if (self) {
        _content = content;
    }
    return self;
}

@end
