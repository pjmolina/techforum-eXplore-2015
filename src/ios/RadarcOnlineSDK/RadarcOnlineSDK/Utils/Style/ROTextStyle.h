//
//  ROTextStyle.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 16/5/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    
    ROFontSizeStyleMedium = 0,
    ROFontSizeStyleSmall,
    ROFontSizeStyleLarge
    
} ROFontSizeStyle;

@interface ROTextStyle : NSObject

@property (nonatomic, assign) ROFontSizeStyle fontSizeStyle;

@property (nonatomic, assign) BOOL bold;

@property (nonatomic, assign) BOOL italic;

@property (nonatomic, assign) NSTextAlignment textAligment;

@property (nonatomic, strong) UIColor *textColor;

- (instancetype)initWithFontSizeStyle:(ROFontSizeStyle)fontSizeStyle bold:(BOOL)isBold italic:(BOOL)isItalic textAligment:(NSTextAlignment)textAligment textColor:(id)textColor;

+ (instancetype)style:(ROFontSizeStyle)fontSizeStyle bold:(BOOL)isBold italic:(BOOL)isItalic textAligment:(NSTextAlignment)textAligment textColor:(id)textColor;

- (instancetype)initWithFontSizeStyle:(ROFontSizeStyle)fontSizeStyle bold:(BOOL)isBold italic:(BOOL)isItalic textAligment:(NSTextAlignment)textAligment;

+ (instancetype)style:(ROFontSizeStyle)fontSizeStyle bold:(BOOL)isBold italic:(BOOL)isItalic textAligment:(NSTextAlignment)textAligment;

- (UIFont *)font;

@end
