//
//  ROBingDatasource.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/6/14.
//

#import "ROBingDatasource.h"

static NSString *const kBingSearch = @"https://www.bing.com/search?format=rss&q=%@&first=%li";

static NSInteger const kBingPageInit = 1; // bing feeds use a 1-based index
static NSInteger const kBingPageSize = 10;

@interface ROBingDatasource ()

@property (nonatomic, assign) NSInteger pageStart;

@end

@implementation ROBingDatasource

- (id)initWithSearchString:(NSString *)searchString
{
    self = [super init];
    if (self) {
        _searchString = searchString;
    }
    return self;
}

- (NSURLRequest *)prepareRequest {
    return [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:kBingSearch,_searchString, (long)self.pageStart]]];
}

- (BOOL)hasPullToRefresh
{
    return YES;
}

#pragma mark - ROPagination

- (NSInteger)pageSize
{
    return kBingPageSize;
}

- (void)loadPageNum:(NSInteger)pageNum onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock
{
    _pageStart = pageNum * [self pageSize] + kBingPageInit;
    [self loadOnSuccess:successBlock onFailure:failureBlock];
}

- (void)loadPageNum:(NSInteger)pageNum withOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock
{
    [self loadPageNum:pageNum onSuccess:successBlock onFailure:failureBlock];
}

@end
