//
//  RORSSDictionaryParser.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/6/14.
//

#import "RORSSDictionaryParser.h"
#import "XMLDictionary.h"
#import "NSString+RO.h"
#import "ROFeed.h"
#import "ROFeedItem.h"
#import "ROFeedItemAuthor.h"
#import "NSDate+RO.h"
#import "RORSSNameSpace.h"
#import "ROFeedImage.h"

@interface RORSSDictionaryParser ()

@property (nonatomic, strong) NSDictionary *dic;

- (void)processRSS;
- (void)processFeed;
- (void)processRDF;
- (void)process;
- (ROFeedItem *)rssItemAtDictionary:(NSDictionary *)itemDic;
- (ROFeedItem *)feedItemAtDictionary:(NSDictionary *)itemDic;
- (ROFeedItem *)rdfItemAtDictionary:(NSDictionary *)itemDic;
- (NSMutableArray *)categoriesAtDictionary:(NSDictionary *)itemDic;

@end

@implementation RORSSDictionaryParser

- (void)parse
{
    _dic =[[XMLDictionaryParser sharedInstance] dictionaryWithParser:self.parser];
    if (_dic) {
        self.isAtom = (([_dic valueForKey:@"_xmlns"] && [[_dic valueForKey:@"_xmlns"] ro_isEqualToStringCI:kNameSpaceAtom]));
        self.isContent = ([_dic valueForKey:@"_xmlns:content"] && [[_dic valueForKey:@"_xmlns:content"] ro_isEqualToStringCI:kNameSpaceContent]);
        self.isDC = ([_dic valueForKey:@"_xmlns:dc"] && [[_dic valueForKey:@"_xmlns:dc"] ro_isEqualToStringCI:kNameSpaceDC]);
        self.isMedia = ([_dic valueForKey:@"_xmlns:media"] && [[_dic valueForKey:@"_xmlns:media"] ro_isEqualToStringCI:kNameSpaceMedia]);
        self.isRDF = ([_dic objectForKey:@"_xmlns:rdf"] && [[_dic objectForKey:@"_xmlns:rdf"] ro_isEqualToStringCI:kNameSpaceRDF]);
        self.isYT = ([_dic valueForKey:@"_xmlns:yt"] && [[_dic valueForKey:@"_xmlns:yt"] ro_isEqualToStringCI:kNameSpaceYT]);
        [self process];
    } else {
        NSError *error = [self.parser parserError];
        if (self.failureBlock && error) {
            self.failureBlock(error);
        }
    }
}

- (void)process
{
    if ([[_dic valueForKey:XMLDictionaryNodeNameKey] ro_isEqualToStringCI:@"feed"]) {
        [self processFeed];
    } else if ([[_dic valueForKey:XMLDictionaryNodeNameKey] ro_isEqualToStringCI:@"rdf"] || [[_dic valueForKey:XMLDictionaryNodeNameKey] ro_isEqualToStringCI:@"rdf:RDF"]) {
        [self processRDF];
    } else {
        [self processRSS];
    }
}

- (id)valueForKeyPath:(NSString *)key atDictionary:(NSDictionary *)dic atDictionaryKey:(NSString *)dicKey
{
    if (!dicKey) {
        dicKey = XMLDictionaryTextKey;
    }
    id value = [dic valueForKeyPath:key];
    if ([value isKindOfClass:[NSDictionary class]]) {
        value = [value valueForKeyPath:dicKey];
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSMutableArray *objs = [[NSMutableArray alloc] init];
        for (id obj in value) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                if ([obj valueForKeyPath:dicKey]) {
                    [objs addObject:[obj valueForKeyPath:dicKey]];
                }
            } else if ([obj isKindOfClass:[NSString class]]) {
                [objs addObject:obj];
            }
        }
        value = [objs copy];
    }
    return value;
}

