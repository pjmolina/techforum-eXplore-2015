//
//  UIView+RO.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/30/14.
//

#import <UIKit/UIKit.h>

/**
 Helper to UIView
 */
@interface UIView (RO)

/**
 Set a background image keeping the ratio aspet
 */
- (void)ro_setBackgroundImage:(UIImage *)image;

/**
 Set a background image pattern
 */
- (void)ro_setBackgroundPattern:(UIImage *)image;

/**
 Set a background color
 */
- (void)ro_setBackgroundColor:(UIColor *)color;

@end
