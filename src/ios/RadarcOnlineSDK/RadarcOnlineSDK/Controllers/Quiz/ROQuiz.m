//
//  ROQuiz.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 23/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROQuiz.h"
#import "ROQuizStyle.h"
#import "ROQuizItem.h"
#import "ROQuizQuestion.h"
#import "ROQuizAnswer.h"

@implementation ROQuiz

- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title info:(NSString *)info numberOfQuestions:(NSUInteger)numberOfQuestions
{
    self = [super init];
    if (self) {
        _title = title;
        _identifier = identifier;
        _info = info;
        _numberOfQuestions = numberOfQuestions;
    }
    return self;
}

+ (instancetype)identifier:(NSString *)identifier title:(NSString *)title info:(NSString *)info numberOfQuestions:(NSUInteger)numberOfQuestions
{
    return [[self alloc] initWithIdentifier:identifier title:title info:info numberOfQuestions:numberOfQuestions];
}

- (NSInteger)bestScore
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:self.identifier];
}

- (void)setBestScore:(NSInteger)bestScore
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:bestScore forKey:self.identifier];
}

- (ROQuizStyle *)style
{
    if (!_style) {
        _style = [ROQuizStyle new];
    }
    return _style;
}

@end
