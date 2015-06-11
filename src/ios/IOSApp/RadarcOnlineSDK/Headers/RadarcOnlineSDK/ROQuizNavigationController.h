//
//  ROQuizNavigationController.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 23/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ROQuiz;

/**
 Quiz navigation controller
 */
@interface ROQuizNavigationController : UINavigationController

/**
 Quiz
 */
@property (strong, nonatomic) ROQuiz *quiz;

/**
 Current index
 */
@property (nonatomic, assign) NSUInteger index;

/**
 Total points
 */
@property (nonatomic, assign) NSInteger points;

/**
 Constructor with quiz
 @param items Quiz
 @return Class instance
 */
- (instancetype)initWithQuiz:(ROQuiz *)quiz;

/**
 Show next item or result screen
 */
- (void)next;

/**
 Reset quiz
 */
- (void)reset;

/**
 Step title
 */
- (NSString *)stepTitle;

@end
