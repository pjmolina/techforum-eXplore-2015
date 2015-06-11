//
//  ROShareBehavior.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 30/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROBehavior.h"

@interface ROShareBehavior : NSObject <ROBehavior>

@property (nonatomic, strong) UIViewController *viewController;

- (instancetype)initWithViewController:(UIViewController *)viewController;

+ (instancetype)behaviorViewController:(UIViewController *)viewController;

@end
