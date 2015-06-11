//
//  ROQuizStyle.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 23/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROQuizStyle.h"
#import "ROStyle.h"
#import "Colours.h"

@implementation ROQuizStyle


- (UIFont *)font
{
    if (!_font) {
        _font = [[ROStyle sharedInstance] fontWithSize:16];
    }
    return _font;
}

- (UIColor *)questionBackgroundColor
{
    if (!_questionBackgroundColor) {
        _questionBackgroundColor = [[[ROStyle sharedInstance] backgroundColor] colorWithAlphaComponent:0.5f];
    }
    return _questionBackgroundColor;
}

- (UIColor *)questionColor
{
    if (!_questionColor) {
        _questionColor = [[ROStyle sharedInstance] foregroundColor];
    }
    return _questionColor;
}

- (UIColor *)answerBackgroundColor
{
    if (!_answerBackgroundColor) {
        _answerBackgroundColor = [[ROStyle sharedInstance] applicationBarBackgroundColor];
    }
    return _answerBackgroundColor;
}

- (UIColor *)answerColor
{
    if (!_answerColor) {
        _answerColor = [[ROStyle sharedInstance] applicationBarTextColor];
    }
    return _answerColor;
}

- (UIColor *)successColor
{
    if (!_successColor) {
        _successColor = [UIColor colorFromHexString:@"7DB324"];
    }
    return _successColor;
}

- (UIColor *)failureColor
{
    if (!_failureColor) {
        _failureColor = [UIColor colorFromHexString:@"EA4C26"];
    }
    return _failureColor;
}

- (NSNumber *)answerDelay
{
    if (!_answerDelay) {
        _answerDelay = @(1);
    }
    return _answerDelay;
}

@end
