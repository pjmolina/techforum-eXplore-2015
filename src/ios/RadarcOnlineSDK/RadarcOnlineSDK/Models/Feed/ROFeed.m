//
//  ROFeed.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/2/14.
//

#import "ROFeed.h"
#import "ROFeedImage.h"

@implementation ROFeed

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n{\n\tfeedId : %@,\n\tversion: %@,\n\ttitle: %@,\n\tlinks: %@,\n\tfeedDescription: %@,\n\tlastBuildDate: %@,\n\tpubDate: %@,\n\tlanguage: %@,\n\tgenerator: %@,\n\tfeedImage: %@,\n\tfeedItems: %@\n}", _feedId, _version, _title, [_links description], _feedDescription, _lastBuildDate, _pubDate, _language, _generator, [_feedImage description], [_feedItems description]];
    
}

@end
