//
//  ROQuizItem.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 19/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ROQuizQuestion;
@class ROQuizAnswer;

/**
 Quiz item
 */
@interface ROQuizItem : NSObject

/**
 Quiz question
 */
@property (nonatomic, strong) ROQuizQuestion *question;

/**
 Quiz answer
 */
@property (nonatomic, strong) NSMutableArray *answers;

/**
 Constructor with question and answers
 @param question Question
 @param answers Answers
 */
- (instancetype)initWithQuestion:(ROQuizQuestion *)question answers:(NSMutableArray *)answers;

/**
 Constructor with question and answers
 @param question Question
 @param answers Answers
 */
+ (instancetype)itemWithQuestion:(ROQuizQuestion *)question answers:(NSMutableArray *)answers;

/**
 Constructor with question
 @param question Question
 */
- (instancetype)initWithQuestion:(ROQuizQuestion *)question;

/**
 Constructor with question
 @param question Question
 */
+ (instancetype)itemWithQuestion:(ROQuizQuestion *)question;

/**
 Constructor with question string
 @param questionString Question string
 @param questionImage Question image resource
 */
- (instancetype)initWithQuestionString:(NSString *)questionString questionImage:(NSString *)questionImage;

/**
 Constructor with question
 @param questionString Question string
 @param questionImage Question image resource
 */
+ (instancetype)itemWithQuestionString:(NSString *)questionString questionImage:(NSString *)questionImage;

/**
 Add answer to quiz item
 @param answer Answer to add
 */
- (void)addAnswer:(ROQuizAnswer *)answer;

@end