- (id)valueForKeyPath:(NSString *)key atDictionary:(NSDictionary *)dic
{
    return [self valueForKeyPath:key atDictionary:dic atDictionaryKey:nil];
}

- (NSMutableArray *)arrayForKeyPath:(NSString *)key atDictionary:(NSDictionary *)dic
{
    NSMutableArray *array = nil;
    if ([[dic valueForKeyPath:key] isKindOfClass:[NSArray class]]) {
        array = [dic valueForKeyPath:key];
    } else if ([[dic valueForKeyPath:key] isKindOfClass:[NSString class]]) {
        array = [[NSMutableArray alloc] initWithArray:@[ [dic valueForKeyPath:key] ]];
    }
    return array;
}

- (void)processFeed
{
    self.feed.title = [self valueForKeyPath:@"title" atDictionary:_dic];
    self.feed.language = [self valueForKeyPath:@"language" atDictionary:_dic];
    if (!self.feed.language) {
        self.feed.language = [self valueForKeyPath:@"dc:language" atDictionary:_dic];
    }
    self.feed.generator = [self valueForKeyPath:@"generator" atDictionary:_dic];
    self.feed.feedId = [self valueForKeyPath:@"id" atDictionary:_dic];
    self.feed.lastBuildDate = [self valueForKeyPath:@"updated" atDictionary:_dic];
    self.feed.links = [self valueForKeyPath:@"link" atDictionary:_dic atDictionaryKey:@"_href"];
    self.feed.feedDescription = [self valueForKeyPath:@"subtitle" atDictionary:_dic atDictionaryKey:XMLDictionaryTextKey];
    
    if ([[_dic objectForKey:@"entry"] isKindOfClass:[NSArray class]]) {
        NSArray *items = [_dic objectForKey:@"entry"];
        self.feed.feedItems = [[NSMutableArray alloc] initWithCapacity:[items count]];
        for (NSDictionary *itemDic in items) {
            [self.feed.feedItems addObject:[self feedItemAtDictionary:itemDic]];
        }
    } else if ([[_dic objectForKey:@"entry"] isKindOfClass:[NSDictionary class]]) {
        self.feed.feedItems = [[NSMutableArray alloc] initWithCapacity:1];
        [self.feed.feedItems addObject:[self feedItemAtDictionary:[_dic objectForKey:@"entry"]]];
    }
    if (self.successBlock) {
        self.successBlock(self.feed);
    }
}

- (void)processRSS
{
    self.feed.version = [_dic valueForKey:@"_version"];
    self.feed.title = [_dic valueForKeyPath:@"channel.title"];
    self.feed.language = [_dic valueForKeyPath:@"channel.language"];
    if (self.feed.language == nil) {
        self.feed.language = [_dic valueForKeyPath:@"channel.dc:language"];
    }
    self.feed.generator = [_dic valueForKeyPath:@"channel.generator"];
    self.feed.feedDescription = [_dic valueForKeyPath:@"channel.description"];
    if ([_dic valueForKeyPath:@"channel.lastBuildDate"]) {
        self.feed.lastBuildDate = [NSDate dateWithValue:[_dic valueForKeyPath:@"channel.lastBuildDate"]];
    }
    if ([_dic valueForKeyPath:@"channel.date"]) {
        self.feed.pubDate = [NSDate dateWithValue:[_dic valueForKeyPath:@"channel.date"]];
    }
    if ([_dic valueForKeyPath:@"channel.pubDate"]) {
        self.feed.pubDate = [NSDate dateWithValue:[_dic valueForKeyPath:@"channel.pubDate"]];
    }

    self.feed.links = [self arrayForKeyPath:@"channel.link" atDictionary:_dic];
    if ([_dic valueForKeyPath:@"channel.image"]) {
        self.feed.feedImage = [[ROFeedImage alloc] init];
        self.feed.feedImage.url = [_dic valueForKeyPath:@"channel.image.url"];
        self.feed.feedImage.link = [_dic valueForKeyPath:@"channel.image.link"];
        self.feed.feedImage.title = [_dic valueForKeyPath:@"channel.image.title"];
    }
    
    if ([[_dic valueForKeyPath:@"channel.item"] isKindOfClass:[NSArray class]]) {
        NSArray *items = [_dic valueForKeyPath:@"channel.item"];
        self.feed.feedItems = [[NSMutableArray alloc] initWithCapacity:[items count]];
        for (NSDictionary *itemDic in items) {
            [self.feed.feedItems addObject:[self rssItemAtDictionary:itemDic]];
        }
    } else if ([[_dic valueForKeyPath:@"channel.item"] isKindOfClass:[NSDictionary class]]) {
        self.feed.feedItems = [[NSMutableArray alloc] initWithCapacity:1];
        [self.feed.feedItems addObject:[self rssItemAtDictionary:[_dic valueForKeyPath:@"channel.item"]]];
    }
    if (self.successBlock) {
        self.successBlock(self.feed);
    }
}

