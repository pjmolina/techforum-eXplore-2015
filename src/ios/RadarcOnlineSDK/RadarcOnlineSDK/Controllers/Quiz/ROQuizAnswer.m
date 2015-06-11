//
//  ROQuizAnswer.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 19/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROQuizAnswer.h"

@implementation ROQuizAnswer

- (instancetype)initWithAnswer:(NSString *)answer isCorrect:(BOOL)isCorrect
{
    self = [super init];
    if (self) {
        _answer = [answer stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        _isCorrect = isCorrect;
    }
    return self;
}

+ (instancetype)answer:(NSString *)answer isCorrect:(BOOL)isCorrect
{
    return [[self alloc] initWithAnswer:answer isCorrect:isCorrect];   
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Answer: %@ (Correct: %@)", _answer, _isCorrect ? @"YES" : @"NO"];
}

@end
