//
//  ROListDataLoader.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 27/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RODataLoader.h"
#import "RODatasource.h"

@interface ROListDataLoader : NSObject<RODataLoader>

- (instancetype)initWithDatasource:(NSObject<RODatasource> *)datasource optionsFilter:(ROOptionsFilter *)optionsFilter;

/**
 Datasource
 */
@property (nonatomic, strong) NSObject<RODatasource> *datasource;

/**
 *  Datasource options filter
 */
@property (nonatomic, strong) ROOptionsFilter *optionsFilter;

@end
