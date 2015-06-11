//
//  ROFeedItem.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/2/14.
//

#import "ROFeedItem.h"

@implementation ROFeedItem

- (NSString *)description
{
    return [NSString stringWithFormat:@"{title: %@,summary: %@,content: %@,link: %@,guid: %@,pubDate: %@,updated: %@,categories: %@,author: %@,comments: %@,mediaTitle: %@,mediaThumbnail: %@,mediaContent: %@,mediaContentAlt: %@}",
            _title,
            _summary,
            _content,
            _link,
            _guid,
            [_pubDate description],
            [_updated description],
            [_categories description],
            [_author description],
            _comments,
            _mediaTitle,
            _mediaThumbnail,
            _mediaContent,
            _mediaContentAlt];
}

@end