- (void)processRDF
{
    self.feed.title = [_dic valueForKeyPath:@"channel.title"];
    self.feed.language = [_dic valueForKeyPath:@"channel.language"];
    if (self.feed.language == nil) {
        self.feed.language = [_dic valueForKeyPath:@"channel.dc:language"];
    }
    self.feed.generator = [_dic valueForKeyPath:@"channel.generator"];
    self.feed.feedDescription = [_dic valueForKeyPath:@"channel.description"];
    if ([_dic valueForKeyPath:@"channel.lastBuildDate"]) {
        self.feed.lastBuildDate = [NSDate dateWithValue:[_dic valueForKeyPath:@"channel.lastBuildDate"]];
    }
    if ([_dic valueForKeyPath:@"channel.dc:date"]) {
        self.feed.pubDate = [NSDate dateWithValue:[_dic valueForKeyPath:@"channel.dc:date"]];
    }
    if ([_dic valueForKeyPath:@"channel.pubDate"]) {
        self.feed.pubDate = [NSDate dateWithValue:[_dic valueForKeyPath:@"channel.pubDate"]];
    }
    
    self.feed.links = [self arrayForKeyPath:@"channel.link" atDictionary:_dic];
    if ([_dic valueForKeyPath:@"image"]) {
        self.feed.feedImage = [[ROFeedImage alloc] init];
        self.feed.feedImage.title = [_dic valueForKeyPath:@"image.title"];
        self.feed.feedImage.url = [_dic valueForKeyPath:@"image.url"];
        self.feed.feedImage.link = [_dic valueForKeyPath:@"image.link"];
    }
    
    if ([[_dic valueForKeyPath:@"item"] isKindOfClass:[NSArray class]]) {
        NSArray *items = [_dic valueForKeyPath:@"item"];
        self.feed.feedItems = [[NSMutableArray alloc] initWithCapacity:[items count]];
        for (NSDictionary *itemDic in items) {
            [self.feed.feedItems addObject:[self rdfItemAtDictionary:itemDic]];
        }
    } else if ([[_dic valueForKeyPath:@"item"] isKindOfClass:[NSDictionary class]]) {
        self.feed.feedItems = [[NSMutableArray alloc] initWithCapacity:1];
        [self.feed.feedItems addObject:[self rdfItemAtDictionary:[_dic valueForKeyPath:@"item"]]];
    }
    if (self.successBlock) {
        self.successBlock(self.feed);
    }
}

