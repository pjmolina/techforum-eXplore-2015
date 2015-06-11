//
//  QuizViewController.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 19/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROQuizViewController.h"
#import "ROQuizStyle.h"
#import "ROStyle.h"
#import "NSBundle+RO.h"
#import "ROQuizNavigationController.h"
#import "ROQuiz.h"
#import "SVProgressHUD.h"
#import "NSArray+RO.h"
#import "ROOptionsFilter.h"
#import "ROPagination.h"
#import "ROError.h"
#import "ROPage.h"

@interface ROQuizViewController ()

@property (nonatomic, strong) NSMutableArray *quizItems;
@property (nonatomic, strong) ROOptionsFilter *optionsFilter;

- (void)startQuiz;

@end

@implementation ROQuizViewController

- (instancetype)init
{
    self = [super initWithNibName:@"ROQuizViewController" bundle:[NSBundle ro_resourcesBundle]];
    if (self) {
        _transitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    // Styles
    self.infoLabel.textColor = self.quiz.style.questionColor;
    self.infoLabel.font = self.quiz.style.font;
    
    self.startButton.tintColor = self.quiz.style.answerColor;
    self.startButton.titleLabel.font = self.quiz.style.font;
    self.startButton.backgroundColor = self.quiz.style.answerBackgroundColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ROOptionsFilter *)optionsFilter
{
    if (!_optionsFilter) {
        _optionsFilter = [ROOptionsFilter new];
    }
    return _optionsFilter;
}

- (IBAction)startButtonAction:(id)sender
{
    [self startQuiz];
}

- (void)startQuiz
{
    if (self.quizItems && [self.quizItems count] != 0) {
        self.quiz.items = [NSArray arrayWithArray:[[self.quizItems ro_shuffled] ro_subarrayWithRange:NSMakeRange(0, self.quiz.numberOfQuestions)]];
        ROQuizNavigationController *navigationController = [[ROQuizNavigationController alloc] initWithQuiz:self.quiz];
        navigationController.modalTransitionStyle = self.transitionStyle;
        [self presentViewController:navigationController animated:YES completion:nil];
    } else {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"No items to show", nil) maskType:SVProgressHUDMaskTypeGradient];
    }
}

#pragma mark - Data methods

- (void)loadData
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    if ([self.page.ds conformsToProtocol:@protocol(ROPagination)]) {
    
        self.optionsFilter.pageSize = @(100);
        id<ROPagination> datasource = (id<ROPagination>)self.page.ds;
        [datasource loadPageNum:0 withOptionsFilter:self.optionsFilter onSuccess:^(NSArray *objects) {
            
            [SVProgressHUD dismiss];
            [self loadDataSuccess:objects];
            
        } onFailure:^(NSError *error, NSHTTPURLResponse *response) {
        
            [SVProgressHUD dismiss];
            ROError *roError = [[ROError alloc] initWithFn:__PRETTY_FUNCTION__ error:error];
            NSString *msg = NSLocalizedString(@"There was a problem retrieving data", nil);
            if (response && response.statusCode == 401) {
                msg = NSLocalizedString(@"Authorization required", nil);
            }
            roError.message = msg;
            [self loadDataError:roError];
            
        }];
        
        
    } else {
        
        [self.page.ds loadOnSuccess:^(NSArray *objects) {
            
            [SVProgressHUD dismiss];
            [self loadDataSuccess:objects];
            
        } onFailure:^(NSError *error, NSHTTPURLResponse *response) {
            
            [SVProgressHUD dismiss];
            ROError *roError = [[ROError alloc] initWithFn:__PRETTY_FUNCTION__ error:error];
            NSString *msg = NSLocalizedString(@"There was a problem retrieving data", nil);
            if (response && response.statusCode == 401) {
                msg = NSLocalizedString(@"Authorization required", nil);
            }
            roError.message = msg;
            [self loadDataError:roError];
            
        }];
        
    }
}

- (void)loadDataSuccess:(NSArray *)objects
{
    if (objects && [objects count] != 0) {
        
        if ([self.delegate conformsToProtocol:@protocol(ROQuizDelegate)]) {
            self.quizItems = [NSMutableArray new];
            for (id item in objects) {
                [self.quizItems addObject:[self.delegate quizItemByDatasourceItem:item]];
            }
            if ([objects count] < self.quiz.numberOfQuestions) {
                self.quiz.numberOfQuestions = [objects count];
            }
        }
        
    }
}

- (void)loadDataError:(ROError *)error
{
    [error show];
}

@end
