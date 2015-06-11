//
//  ROFeedBaseParser.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/14/14.
//

#import <Foundation/Foundation.h>

@class ROFeed;

typedef void (^ROFeedParserSuccessBlock)(ROFeed *feed);
typedef void (^ROFeedParserFailureBlock)(NSError *error);

@interface ROFeedBaseParser : NSObject

@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) ROFeed *feed;
@property (nonatomic, strong) ROFeedParserSuccessBlock successBlock;
@property (nonatomic, strong) ROFeedParserFailureBlock failureBlock;

@property (nonatomic, assign) BOOL isAtom;
@property (nonatomic, assign) BOOL isContent;
@property (nonatomic, assign) BOOL isDC;
@property (nonatomic, assign) BOOL isMedia;
@property (nonatomic, assign) BOOL isRDF;
@property (nonatomic, assign) BOOL isYT;

- (id)initWithParser:(NSXMLParser *)parser
      onSuccessBlock:(ROFeedParserSuccessBlock)successBlock
      onFailureBlock:(ROFeedParserFailureBlock)failureBlock;

- (id)initWithParser:(NSXMLParser *)parser;

- (void)parse;

@end
