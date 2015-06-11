//
//  ROFeedBaseParser.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/14/14.
//

#import "ROFeedBaseParser.h"
#import "ROFeed.h"

@implementation ROFeedBaseParser

- (id)initWithParser:(NSXMLParser *)parser
{
    self = [super init];
    if (self) {
        self.feed = [[ROFeed alloc] init];
        self.parser = parser;
        [self parse];
    }
    return self;
}

- (id)initWithParser:(NSXMLParser *)parser onSuccessBlock:(ROFeedParserSuccessBlock)successBlock onFailureBlock:(ROFeedParserFailureBlock)failureBlock
{
    self = [super init];
    if (self) {
        self.successBlock = successBlock;
        self.failureBlock = failureBlock;
        self.feed = [[ROFeed alloc] init];
        self.parser = parser;
        [self parse];
    }
    return self;
}

- (void)parse
{
    //Override
}

@end
