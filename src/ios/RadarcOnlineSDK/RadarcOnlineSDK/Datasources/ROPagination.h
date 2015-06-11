//
//  ROPagination.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/30/14.
//

#import <Foundation/Foundation.h>

@class ROOptionsFilter;

@protocol ROPagination <NSObject>

- (NSInteger)pageSize;

- (void)loadPageNum:(NSInteger)pageNum onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock;

- (void)loadPageNum:(NSInteger)pageNum withOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock;

@end
