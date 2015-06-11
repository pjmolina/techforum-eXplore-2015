//
//  ROLabelCellDescriptor.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 24/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROCellDescriptor.h"

@class ROTextStyle;

@interface ROHeaderCellDescriptor : NSObject <ROCellDescriptor>

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) ROTextStyle *textStyle;

- (instancetype)initWithText:(NSString *)text;

+ (instancetype)text:(NSString *)text;

- (instancetype)initWithText:(NSString *)text textStyle:(ROTextStyle *)textStyle;

+ (instancetype)text:(NSString *)text textStyle:(ROTextStyle *)textStyle;

- (void)configureCell:(UITableViewCell *)cell;

@end
