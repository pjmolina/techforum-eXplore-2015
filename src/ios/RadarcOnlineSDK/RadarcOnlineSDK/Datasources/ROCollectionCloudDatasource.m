//
//  ROCollectionCloudDatasource.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/30/14.
//

#import "ROCollectionCloudDatasource.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "NSUserDefaults+AESEncryptor.h"
#import <DCKeyValueObjectMapping/DCKeyValueObjectMapping.h>
#import <DCKeyValueObjectMapping/DCParserConfiguration.h>
#import "ROOptionsFilter.h"
#import "ROFilter.h"
#import "ROModel.h"

static NSInteger const kCloudDataPageSize               = 20;
static NSString *const kCloudDataRequestParamPageStart  = @"offset";
static NSString *const kCloudDataRequestParamPageSize   = @"blockSize";
static NSString *const kCloudDataParamSortField         = @"sortingColumn";
static NSString *const kCloudDataParamSortType          = @"sortAscending";
static NSString *const kCloudDataParamSearchText        = @"searchText";
static NSString *const kCloudDataParamCondition         = @"condition";

static NSInteger const kCloudDataRequestTimeout         = 30;

@interface ROCollectionCloudDatasource ()

- (id)objectWithDictionary:(NSDictionary *)dic;

@end

@implementation ROCollectionCloudDatasource

- (id)initWithUrlString:(NSString *)urlString
              withAppId:(NSString *)appId
             withApiKey:(NSString *)apiKey
         atDatasourceId:(NSString *)datasourceId
         atObjectsClass:(Class)objectsClass;
{
    self = [super init];
    if (self) {
        _appId = appId;
        _apiKey = apiKey;
        _urlString = urlString;
        _dsId = datasourceId;
        _objectsClass = objectsClass;
    }
    return self;
}

- (BOOL)hasPullToRefresh
{
    return YES;
}

- (void)loadOnSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock
{
    [self loadWithOptionsFilter:nil onSuccess:successBlock onFailure:failureBlock];
}

- (void)loadWithOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock
{
    // create the manager with base url (ie http://baseurl/api/app/data/)
    AFHTTPRequestOperationManager *manager = [self getManager];
    
    NSMutableDictionary *requestParams = [NSMutableDictionary dictionaryWithDictionary:optionsFilter.extra];
    if (optionsFilter.searchText) {
        [requestParams setObject:optionsFilter.searchText forKey:kCloudDataParamSearchText];
    }
    if (optionsFilter.sortColumn) {
        [requestParams setObject:optionsFilter.sortColumn forKey:kCloudDataParamSortField];
        NSString *sortType = optionsFilter.sortAscending ? @"true" : @"false";
        [requestParams setObject:sortType forKey:kCloudDataParamSortType];
    }
    
    // filters
    if(optionsFilter.filters && [optionsFilter.filters count] != 0){
        NSString *filterQuery = [self getFilterQuery:optionsFilter.filters];
        if(filterQuery){
            [requestParams setObject:filterQuery forKey:kCloudDataParamCondition];
        }
    }
    
    [manager GET:_dsId parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *objects = (NSArray *)responseObject;
            NSMutableArray *objectsTmp = [[NSMutableArray alloc] initWithCapacity:objects.count];
            for (NSInteger i=0; i!= [objects count]; i++) {
                if ([[objects objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *objDic = (NSDictionary *)[objects objectAtIndex:i];
                    [objectsTmp addObject:[self objectWithDictionary:objDic]];
                }
            }
            successBlock([objectsTmp copy]);
        } else {
            successBlock([NSArray new]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(error, operation.response);
        }
        
    }];
}

- (AFHTTPRequestOperationManager *)getManager{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:_urlString]];
#ifdef DEBUG
    manager.securityPolicy.allowInvalidCertificates = YES;
#endif
    // setup http basic auth
    if(_apiKey){
        [manager.requestSerializer clearAuthorizationHeader];
        [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:_appId password:_apiKey];
        [manager.requestSerializer setTimeoutInterval:kCloudDataRequestTimeout];
        NSString *token = [[NSUserDefaults standardUserDefaults] decryptedValueForKey:@"UserToken"];
        if (token) {
            [manager.requestSerializer setValue:token forHTTPHeaderField:@"UserToken"];
        }
    }
    
    return manager;
}

- (NSString *)getFilterQuery:(NSMutableArray *) filters{
    if(!filters || filters.count == 0)
        return nil;
    
    NSMutableArray *conditions = [NSMutableArray new];
    for(NSObject<ROFilter> *filter in filters){
        NSString *qs = [filter getQueryString];
        if(qs){
            [conditions addObject:[NSString stringWithFormat:@"{%@}", qs]];
        }
    }
    
    if(conditions.count > 0){
        return [NSString stringWithFormat:@"[%@]", [conditions componentsJoinedByString:@","]];
    }
    else{
        return nil;
    }
}

- (void) getDistinctValues:(NSString *)columnName onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock{
    AFHTTPRequestOperationManager *manager = [self getManager];
    
    NSString *path = [NSString stringWithFormat:@"%@/distinct/%@", _dsId, columnName];
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *objects = (NSArray *)responseObject;
            successBlock([objects copy]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(error, operation.response);
        }
    }];
}

- (id)objectWithDictionary:(NSDictionary *)dic
{
    NSObject<ROModelDelegate> *obj = nil;
    
    if (self.objectsClass) {
        
        id object = [[self.objectsClass alloc] init];
        
        if ([object conformsToProtocol:@protocol(ROModelDelegate)]) {
            
            obj = object;
            [obj updateWithDictionary:dic];
        
        } else {
            
            DCParserConfiguration *config = [DCParserConfiguration configuration];
            config.datePattern = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
            DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:self.objectsClass andConfiguration:config];
            obj = [parser parseDictionary:dic];
        }
        
    }
    
    return obj;
}

#pragma mark - ROPagination

- (NSInteger)pageSize
{
    return kCloudDataPageSize;
}

- (void)loadPageNum:(NSInteger)pageNum onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock
{
    [self loadPageNum:pageNum withOptionsFilter:nil onSuccess:successBlock onFailure:failureBlock];
}

- (void)loadPageNum:(NSInteger)pageNum withOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock
{
    if (!optionsFilter) {
        optionsFilter = [ROOptionsFilter new];
    }
    NSInteger size = optionsFilter.pageSize ? [optionsFilter.pageSize integerValue] : [self pageSize];
    [optionsFilter.extra setObject:[@(pageNum) stringValue] forKey:kCloudDataRequestParamPageStart];
    [optionsFilter.extra setObject:[@(size) stringValue] forKey:kCloudDataRequestParamPageSize];
    [self loadWithOptionsFilter:optionsFilter onSuccess:successBlock onFailure:failureBlock];
}

@end
