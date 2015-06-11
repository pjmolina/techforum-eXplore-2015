//
//  UIImage+RO.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 12/10/14.
//

#import "UIImage+RO.h"
#import "NSBundle+RO.h"
#import "NSString+RO.h"

@implementation UIImage (RO)

+ (UIImage*)ro_imageNamed:(NSString*)name
{
    if (name && [[name ro_trim] length] != 0) {
        UIImage *imageFromMainBundle = [UIImage imageNamed:name];
        if (imageFromMainBundle) {
            return imageFromMainBundle;
        }
        NSString *path = [[NSBundle ro_resourcesBundle] pathForResource:name ofType:@"png"];
        UIImage *imageFromBundle = [UIImage imageWithContentsOfFile:path];
        return imageFromBundle;
    } else {
        return nil;
    }
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1,1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
