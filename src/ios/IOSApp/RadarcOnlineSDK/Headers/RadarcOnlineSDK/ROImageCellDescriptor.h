//
//  ROImageCellDescriptor.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 24/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROCellDescriptor.h"
#import "ROAction.h"

@interface ROImageCellDescriptor : NSObject <ROCellDescriptor>

@property (nonatomic, strong) NSString *imageString;

@property (nonatomic, strong) NSObject<ROAction> *action;

- (instancetype)initWithImageString:(NSString *)imageString action:(NSObject<ROAction> *)action;

+ (instancetype)imageString:(NSString *)imageString action:(NSObject<ROAction> *)action;

- (void)configureCell:(UITableViewCell *)cell;

@end
