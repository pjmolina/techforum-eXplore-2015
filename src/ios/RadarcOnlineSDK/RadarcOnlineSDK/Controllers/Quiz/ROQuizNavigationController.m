//
//  ROQuizNavigationController.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 23/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROQuizNavigationController.h"
#import "ROQuizItemViewController.h"
#import "ROQuizScoreViewController.h"
#import "ROQuizItem.h"
#import "ROQuiz.h"

@interface ROQuizNavigationController ()

@property (strong, nonatomic) NSArray *items;

@end

@implementation ROQuizNavigationController

- (instancetype)initWithQuiz:(ROQuiz *)quiz
{
    if (quiz.items && [quiz.items count] != 0) {
        ROQuizItem *item = quiz.items[0];
        ROQuizItemViewController *itemViewController = [[ROQuizItemViewController alloc] initWithQuizItem:item];
        self = [super initWithRootViewController:itemViewController];
    } else {
        self = [super init];
    }
    if (self) {
        _quiz = quiz;
        _items = quiz.items;
        _index = 0;
        _points = 0;
    }
    return self;
}

- (void)next
{
    if (self.index < [self.items count] - 1) {
        self.index = self.index + 1;
        ROQuizItem *item = self.items[self.index];
        ROQuizItemViewController *itemViewController = [[ROQuizItemViewController alloc] initWithQuizItem:item];
        [self pushViewController:itemViewController animated:YES];
    } else {
        ROQuizScoreViewController *scoreViewController = [ROQuizScoreViewController new];
        [self pushViewController:scoreViewController animated:YES];
    }
}

- (void)reset
{
    self.index = 0;
    self.points = 0;
    [self popToRootViewControllerAnimated:YES];
}

- (NSString *)stepTitle
{
    return [NSString stringWithFormat:@"Question %lu / %lu", (unsigned long)self.index + 1, (unsigned long)[self.items count]];
}

@end
