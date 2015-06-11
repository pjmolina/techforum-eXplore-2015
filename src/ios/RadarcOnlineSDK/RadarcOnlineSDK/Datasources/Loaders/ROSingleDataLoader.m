//
//  ROSingleDataLoader.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 27/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROSingleDataLoader.h"

@implementation ROSingleDataLoader

- (void)refreshDataSuccessBlock:(RODataSuccessBlock)successBlock failureBlock:(RODataFailureBlock)failureBlock
{
    [super refreshDataSuccessBlock:^(NSArray *items) {
        
        if (successBlock) {
            NSObject *dataItem = nil;
            if (items && [items count] != 0) {
                dataItem = items[0];
            }
            successBlock(dataItem);
        }
        
    } failureBlock:failureBlock];
}

- (void)loadDataSuccessBlock:(RODataSuccessBlock)successBlock failureBlock:(RODataFailureBlock)failureBlock
{
    [self refreshDataSuccessBlock:successBlock failureBlock:failureBlock];
}

@end
