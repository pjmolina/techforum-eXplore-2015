//
//  ROAppNowDatasource.m
//  RadarcOnlineSDK
//
//  Created by Víctor Jordán Rosado on 26/5/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROAppNowDatasource.h"
#import "ROOptionsFilter.h"
#import "RORestClient.h"
#import "ROError.h"
#import "ROFilter.h"

@implementation ROAppNowDatasource

static NSInteger const kAppNowDataRequestTimeout    = 30;
static NSString *const kAppNowConditionsParam       = @"conditions";
static NSString *const kAppNowSortParam             = @"sort";
static NSString *const kAppNowSkipParam             = @"skip";
static NSString *const kAppNowLimitParam            = @"limit";
static NSString *const kAppNowDistinctParam         = @"distinct";
static NSInteger const kAppNowDataPageSize          = 20;

static NSString *const kAppNowApiKey                = @"apikey";

- (instancetype)initWithUrlString:(NSString *)urlString apiKey:(NSString *)apiKey datasourceId:(NSString *)datasourceId objectsClass:(__unsafe_unretained Class)objectsClass
{
    self = [super init];
    if (self) {
        _apiKey = apiKey;
        _urlString = urlString;
        _dsId = datasourceId;
        _objectsClass = objectsClass;
    }
    return self;
}

+ (instancetype)datasourceWithUrlString:(NSString *)urlString apiKey:(NSString *)apiKey datasourceId:(NSString *)datasourceId objectsClass:(__unsafe_unretained Class)objectsClass
{
    return [[self alloc] initWithUrlString:urlString
                                    apiKey:apiKey
                              datasourceId:datasourceId
                              objectsClass:objectsClass];
}

- (instancetype)initWithUrlString:(NSString *)urlString
                           userId:(NSString *)userId
                         password:(NSString *)password
                     datasourceId:(NSString *)datasourceId
                     objectsClass:(__unsafe_unretained Class)objectsClass
{
    self = [super init];
    if (self) {
        _userId = userId;
        _password = password;
        _urlString = urlString;
        _dsId = datasourceId;
        _objectsClass = objectsClass;
    }
    return self;
}

+ (instancetype)datasourceWithUrlString:(NSString *)urlString userId:(NSString *)userId password:(NSString *)passwd datasourceId:(NSString *)datasourceId objectsClass:(__unsafe_unretained Class)objectsClass
{
    return [[self alloc] initWithUrlString:urlString
                                    userId:userId
                                  password:passwd
                              datasourceId:datasourceId
                              objectsClass:objectsClass];
}

- (RORestClient *)restClient
{
    if (!_restClient) {
        _restClient = [[RORestClient alloc] initWithBaseUrlString:self.urlString timeout:kAppNowDataRequestTimeout];
        NSMutableDictionary *headers = [NSMutableDictionary new];
        [headers setObject:self.apiKey forKey:kAppNowApiKey];
        _restClient.headerFields = headers;
    }
    return _restClient;
}

- (void)loadOnSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock{
    [self loadWithOptionsFilter:nil onSuccess:successBlock onFailure:failureBlock];
}

- (void)loadWithOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock{
    
    NSMutableDictionary *requestParams = [self getRequestParams:optionsFilter];
    
    [self.restClient get:self.dsId params:requestParams responseClass:self.objectsClass successBlock:^(id response) {
        
        if (successBlock) {
            if ([response isKindOfClass:[NSArray class]]) {
                successBlock (response);
            } else {
                successBlock([NSArray new]);
            }
        }
        
    } failureBlock:^(ROError *error) {
        
        if (failureBlock) {
            failureBlock(error.error, nil);
        }
        
    }];
}

- (void)getDistinctValues:(NSString *)columnName onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock{
    ROOptionsFilter *options = [ROOptionsFilter new];
    [options.extra setObject:columnName forKey:kAppNowDistinctParam];
    [self loadWithOptionsFilter:options onSuccess:successBlock onFailure:failureBlock];
}

#pragma mark - ROPagination

- (NSInteger)pageSize
{
    return kAppNowDataPageSize;
}

- (void)loadPageNum:(NSInteger)pageNum onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock{
    [self loadPageNum:pageNum withOptionsFilter:nil onSuccess:successBlock onFailure:failureBlock];
}

- (void)loadPageNum:(NSInteger)pageNum withOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock{
    if (!optionsFilter) {
        optionsFilter = [ROOptionsFilter new];
    }
    NSInteger size = optionsFilter.pageSize ? [optionsFilter.pageSize integerValue] : [self pageSize];
    NSInteger skip = pageNum * size;
    [optionsFilter.extra setObject:[@(skip) stringValue] forKey:kAppNowSkipParam];
    [optionsFilter.extra setObject:[@(size) stringValue] forKey:kAppNowLimitParam];
    [self loadWithOptionsFilter:optionsFilter onSuccess:successBlock onFailure:failureBlock];
}

#pragma mark private methods

- (NSMutableDictionary *) getRequestParams:(ROOptionsFilter *)optionsFilter{
    NSMutableDictionary *requestParams = [NSMutableDictionary dictionaryWithDictionary:optionsFilter.extra];
    
    // CONDITIONS
    NSMutableArray *exps = [NSMutableArray new];
    NSArray *searchableFields;
    
    // searchField is proritized
    if(self.searchField) {
        searchableFields = [NSArray arrayWithObject:self.searchField];
    } else {
        if(self.delegate) {
            searchableFields = [self.delegate searchableFields];
        } else {
            searchableFields = [NSArray new];
        }
    }
    
    // Search text. This should be a $text index in appnow's mongodb
    if(searchableFields && searchableFields.count > 0 && optionsFilter.searchText) {
        NSMutableArray* searches = [NSMutableArray new];
        for(int i = 0; i < searchableFields.count; i++) {
            [searches addObject:[NSString stringWithFormat:@"{\"%@\":{\"$regex\":\"%@\",\"$options\":\"i\"}}",
                                 searchableFields[i],
                                 optionsFilter.searchText
                                 ]];
        }
        [exps addObject:[NSString stringWithFormat:@"\"$or\":[%@]",
                         [searches componentsJoinedByString:@","]]];
    }
    
    for(NSObject<ROFilter> *filter in optionsFilter.filters) {
        NSString *qs = [filter getQueryString];
        if(qs){
            [exps addObject:qs];
        }
    }
    
    if(exps.count > 0){
        [requestParams setObject:[NSString stringWithFormat:@"{%@}",
                                  [exps componentsJoinedByString:@","]]
                          forKey:kAppNowConditionsParam];
    }
    
    // SORT
    if (optionsFilter.sortColumn) {
        NSString *sortParam;
        if(!optionsFilter.sortAscending){
            sortParam = [NSString stringWithFormat:@"-%@", optionsFilter.sortColumn];
        }
        else{
            sortParam = optionsFilter.sortColumn;
        }
        [requestParams setObject:sortParam forKey:kAppNowSortParam];
    }
    
    return requestParams;
}

@end
