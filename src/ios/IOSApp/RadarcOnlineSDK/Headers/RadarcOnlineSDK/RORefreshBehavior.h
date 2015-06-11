//
//  RORefreshBehavior.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 30/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROBehavior.h"
#import "ROTableViewController.h"

@interface RORefreshBehavior : NSObject <ROBehavior>

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) ROViewController<RODataDelegate> *viewController;

- (instancetype)initWithViewController:(ROViewController<RODataDelegate> *)viewController;

+ (instancetype)behaviorViewController:(ROViewController<RODataDelegate> *)viewController;

@end
