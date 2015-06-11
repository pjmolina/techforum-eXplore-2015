//
//  ROFlickrDatasource.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/7/14.
//

#import "ROFlickrDatasource.h"

static NSString *const kFlickrUser  = @"https://api.flickr.com/services/feeds/photos_public.gne?format=rss2&id=%@";
static NSString *const kFlickrTag   = @"https://api.flickr.com/services/feeds/photos_public.gne?format=rss2&tags=%@";
static NSString *const kFlickrGroup = @"https://api.flickr.com/services/feeds/groups_pool.gne?format=rss2&id=%@";

@implementation ROFlickrDatasource

- (id)initWithSearchString:(NSString *)searchString atSearchType:(ROFlickrSearchType)searchType
{
    self = [super init];
    if (self) {
        _searchString = searchString;
        _searchType = searchType;
    }
    return self;
}

- (NSURLRequest *)prepareRequest {
    NSURLRequest *request = nil;
    NSString *urlString = nil;
    if (_searchString) {
        switch (_searchType) {
            case ROFlickrSearchTypeSearch:
                urlString = [NSString stringWithFormat:kFlickrGroup,_searchString];
                break;
            case ROFlickrSearchTypeTag:
                urlString = [NSString stringWithFormat:kFlickrTag,_searchString];
                break;
            case ROFlickrSearchTypeUser:
                urlString = [NSString stringWithFormat:kFlickrUser,_searchString];
                break;
            default:
                break;
        }
    }
    if (urlString) {
        request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    }
    return request;
}

- (BOOL)hasPullToRefresh
{
    return YES;
}

@end