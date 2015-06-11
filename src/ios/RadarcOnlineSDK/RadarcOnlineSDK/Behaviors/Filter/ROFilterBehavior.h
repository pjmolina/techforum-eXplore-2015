//
//  ROFilterBehavior.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 29/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROBehavior.h"
#import "ROViewController.h"

@interface ROFilterBehavior : NSObject <ROBehavior>

/**
 Filter view controller class
 */
@property (nonatomic, strong) Class filterControllerClass;

@property (nonatomic, strong) ROViewController<RODataDelegate> *viewController;

- (instancetype)initWithViewController:(ROViewController<RODataDelegate> *)viewController filterControllerClass:(Class)filterControllerClass;

+ (instancetype)behaviorViewController:(ROViewController<RODataDelegate> *)viewController filterControllerClass:(Class)filterControllerClass;

@end