- (ROFeedItem *)feedItemAtDictionary:(NSDictionary *)itemDic
{
    ROFeedItem *feedItem = [[ROFeedItem alloc] init];
    if ([itemDic valueForKeyPath:@"author"]) {
        feedItem.author = [[ROFeedItemAuthor alloc] init];
        feedItem.author.name = [itemDic valueForKeyPath:@"author.name"];
        feedItem.author.email = [itemDic valueForKeyPath:@"author.email"];
        feedItem.author.uri = [itemDic valueForKeyPath:@"author.uri"];
    }
    feedItem.guid = [itemDic valueForKey:@"id"];
    feedItem.mediaThumbnail = [itemDic valueForKeyPath:@"media:thumbnail._url"];
    if (!feedItem.mediaThumbnail) {
        id thumbnail = [itemDic valueForKeyPath:@"media:group.media:thumbnail._url"];
        if ([thumbnail isKindOfClass:[NSString class]]) {
            feedItem.mediaThumbnail = thumbnail;
        } else if ([thumbnail isKindOfClass:[NSArray class]]) {
            feedItem.mediaThumbnail = [thumbnail objectAtIndex:0];
        }
    }
    id link = [itemDic objectForKey:@"link"];
    if (link) {
        if ([link isKindOfClass:[NSDictionary class]]) {
            feedItem.link = [link valueForKey:@"_href"];
        } else if ([link isKindOfClass:[NSArray class]]) {
            for (NSDictionary *linkDic in link) {
                if ([[linkDic objectForKey:@"_rel"] ro_isEqualToStringCI:@"alternate"]) {
                    feedItem.link = [linkDic valueForKey:@"_href"];
                } else if ([[linkDic objectForKey:@"_type"] ro_isEqualToStringCI:@"image/jpeg"] || [[linkDic objectForKey:@"_type"] ro_isEqualToStringCI:@"image/jpg"] || [[linkDic objectForKey:@"_type"] ro_isEqualToStringCI:@"image/png"]) {
                    if (!feedItem.mediaThumbnail) {
                        feedItem.mediaThumbnail = [linkDic valueForKey:@"_href"];
                    }
                }
            }

        }
    }
    id categories = [itemDic valueForKeyPath:@"category"];
    if (categories) {
        if ([categories isKindOfClass:[NSDictionary class]]) {
            feedItem.categories = [[NSMutableArray alloc] initWithObjects:[itemDic valueForKeyPath:@"category._term"], nil];
        } else if ([categories isKindOfClass:[NSArray class]]) {
            feedItem.categories = [[NSMutableArray alloc] initWithCapacity:[categories count]];
            for (NSDictionary *category in categories) {
                if ([category valueForKeyPath:@"_term"]) {
                    [feedItem.categories addObject:[category valueForKeyPath:@"_term"]];
                }
            }
        }
    }
    feedItem.summary = [itemDic valueForKey:@"summary"];
    if (!feedItem.summary) {
        feedItem.summary = [itemDic valueForKey:@"description"];
    }
    if (!feedItem.summary) {
        feedItem.summary = [itemDic valueForKeyPath:@"media:group.media:description.__text"];
    }
    feedItem.content = [itemDic valueForKeyPath:@"content.__text"];
    if (!feedItem.content) {
        feedItem.content = feedItem.summary;
    }
    if (!feedItem.mediaThumbnail && feedItem.content) {
        feedItem.mediaThumbnail = [feedItem.content ro_firstImgUrl];
    }
    feedItem.comments = [itemDic valueForKey:@"comments"];
    if (!feedItem.comments) {
        feedItem.comments = [itemDic valueForKeyPath:@"gd:comments.gd:feedLink._href"];
    }
    feedItem.pubDate = ([itemDic valueForKey:@"published"] ? [NSDate dateWithValue:[itemDic valueForKey:@"published"]] : nil);
    feedItem.updated = ([itemDic valueForKey:@"updated"] ? [NSDate dateWithValue:[itemDic valueForKey:@"updated"]] : nil);
    id title = [itemDic objectForKey:@"title"];
    if (title) {
        if ([title isKindOfClass:[NSString class]]) {
            feedItem.title = title;
        } else if ([title isKindOfClass:[NSDictionary class]]) {
            feedItem.title = [title valueForKey:XMLDictionaryTextKey];
        }
    }
    return feedItem;
}

