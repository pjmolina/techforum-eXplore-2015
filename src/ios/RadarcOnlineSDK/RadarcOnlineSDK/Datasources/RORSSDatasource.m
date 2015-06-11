//
//  RORSSDatasource.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/2/14.
//

#import "RORSSDatasource.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "ROFeedParser.h"
#import "ROFeed.h"

@implementation RORSSDatasource

- (id)initWithUrlString:(NSString *)urlString
{
    self = [super init];
    if (self) {
        _urlString = urlString;
    }
    return self;
}

- (NSURLRequest *)prepareRequest
{
    return [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_urlString]];
}

- (BOOL)hasPullToRefresh
{
    return YES;
}

- (void)loadOnSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock
{
    NSURLRequest *request = [self prepareRequest];
    if (request) {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        operation.responseSerializer = [[AFXMLParserResponseSerializer alloc] init];
        operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/xml", @"text/xml",@"application/rss+xml", @"application/atom+xml", nil];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSXMLParser *parser = (NSXMLParser *)responseObject;
            ROFeedParser *feedParser = [[ROFeedParser alloc] init];
            [feedParser parseAtParser:parser onSuccessBlock:^(ROFeed *feed) {
                
                if (successBlock) {
                    successBlock(feed.feedItems);
                }
                
            } onFailureBlock:^(NSError *error) {
            
                if (failureBlock) {
                    failureBlock(error, nil);
                }
                
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            if (failureBlock) {
                failureBlock(error, operation.response);
            }
            
        }];
        [operation start];
    }
}

- (void)loadWithOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock
{
    [self loadOnSuccess:successBlock onFailure:failureBlock];
}

@end
