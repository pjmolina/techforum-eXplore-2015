//
//  ROLoginService.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L.
//
//

#import "ROBasicAuthLoginService.h"
#import "AFNetworking.h"
#import "ROLoginResponse.h"

@interface ROBasicAuthLoginService ()
@property (nonatomic, assign) NSURL *_baseUrl;
@end

@implementation ROBasicAuthLoginService

+ (instancetype)sharedInstance:(NSURL *)baseUrl
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] initWithBaseUrl:baseUrl];
    });
    return _sharedInstance;
}

-(instancetype)initWithBaseUrl:(NSURL *)baseUrl
{
    self._baseUrl = baseUrl;
    return self;
}

- (void) loginUser:(NSString *)user withPassword:(NSString *)password withAppId:(NSString *)appId
        success:(ROLoginServiceSuccessBlock)success
        failure:(ROLoginServiceFailureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager manager]
                                              initWithBaseURL:self._baseUrl];
#ifdef DEBUG
    manager.securityPolicy.allowInvalidCertificates = YES;
#endif
    
    // set http basic auth
    [manager.requestSerializer clearAuthorizationHeader];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:user password:password];
    [manager.requestSerializer setTimeoutInterval:30];
    
    NSString *path = [NSString stringWithFormat:@"login/%@", appId];
    
    [manager POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if (success) {
                NSDictionary *responseDict = (NSDictionary *) responseObject;
                ROLoginResponse *response = [[ROLoginResponse alloc] initWithDictionary:responseDict];
                success(response);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#ifdef DEBUG
        if (error && error.userInfo) {
            NSLog(@"Error in:%s\n%@", __PRETTY_FUNCTION__,  [error.userInfo valueForKey:@"NSLocalizedDescription"]);
        }
#endif
        if (failure) {
            failure(error, operation.response);
        }
    }];
}

@end