- (ROFeedItem *)rssItemAtDictionary:(NSDictionary *)itemDic
{
    ROFeedItem *feedItem = [[ROFeedItem alloc] init];
    feedItem.link = [itemDic valueForKey:@"link"];
    feedItem.author = [ROFeedItemAuthor new];
    feedItem.author.name = [itemDic valueForKey:@"creator"];
    if (!feedItem.author.name) {
        feedItem.author.name = [itemDic valueForKey:@"dc:creator"];
    }
    if (!feedItem.author.name) {
        feedItem.author.name = [itemDic valueForKey:@"author"];
    }
    id guid = [itemDic objectForKey:@"guid"];
    if ([guid isKindOfClass:[NSString class]]) {
        feedItem.guid = guid;
    } else if ([guid isKindOfClass:[NSDictionary class]]) {
        feedItem.guid = [guid valueForKey:XMLDictionaryTextKey];
    }
    feedItem.mediaThumbnail = [itemDic valueForKeyPath:@"media:thumbnail._url"];
    feedItem.categories = [self categoriesAtDictionary:itemDic];
    feedItem.summary = [itemDic valueForKey:@"description"];
    feedItem.content = [itemDic valueForKey:@"content"];
    if (!feedItem.content) {
        feedItem.content = [itemDic valueForKeyPath:@"content:encoded"];
    }
    if (!feedItem.content) {
        feedItem.content = [itemDic valueForKey:@"encoded:content"];
    }
    if (!feedItem.content) {
        feedItem.content = feedItem.summary;
    }
    if ([itemDic valueForKeyPath:@"enclosure._url"]) {
        NSString *type = [itemDic valueForKeyPath:@"enclosure._type"];
        if ([type ro_isEqualToStringCI:@"image/jpeg"] || [type ro_isEqualToStringCI:@"image/jpg"] || [type ro_isEqualToStringCI:@"image/png"]) {
            feedItem.mediaContent = [itemDic valueForKeyPath:@"enclosure._url"];
        }
    }
    if (!feedItem.mediaContent) {
        id mediaContent = [itemDic valueForKeyPath:@"media:content"];
        if (mediaContent) {
            if ([mediaContent isKindOfClass:[NSDictionary class]]) {
                if ([[mediaContent valueForKeyPath:@"_medium"] ro_isEqualToStringCI:@"image"]) {
                    feedItem.mediaContent = [mediaContent valueForKeyPath:@"_url"];
                } else if ([[mediaContent objectForKey:@"_type"] ro_isEqualToStringCI:@"image/jpeg"] || [[mediaContent objectForKey:@"_type"] ro_isEqualToStringCI:@"image/jpg"] || [[mediaContent objectForKey:@"_type"] ro_isEqualToStringCI:@"image/png"]) {
                    feedItem.mediaContent = [mediaContent valueForKeyPath:@"_url"];
                }
            } else if ([mediaContent isKindOfClass:[NSArray class]]) {
                for (NSDictionary *mediaDic in mediaContent) {
                    if ([[mediaDic valueForKeyPath:@"_medium"] ro_isEqualToStringCI:@"image"]) {
                        feedItem.mediaContent = [mediaDic valueForKeyPath:@"_url"];
                        break;
                    } else if ([[mediaContent objectForKey:@"_type"] ro_isEqualToStringCI:@"image/jpeg"] || [[mediaContent objectForKey:@"_type"] ro_isEqualToStringCI:@"image/jpg"] || [[mediaContent objectForKey:@"_type"] ro_isEqualToStringCI:@"image/png"]) {
                        feedItem.mediaContent = [mediaContent valueForKeyPath:@"_url"];
                        break;
                    }
                }
            }
        }
    }
    if (!feedItem.mediaThumbnail) {
        feedItem.mediaThumbnail = [itemDic valueForKeyPath:@"image.url"];
    }
    if (!feedItem.mediaThumbnail && feedItem.mediaContent) {
        feedItem.mediaThumbnail = feedItem.mediaContent;
    }
    if (!feedItem.mediaThumbnail && feedItem.content) {
        feedItem.mediaThumbnail = [feedItem.content ro_firstImgUrl];
    }
    feedItem.comments = [itemDic valueForKey:@"comments"];
    feedItem.pubDate = ([itemDic valueForKey:@"pubDate"] ? [NSDate dateWithValue:[itemDic valueForKey:@"pubDate"]] : nil);
    feedItem.title = [itemDic valueForKey:@"title"];
    if (!feedItem.title) {
        feedItem.title = [itemDic valueForKeyPath:@"media:title"];
    }
    return feedItem;
}

