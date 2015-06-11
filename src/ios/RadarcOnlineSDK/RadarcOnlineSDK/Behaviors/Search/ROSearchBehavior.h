//
//  ROSearchBehavior.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 29/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROBehavior.h"
#import "ROViewController.h"

@interface ROSearchBehavior : NSObject <ROBehavior>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) ROViewController<RODataDelegate> *viewController;

- (instancetype)initWithViewController:(ROViewController<RODataDelegate> *)viewController;

+ (instancetype)behaviorViewController:(ROViewController<RODataDelegate> *)viewController;

@end
