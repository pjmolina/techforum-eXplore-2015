//
//  RODatasource.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/28/14.
//

#import <Foundation/Foundation.h>

@class ROOptionsFilter;

typedef void (^RODatasourceSuccessBlock)(NSArray *objects);
typedef void (^RODatasourceErrorBlock)(NSError *error, NSHTTPURLResponse *response);

@protocol RODatasource <NSObject>

- (void)loadOnSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock;

- (void)loadWithOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock;

- (void)getDistinctValues:(NSString *)columnName onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock;

@optional

- (BOOL)hasPullToRefresh;

@end