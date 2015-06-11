//
//  ROQuizStyle.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 23/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Quiz styles
 */
@interface ROQuizStyle : NSObject

/**
 Quiz font
 */
@property (strong, nonatomic) UIFont *font;

/**
 Background question color
 */
@property (strong, nonatomic) UIColor *questionBackgroundColor;

/**
 Question text color
 */
@property (strong, nonatomic) UIColor *questionColor;

/**
 Background answer color
 */
@property (strong, nonatomic) UIColor *answerBackgroundColor;

/**
 Text answer color
 */
@property (strong, nonatomic) UIColor *answerColor;

/**
 Success color
 */
@property (strong, nonatomic) UIColor *successColor;

/**
 Failure color
 */
@property (strong, nonatomic) UIColor *failureColor;

/**
 Answer delay
 */
@property (strong, nonatomic) NSNumber *answerDelay;

@end
