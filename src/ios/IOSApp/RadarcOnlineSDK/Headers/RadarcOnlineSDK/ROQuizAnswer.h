//
//  ROQuizAnswer.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 19/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ROQuizAnswer : NSObject

@property (nonatomic, strong) NSString *answer;
@property (nonatomic, strong) NSString *answerImageResource;
@property (nonatomic, strong) NSString *answerImageUrl;
@property (nonatomic, assign) BOOL isCorrect;

- (instancetype)initWithAnswer:(NSString *)answer isCorrect:(BOOL)isCorrect;

+ (instancetype)answer:(NSString *)answer isCorrect:(BOOL)isCorrect;

@end
