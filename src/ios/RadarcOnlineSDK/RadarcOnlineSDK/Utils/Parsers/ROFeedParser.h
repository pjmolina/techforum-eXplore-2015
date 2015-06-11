//
//  ROFeedParser.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/6/14.
//

#import <Foundation/Foundation.h>
#import "ROFeed.h"
#import "ROFeedBaseParser.h"

typedef NS_ENUM(NSInteger, ROFeedParserType) {
    ROFeedParserTypeDictionary = 0
};

@interface ROFeedParser : NSObject

@property (nonatomic, strong) id feedParser;
@property (nonatomic, assign) ROFeedParserType type;

- (id)initWithType:(ROFeedParserType)type;

- (void)parseAtParser:(NSXMLParser *)parser onSuccessBlock:(ROFeedParserSuccessBlock)successBlock onFailureBlock:(ROFeedParserFailureBlock)failureBlock;

@end
