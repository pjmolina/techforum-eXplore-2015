//
//  ROQuizQuestion.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 19/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ROQuizQuestion : NSObject

@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *questionImageResource;
@property (nonatomic, strong) NSString *questionImageUrl;
@property (nonatomic, assign) NSInteger points;

- (instancetype)initWithQuestion:(NSString *)question questionImageResource:(NSString *)imageResource questionImageUrl:(NSString *)imageUrl points:(NSInteger)points;

- (instancetype)initWithQuestion:(NSString *)question questionImageResource:(NSString *)imageResource questionImageUrl:(NSString *)imageUrl;

+ (instancetype)question:(NSString *)question questionImageResource:(NSString *)imageResource questionImageUrl:(NSString *)imageUrl points:(NSInteger)points;

+ (instancetype)question:(NSString *)question questionImageResource:(NSString *)imageResource questionImageUrl:(NSString *)imageUrl;

@end
