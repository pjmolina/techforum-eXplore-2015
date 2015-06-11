//
//  ROFeedAuthor.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/2/14.
//

#import "ROFeedItemAuthor.h"

@implementation ROFeedItemAuthor

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n{\n\tname: %@,\n\temail: %@,\n\turi: %@\n}", _name, _email, _uri];
}

@end
