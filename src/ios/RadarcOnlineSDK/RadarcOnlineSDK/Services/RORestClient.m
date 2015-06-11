//
//  BRestClient.m
//  B.eat
//
//  Created by Víctor Jordán Rosado on 7/4/15.
//  Copyright (c) 2015 Balanceat. All rights reserved.
//

#import "RORestClient.h"
#import "ROError.h"
#import "NSDictionary+RO.h"
#import "ROModel.h"
#import <AFNetworking/AFURLConnectionOperation.h>
#import <DCKeyValueObjectMapping/DCKeyValueObjectMapping.h>
#import <DCKeyValueObjectMapping/DCParserConfiguration.h>

@interface RORestClient ()

- (NSDictionary *)cleanParams:(NSDictionary *)params;

- (id)objectWithDictionary:(NSDictionary *)dic objectClass:(__unsafe_unretained Class)objectClass;

@end

@implementation RORestClient

- (instancetype)initWithBaseUrlString:(NSString *)baseUrlString timeout:(NSTimeInterval)timeout
{
    self = [super init];
    if (self) {
        _baseUrlString = baseUrlString;
        _timeout = timeout;
    }
    return self;
}

- (NSMutableDictionary *)headerFields
{
    if (!_headerFields) {
        _headerFields = [NSMutableDictionary new];
    }
    return _headerFields;
}

- (NSDictionary *)cleanParams:(NSDictionary *)params
{
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:params];
    for (NSString *key in params) {
        if ([params[key] isKindOfClass:[NSNull class]]) {
            [body removeObjectForKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:body];
}

#pragma mark - Request from manager

- (NSOperation *)operationService:(NSString *)service method:(NSString *)method params:(NSDictionary *)params bodyParams:(NSDictionary *)bodyParams responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    NSMutableURLRequest *request = [self request:method service:service params:params bodyParams:bodyParams failureBlock:failureBlock];
    
    if (request) {
        
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.responseSerializer = self.manager.responseSerializer;
        __weak typeof (self) weakSelf = self;
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [weakSelf processSuccess:operation
                      responseObject:responseObject
                       responseClass:responseClass
                        successBlock:successBlock];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [weakSelf processFailure:operation
                               error:error
                        failureBlock:failureBlock];
            
        }];
        return op;
        
    }
    return nil;
}

- (void)service:(NSString *)service method:(NSString *)method params:(NSDictionary *)params bodyParams:(NSDictionary *)bodyParams responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)[self operationService:service
                                                                                  method:method
                                                                                  params:params
                                                                              bodyParams:bodyParams
                                                                           responseClass:responseClass
                                                                            successBlock:successBlock
                                                                            failureBlock:failureBlock];
    [self.manager.operationQueue addOperation:operation];
}

#pragma mark - Manager

- (NSOperation *)get:(NSString *)service params:(NSDictionary *)params responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    __weak typeof(self) weakSelf = self;
    return [self.manager GET:service
                  parameters:[self cleanParams:params]
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         
                         [weakSelf processSuccess:operation
                                   responseObject:responseObject
                                    responseClass:responseClass
                                     successBlock:successBlock];
                         
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         
                         [weakSelf processFailure:operation
                                            error:error
                                     failureBlock:failureBlock];
                         
                     }];
}

- (NSOperation *)post:(NSString *)service params:(NSDictionary *)params responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    __weak typeof(self) weakSelf = self;
    return [self.manager POST:service
                   parameters:[self cleanParams:params]
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          [weakSelf processSuccess:operation
                                    responseObject:responseObject
                                     responseClass:responseClass
                                      successBlock:successBlock];
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          [weakSelf processFailure:operation
                                             error:error
                                      failureBlock:failureBlock];
                          
                      }];
}

- (NSOperation *)put:(NSString *)service params:(NSDictionary *)params responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    __weak typeof(self) weakSelf = self;
    return [self.manager PUT:service
                  parameters:[self cleanParams:params]
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          [weakSelf processSuccess:operation
                                    responseObject:responseObject
                                     responseClass:responseClass
                                      successBlock:successBlock];
                          
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          [weakSelf processFailure:operation
                                             error:error
                                      failureBlock:failureBlock];
                          
                      }];
}

- (NSOperation *)delete:(NSString *)service params:(NSDictionary *)params responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    __weak typeof(self) weakSelf = self;
    return [self.manager DELETE:service
                     parameters:[self cleanParams:params]
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          [weakSelf processSuccess:operation
                                    responseObject:responseObject
                                     responseClass:responseClass
                                      successBlock:successBlock];
                          
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          [weakSelf processFailure:operation
                                             error:error
                                      failureBlock:failureBlock];
                          
                        }];
}

#pragma mark - Batch

- (void)batchOfRequestOperations:(NSArray *)operations progress:(ProgressBlock)progressBlock complete:(CompleteBlock)completeBlock waitUntilFinished:(BOOL)wait
{
    NSArray *operationsToProcess = [AFURLConnectionOperation batchOfRequestOperations:operations
                                                                        progressBlock:progressBlock
                                                                      completionBlock:^(NSArray *operationsCompleted) {
                                                                          
                                                                          if (completeBlock) {
                                                                              BOOL isSuccess = YES;
                                                                              for (AFHTTPRequestOperation *op in operationsCompleted) {
                                                                                  if (op.error) {
                                                                                      isSuccess = NO;
                                                                                  }
                                                                              }
                                                                              completeBlock(isSuccess);
                                                                          }
                                                                          
                                                                      }];
    [self.manager.operationQueue addOperations:operationsToProcess waitUntilFinished:wait];
}

