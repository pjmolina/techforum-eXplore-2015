//
//  ROFeedItem.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/2/14.
//

#import <Foundation/Foundation.h>
#import "ROFeedItemAuthor.h"

@interface ROFeedItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *link; // url
@property (nonatomic, strong) NSString *guid;
@property (nonatomic, strong) NSDate *pubDate;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, strong) ROFeedItemAuthor *author;
@property (nonatomic, strong) NSString *comments; // url
@property (nonatomic, strong) NSString *mediaTitle;
@property (nonatomic, strong) NSString *mediaThumbnail; // url
@property (nonatomic, strong) NSString *mediaContent; // url
@property (nonatomic, strong) NSString *mediaContentAlt;

@end
