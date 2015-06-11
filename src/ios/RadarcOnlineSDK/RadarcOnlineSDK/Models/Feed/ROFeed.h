//
//  ROFeed.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/2/14.
//

#import <Foundation/Foundation.h>

@class ROFeedImage;

@interface ROFeed : NSObject

@property (nonatomic, strong) NSString *feedId;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *links;
@property (nonatomic, strong) NSString *feedDescription;
@property (nonatomic, strong) NSDate *lastBuildDate;
@property (nonatomic, strong) NSDate *pubDate;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *generator;
@property (nonatomic, strong) ROFeedImage *feedImage;
@property (nonatomic, strong) NSMutableArray *feedItems;

@end
