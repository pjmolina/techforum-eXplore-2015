//
//  ROAppNowDatasource.h
//  RadarcOnlineSDK
//
//  Created by Víctor Jordán Rosado on 26/5/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RODatasource.h"
#import "ROPagination.h"

@class RORestClient;

@protocol ROAppNowDelegate <NSObject>

- (NSArray *)searchableFields;

@end

@interface ROAppNowDatasource : NSObject <RODatasource, ROPagination>

@property (nonatomic, strong) RORestClient *restClient;

@property (nonatomic, assign) Class objectsClass;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *dsId;
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSObject<ROAppNowDelegate> *delegate;
@property (nonatomic, strong) NSString *searchField;

- (instancetype)initWithUrlString:(NSString *)urlString
                           apiKey:(NSString *)apiKey
                     datasourceId:(NSString *)datasourceId
                     objectsClass:(__unsafe_unretained Class)objectsClass;

+ (instancetype)datasourceWithUrlString:(NSString *)urlString
                                 apiKey:(NSString *)apiKey
                           datasourceId:(NSString *)datasourceId
                           objectsClass:(__unsafe_unretained Class)objectsClass;

- (instancetype)initWithUrlString:(NSString *)urlString
                           userId:(NSString *)userId
                         password:(NSString *)password
                     datasourceId:(NSString *)datasourceId
                     objectsClass:(__unsafe_unretained Class)objectsClass;

+ (instancetype)datasourceWithUrlString:(NSString *)urlString
                                 userId:(NSString *)userId
                               password:(NSString *)password
                           datasourceId:(NSString *)datasourceId
                           objectsClass:(__unsafe_unretained Class)objectsClass;

@end
