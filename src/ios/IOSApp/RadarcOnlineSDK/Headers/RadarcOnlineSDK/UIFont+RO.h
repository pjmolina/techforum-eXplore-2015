//
//  UIFont+RO.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 15/5/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (RO)

+ (UIFont *)ro_fontWithFamilyName:(NSString *)familyName size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic;

@end
