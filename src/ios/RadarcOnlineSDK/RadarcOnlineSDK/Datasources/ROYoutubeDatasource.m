//
//  ROYoutubeDatasource.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/6/14.
//

#import "ROYoutubeDatasource.h"

static NSString *const kYoutubeMostPopular  = @"https://gdata.youtube.com/feeds/api/standardfeeds/most_popular?";
static NSString *const kYoutubeCategory     = @"https://gdata.youtube.com/feeds/api/standardfeeds/most_popular_%@?v=2&";
static NSString *const kYoutubeUser         = @"https://gdata.youtube.com/feeds/api/users/%@/uploads?";
static NSString *const kYoutubeTag          = @"https://gdata.youtube.com/feeds/api/videos/-/%@?";
static NSString *const kYoutubeSearch       = @"https://gdata.youtube.com/feeds/api/videos?q=%@&";

static NSInteger const kYoutubePageInit = 1; // youtube feeds use a 1-based index
static NSInteger const kYoutubePageSize = 25;

@interface ROYoutubeDatasource ()

@property (nonatomic, assign) NSInteger pageStart;

@end

@implementation ROYoutubeDatasource

- (id)initWithSearchString:(NSString *)searchString atSearchType:(ROYoutubeSearchType)searchType
{
    self = [super init];
    if (self) {
        _searchString = searchString;
        _searchType = searchType;
    }
    return self;
}

- (NSURLRequest *)prepareRequest {
    NSString *urlString = kYoutubeMostPopular;
    if (_searchString) {
        switch (_searchType) {
            case ROYoutubeSearchTypeMostPopular:
                urlString = kYoutubeMostPopular;
                break;
            case ROYoutubeSearchTypeCategory:
                urlString = [NSString stringWithFormat:kYoutubeCategory,_searchString];
                break;
            case ROYoutubeSearchTypeSearch:
                urlString = [NSString stringWithFormat:kYoutubeSearch,_searchString];
                break;
            case ROYoutubeSearchTypeTag:
                urlString = [NSString stringWithFormat:kYoutubeTag,_searchString];
                break;
            case ROYoutubeSearchTypeUser:
                urlString = [NSString stringWithFormat:kYoutubeUser,_searchString];
                break;
            default:
                break;
        }
    }
    urlString = [NSString stringWithFormat:@"%@start-index=%li&max-results=%li", urlString, (long)self.pageStart, (long)[self pageSize]];
    return [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
}

- (BOOL)hasPullToRefresh
{
    return YES;
}

#pragma mark - ROPagination

- (NSInteger)pageSize
{
    return kYoutubePageSize;
}

- (void)loadPageNum:(NSInteger)pageNum onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock
{
    _pageStart = pageNum * [self pageSize] + kYoutubePageInit;
    [self loadOnSuccess:successBlock onFailure:failureBlock];
}

- (void)loadPageNum:(NSInteger)pageNum withOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock
{
    [self loadPageNum:pageNum onSuccess:successBlock onFailure:failureBlock];
}

@end
