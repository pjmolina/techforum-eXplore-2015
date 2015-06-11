//
//  ROError.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 23/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ROError : NSObject

@property (nonatomic, strong) NSString *fn;

@property (nonatomic, strong) NSOperation *operation;

@property (nonatomic, strong) NSError *error;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *message;

- (instancetype)initWithFn:(const char *)fn error:(NSError *)error operation:(NSOperation *)operation;

- (instancetype)initWithFn:(const char *)fn error:(NSError *)error;

+ (instancetype)errorWithFn:(const char *)fn error:(NSError *)error operation:(NSOperation *)operation;

+ (instancetype)errorWithFn:(const char *)fn error:(NSError *)error;

- (void)log;

- (NSString *)stringValue;

- (void)show;

@end