//
//  UIColor+RO.m
//  RadarcOnlineSDK
//
//  Created by Víctor Jordán Rosado on 26/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "UIColor+RO.h"
#import "Colours.h"

@implementation UIColor (RO)

- (BOOL)ro_lightStyle
{
    BOOL light = YES;
    UIColor *color = [self blackOrWhiteContrastingColor];
    CGFloat distance = [color distanceFromColor:[UIColor blackColor]];
    if (!isnan(distance)) {
        if (distance != 0.0f) {
            light = NO;
        }
    }
    return light;
}

@end
