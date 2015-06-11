//
//  ROQuizQuestion.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 19/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROQuizQuestion.h"


@implementation ROQuizQuestion

- (instancetype)initWithQuestion:(NSString *)question questionImageResource:(NSString *)imageResource questionImageUrl:(NSString *)imageUrl points:(NSInteger)points
{
    self = [super init];
    if (self) {        
        _question = [question stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        _questionImageResource = imageResource;
        _questionImageUrl = imageUrl;
        _points = points;
    }
    return self;
}

- (instancetype)initWithQuestion:(NSString *)question questionImageResource:(NSString *)imageResource questionImageUrl:(NSString *)imageUrl
{
    return [self initWithQuestion:question questionImageResource:imageResource questionImageUrl:imageUrl points:1];
}

+ (instancetype)question:(NSString *)question questionImageResource:(NSString *)imageResource questionImageUrl:(NSString *)imageUrl points:(NSInteger)points
{
    return [[self alloc] initWithQuestion:question questionImageResource:imageResource questionImageUrl:imageUrl points:points];
}

+ (instancetype)question:(NSString *)question questionImageResource:(NSString *)imageResource questionImageUrl:(NSString *)imageUrl
{
    return [[self alloc] initWithQuestion:question questionImageResource:imageResource questionImageUrl:imageUrl];
}

@end
