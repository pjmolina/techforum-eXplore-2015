//
//  ROFeedImage.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/2/14.
//

#import "ROFeedImage.h"

@implementation ROFeedImage

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n{\n\turl: %@,\n\ttitle: %@,\n\tlink: %@\n}", _url, _title, _link];
}

@end
