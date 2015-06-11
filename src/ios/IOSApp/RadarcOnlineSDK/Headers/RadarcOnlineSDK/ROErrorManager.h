//
//  ROErrorManager.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 23/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ROError;

@interface ROErrorManager : NSObject

@property (nonatomic, strong) NSMutableArray *errors;

+ (instancetype)sharedInstance;

- (void)addError:(ROError *)error;

- (void)processError:(ROError *)error;

@end
