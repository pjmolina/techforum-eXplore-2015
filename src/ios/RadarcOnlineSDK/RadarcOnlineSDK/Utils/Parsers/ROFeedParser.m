//
//  ROFeedParser.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/6/14.
//

#import "ROFeedParser.h"
#import "RORSSDictionaryParser.h"

@implementation ROFeedParser

- (id)init
{
    self = [super init];
    if (self) {
        _type = ROFeedParserTypeDictionary;
    }
    return self;
}

- (id)initWithType:(ROFeedParserType)type
{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)parseAtParser:(NSXMLParser *)parser onSuccessBlock:(ROFeedParserSuccessBlock)successBlock onFailureBlock:(ROFeedParserFailureBlock)failureBlock
{
    switch (_type) {
        case ROFeedParserTypeDictionary: {
            _feedParser = [[RORSSDictionaryParser alloc] initWithParser:parser onSuccessBlock:successBlock onFailureBlock:failureBlock];
            break;
        }
        default:
            break;
    }
}

@end
