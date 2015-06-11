//
//  RODataLoader.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 27/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RODatasource.h"

@class ROError;
@class ROOptionsFilter;

typedef void (^RODataSuccessBlock)(id object);
typedef void (^RODataFailureBlock)(ROError *error);

@protocol RODataLoader <NSObject>

- (void)setDatasource:(NSObject<RODatasource> *)datasource;

- (void)setOptionsFilter:(ROOptionsFilter *)optionsFilter;

- (ROOptionsFilter *)optionsFilter;

/**
 *  Refresh data
 */
- (void)refreshDataSuccessBlock:(RODataSuccessBlock)successBlock failureBlock:(RODataFailureBlock)failureBlock;

/**
 *  Load data
 */
- (void)loadDataSuccessBlock:(RODataSuccessBlock)successBlock failureBlock:(RODataFailureBlock)failureBlock;

@end
