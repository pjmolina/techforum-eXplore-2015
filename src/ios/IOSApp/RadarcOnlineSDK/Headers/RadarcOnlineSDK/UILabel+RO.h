//
//  UILabel+RO.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 15/5/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ROTextStyle;

@interface UILabel (RO)

- (void)ro_style:(ROTextStyle *)textStyle;

@end
