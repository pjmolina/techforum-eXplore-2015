//
//  ROQuizItem.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 19/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROQuizItem.h"
#import "ROQuizQuestion.h"
#import "ROQuizAnswer.h"
#import "NSString+RO.h"

@implementation ROQuizItem

- (instancetype)initWithQuestion:(ROQuizQuestion *)question answers:(NSMutableArray *)answers
{
    self = [super init];
    if (self) {
        _question = question;
        _answers = answers;
    }
    return self;
}

+ (instancetype)itemWithQuestion:(ROQuizQuestion *)question answers:(NSMutableArray *)answers
{
    return [[self alloc] initWithQuestion:question answers:answers];
}

- (instancetype)initWithQuestion:(ROQuizQuestion *)question
{
    return [self initWithQuestion:question answers:nil];
}

+ (instancetype)itemWithQuestion:(ROQuizQuestion *)question
{
    return [[self alloc] initWithQuestion:question];
}

- (instancetype)initWithQuestionString:(NSString *)questionString questionImage:(NSString *)questionImage
{
    NSString *questionImageResource = nil;
    NSString *questionImageUrl = nil;
    if (questionImage && [[questionImage ro_trim] length] != 0) {
        if ([questionImage isUrl]) {
            questionImageUrl = questionImage;
        } else {
            questionImageResource = questionImage;
        }
    }
    
    if (questionString && [[questionString ro_trim] length] == 0) {
        questionString = nil;
    }
    
    ROQuizQuestion *question = [ROQuizQuestion question:questionString
                                  questionImageResource:questionImageResource
                                       questionImageUrl:questionImageUrl];
    
    return [self initWithQuestion:question answers:nil];
}

+ (instancetype)itemWithQuestionString:(NSString *)questionString questionImage:(NSString *)questionImage
{
    return [[self alloc] initWithQuestionString:questionString questionImage:questionImage];
}

- (void)addAnswer:(ROQuizAnswer *)answer
{
    [self.answers addObject:answer];
}

- (NSMutableArray *)answers
{
    if (!_answers) {
        _answers = [NSMutableArray new];
    }
    return _answers;
}

@end
