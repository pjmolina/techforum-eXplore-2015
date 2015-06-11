//
//  UIImage+RO.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 12/10/14.
//

#import <UIKit/UIKit.h>

/**
 Helper to UIImage
 */
@interface UIImage (RO)

/**
 @param name Image name
 @return Image
 */
+ (UIImage*)ro_imageNamed:(NSString*)name;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
