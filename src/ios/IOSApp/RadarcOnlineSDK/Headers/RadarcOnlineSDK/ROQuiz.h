//
//  ROQuiz.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 23/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ROQuizStyle;

/**
 The Quiz
 */
@interface ROQuiz : NSObject

/**
 Quiz items
 */
@property (strong, nonatomic) NSArray *items;

/**
 Quiz identifier
 */
@property (strong, nonatomic) NSString *identifier;

/**
 Quiz title
 */
@property (strong, nonatomic) NSString *title;

/**
 Quiz description
 */
@property (strong, nonatomic) NSString *info;

/**
 Quiz questions count
 */
@property (assign, nonatomic) NSUInteger numberOfQuestions;

/**
 Best score
 */
@property (assign, nonatomic) NSInteger bestScore;

/**
 Quiz style
 */
@property (strong, nonatomic) ROQuizStyle *style;

/**
 Constructor with info
 @param identifier Quiz identifier
 @param info Quiz title
 @param info Quiz info
 @param numberOfQuestions Number of questions
 @return Class instance
 */
- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title info:(NSString *)info numberOfQuestions:(NSUInteger)numberOfQuestions;

/**
 Constructor with identifier and info
 @param identifier Quiz identifier
 @param info Quiz title
 @param info Quiz info
 @param numberOfQuestions Number of questions
 @return Class instance
 */
+ (instancetype)identifier:(NSString *)identifier title:(NSString *)title info:(NSString *)info numberOfQuestions:(NSUInteger)numberOfQuestions;

@end
