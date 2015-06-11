//
//  ROStyles.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/7/14.
//

#import "ROObject.h"
#import "RONavigationViewController.h"

@interface ROStyle : ROObject

@property (nonatomic, strong) NSString *fileName;

@property (nonatomic, strong) UIColor *accentColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *foregroundColor;
@property (nonatomic, strong) UIColor *applicationBarBackgroundColor;
@property (nonatomic, strong) UIColor *applicationBarTextColor;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *placeHolderImage;
@property (nonatomic, strong) UIImage *noPhotoImage;

@property (nonatomic, strong) NSString *fontFamily;
@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, strong) NSNumber *fontSize;
@property (nonatomic, strong) NSNumber *fontSizeSmall;
@property (nonatomic, strong) NSNumber *fontSizeLarge;

@property (nonatomic, strong) NSNumber *tableViewCellHeightMin;

//Extras
@property (nonatomic, assign) RONavigationType navigationTypeDefault;

/**
 Singleton
 @return Class instance
 */
+ (instancetype)sharedInstance;

/**
 Set style for label
 @param label Label to apply the style
 */
- (void)processLabel:(UILabel *)label;

/**
 Set styles
 */
- (void)process;

/**
 Font with default font name and font size
 @return UIFont Default font
 */
- (UIFont *)font;

/**
 Font with default font name and custom font size
 @return UIFont Default font
 */
- (UIFont *)fontWithSize:(CGFloat)fontSize;


- (UIFont *)fontWithSize:(CGFloat)fontSize bold:(BOOL)isBold italic:(BOOL)isItalic;


- (BOOL)useStyleLightForColor:(UIColor *)contrastingColor;

@end
