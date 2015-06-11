//
//  QuizViewController.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 19/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROViewController.h"

@class ROQuiz;
@class ROQuizItem;

@protocol ROQuizDelegate <NSObject>

/**
 Binding datasource item on quiz item
 @param datasourceItem Datasource item
 @return Quiz item
 */
- (ROQuizItem *)quizItemByDatasourceItem:(id)item;

@end

/**
 Quiz view controller
 */
@interface ROQuizViewController : ROViewController <RODataDelegate>

/**
 Quiz
 */
@property (strong, nonatomic) ROQuiz *quiz;

/**
 Quiz delegate
 */
@property (weak, nonatomic) id<ROQuizDelegate> delegate;

/**
 Quiz description label
 */
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

/**
 Quiz start button
 */
@property (strong, nonatomic) IBOutlet UIButton *startButton;

/**
 Transition to show quiz
 */
@property (assign, nonatomic) UIModalTransitionStyle transitionStyle;

/**
 Quiz start buton action
 */
- (IBAction)startButtonAction:(id)sender;

@end