#pragma mark - Upload

- (void)post:(NSString *)service params:(NSDictionary *)params data:(NSData *)data name:(NSString *)name mimeType:(NSString *)mimeType responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    __weak typeof (self) weakSelf = self;
    [self.manager POST:service parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:data
                                    name:name
                                fileName:name
                                mimeType:mimeType];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [weakSelf processSuccess:operation
                  responseObject:responseObject
                   responseClass:responseClass
                    successBlock:successBlock];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [weakSelf processFailure:operation
                           error:error
                    failureBlock:failureBlock];
        
        
    }];
}

#pragma mark - Helpers

- (NSMutableURLRequest *)request:(NSString *)method service:(NSString *)service params:(NSDictionary *)params bodyParams:(NSDictionary *)bodyParams failureBlock:(FailureBlock)failureBlock
{
    NSString *urlString = [[self.manager.baseURL absoluteString] stringByAppendingString:service];
    NSError *error = nil;
    
    /*
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                            timeoutInterval:self.timeout];
    
    [request setHTTPMethod:method];
    
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    */

    NSMutableURLRequest *request = [self.manager.requestSerializer requestWithMethod:method
                                                                           URLString:urlString
                                                                          parameters:params
                                                                               error:&error];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
     
    if ([self.headerFields count] != 0) {
        for (NSString* key in self.headerFields) {
            NSString *value = [self.headerFields ro_stringForKey:key];
            if (value) {
                [request setValue:value forHTTPHeaderField:key];
            }
        }
    }
    
    if (error) {
        
        [self processFailure:nil error:error failureBlock:failureBlock];
        return nil;
        
    } else if (bodyParams) {
        
        NSError *jsonError = nil;
        NSData *JSONData = [NSJSONSerialization dataWithJSONObject:[self cleanParams:bodyParams]
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&jsonError];
        if (jsonError) {
            
            [self processFailure:nil error:jsonError failureBlock:failureBlock];
            return nil;
            
        } else {
            
            NSString *contentJSONString = [[NSString alloc] initWithData:JSONData
                                                                encoding:NSUTF8StringEncoding];
            // Generate an NSData from your NSString (see below for link to more info)
            NSData *postBody = [contentJSONString dataUsingEncoding:NSUTF8StringEncoding];
            
            // Add Content-Length header if your server needs it
            unsigned long long postLength = postBody.length;
            NSString *contentLength = [NSString stringWithFormat:@"%llu", postLength];
            [request setValue:contentLength forHTTPHeaderField:@"Content-Length"];
            
            // This should all look familiar...
            [request setHTTPBody:postBody];
        }
        
    }
    return request;
}

- (void)processSuccess:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject responseClass:(__unsafe_unretained Class)responseClass successBlock:(SuccessBlock)successBlock
{
    if (successBlock) {
        if (responseClass) {
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSMutableArray *objects = [NSMutableArray new];
                for (id obj in responseObject) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        [objects addObject:[self objectWithDictionary:obj objectClass:responseClass]];
                    }
                }
                successBlock(objects);
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
               
                successBlock([self objectWithDictionary:responseObject objectClass:responseClass]);

            } else {
                successBlock(responseObject);
            }
        } else {
            successBlock(responseObject);
        }
    }
}

- (id)objectWithDictionary:(NSDictionary *)dic objectClass:(__unsafe_unretained Class)objectClass
{
    id object = [objectClass new];
    if ([object conformsToProtocol:@protocol(ROModelDelegate)]) {
    
        [object updateWithDictionary:dic];

    } else {
    
        DCParserConfiguration *config = [DCParserConfiguration configuration];
        config.datePattern = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:objectClass
                                                                 andConfiguration:config];
        object = [parser parseDictionary:dic];
        
    }
    return object;
}

- (void)processFailure:(AFHTTPRequestOperation *)operation error:(NSError *)error failureBlock:(FailureBlock)failureBlock
{
    ROError *roError = [ROError errorWithFn:__PRETTY_FUNCTION__
                                      error:error
                                  operation:operation];
#ifdef DEBUG
    [roError log];
#endif
    if (failureBlock) {
        failureBlock(roError);
    }
}

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:self.baseUrlString]];
#ifdef DEBUG
        _manager.securityPolicy.allowInvalidCertificates = YES;
#endif
        // setup http basic auth
        [_manager.requestSerializer clearAuthorizationHeader];
        [_manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [_manager.requestSerializer setTimeoutInterval:self.timeout];
        
        /*
        NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:_manager.responseSerializer.acceptableContentTypes];
        [contentTypes addObject:@"text/html"];
        _manager.responseSerializer.acceptableContentTypes = contentTypes;
         */
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    if (self.headerFields) {
        for (NSString* key in self.headerFields) {
            NSString *value = [self.headerFields ro_stringForKey:key];
            [_manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }
    return _manager;
}

@end