- (ROFeedItem *)rdfItemAtDictionary:(NSDictionary *)itemDic
{
    ROFeedItem *feedItem = [[ROFeedItem alloc] init];
    feedItem.link = [itemDic valueForKey:@"link"];
    feedItem.author = [ROFeedItemAuthor new];
    feedItem.author.name = [itemDic valueForKey:@"creator"];
    if (feedItem.author.name == nil) {
        feedItem.author.name = [itemDic valueForKey:@"dc:creator"];
    }
    id guid = [itemDic objectForKey:@"guid"];
    if ([guid isKindOfClass:[NSString class]]) {
        feedItem.guid = guid;
    } else if ([guid isKindOfClass:[NSDictionary class]]) {
        feedItem.guid = [guid valueForKey:XMLDictionaryTextKey];
    }
    if (!feedItem.guid) {
        feedItem.guid = [itemDic valueForKeyPath:@"dc:identifier"];
    }
    feedItem.mediaThumbnail = [itemDic valueForKeyPath:@"media:thumbnail._url"];
    feedItem.categories = [self categoriesAtDictionary:itemDic];
    feedItem.summary = [itemDic valueForKey:@"description"];
    if (!feedItem.summary) {
        feedItem.summary = [itemDic valueForKey:@"dc:description"];
    }
    feedItem.content = [itemDic valueForKey:@"content"];
    if (feedItem.content == nil) {
        feedItem.content = [itemDic valueForKey:@"encoded:content"];
    }
    if (!feedItem.mediaThumbnail && feedItem.content) {
        feedItem.mediaThumbnail = [feedItem.content ro_firstImgUrl];
    }
    feedItem.comments = [itemDic valueForKey:@"comments"];
    feedItem.pubDate = ([itemDic valueForKey:@"pubDate"] ? [NSDate dateWithValue:[itemDic valueForKey:@"pubDate"]] : nil);
    if (!feedItem.pubDate) {
        feedItem.pubDate = ([itemDic valueForKey:@"dc:date"] ? [NSDate dateWithValue:[itemDic valueForKey:@"dc:date"]] : nil);
    }
    feedItem.title = [itemDic valueForKey:@"title"];
    return feedItem;
}

- (NSMutableArray *)categoriesAtDictionary:(NSDictionary *)itemDic
{
    NSMutableArray *categories = nil;
    id obj = [itemDic objectForKey:@"category"];
    if (obj == nil) {
        obj = [itemDic objectForKey:@"rx:Category"];
    }
    if (obj) {
        categories = [[NSMutableArray alloc] init];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *cat = [obj valueForKey:XMLDictionaryTextKey];
            if (cat != nil) {
                [categories addObject:cat];
            }
        } else if ([obj isKindOfClass:[NSArray class]]) {
            for (id catObj in obj) {
                if ([catObj isKindOfClass:[NSString class]]) {
                    [categories addObject:catObj];
                } else if ([catObj isKindOfClass:[NSDictionary class]]) {
                    NSString *cat = [catObj valueForKey:XMLDictionaryTextKey];
                    if (cat != nil) {
                        [categories addObject:cat];
                    }
                }
            }
        } else if ([obj isKindOfClass:[NSString class]]) {
            [categories addObject:obj];
        }
    }
    return categories;
}

@end
