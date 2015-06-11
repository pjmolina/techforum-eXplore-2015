//
//  ROQuestionViewController.m
//  FilterTest
//
//  Created by Víctor Jordán Rosado on 21/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROQuizItemViewController.h"
#import "ROQuizStyle.h"
#import "ROQuizItem.h"
#import "ROQuizQuestion.h"
#import "ROQuizAnswer.h"
#import "UIView+RO.h"
#import "ROStyle.h"
#import "ROQuizNavigationController.h"
#import "ROQuiz.h"
#import "NSArray+RO.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "NSString+RO.h"
#import "UIImageView+RO.h"

static NSString *const kAnswerCell = @"answerCell";

@interface ROQuizItemViewController () <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) NSInteger answerIndex;

@property (strong, nonatomic) ROQuizNavigationController *navController;

@property (strong, nonatomic) ROQuizStyle *style;

@property (strong, nonatomic) NSArray *answers;

@end

@implementation ROQuizItemViewController

- (instancetype)initWithQuizItem:(ROQuizItem *)quizItem
{
    self = [super init];
    if (self) {
        _quizItem = quizItem;
    }
    return self;
}

- (void)loadView
{
    self.view = self.tableView;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navController = (ROQuizNavigationController *)self.navigationController;
    self.style = self.navController.quiz.style;
    
    self.title = [self.navController stepTitle];
    
    ROQuizQuestion *question = self.quizItem.question;
    if (question.question) {
        self.questionLabel.text = question.question;
    }
    if (question.questionImageResource) {
        self.questionImageView.image = [UIImage imageNamed:question.questionImageResource];
    }
    if (question.questionImageUrl) {

        [self.questionImageView ro_setImageWithUrlString:question.questionImageUrl
                                              imageError:[[ROStyle sharedInstance] noPhotoImage]];

    }
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeQuiz)];
    self.navigationItem.leftBarButtonItem = closeItem;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.answerIndex = -1;
    self.tableView.userInteractionEnabled = YES;
    self.answers = [self.quizItem.answers ro_shuffled];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [[ROStyle sharedInstance] backgroundColor];
        [_tableView ro_setBackgroundImage:[[ROStyle sharedInstance] backgroundImage]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        CGFloat headerHeight = 150.0f;
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headerHeight)];
        _headerView.backgroundColor = self.style.questionBackgroundColor;
        _headerView.clipsToBounds = YES;
        
        if (self.quizItem.question) {
            
            ROQuizQuestion *question = self.quizItem.question;
            if (question.question && [[question.question ro_trim] length] != 0) {
                
                [_headerView addSubview:self.questionLabel];
                
                if (self.quizItem.question.questionImageResource || self.quizItem.question.questionImageUrl) {
                    
                    self.questionLabel.numberOfLines = 2;
                    [_headerView addSubview:self.questionImageView];
                    
                    [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_questionLabel]-[_questionImageView]-|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:NSDictionaryOfVariableBindings(_questionImageView, _questionLabel)]];
                    
                    [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_questionLabel]-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:NSDictionaryOfVariableBindings(_questionLabel)]];
                    
                    [_headerView addConstraint:[NSLayoutConstraint constraintWithItem:self.questionImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_headerView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
                    
                } else {
                    
                    self.questionLabel.numberOfLines = 4;
                    self.questionLabel.center = _headerView.center;
                    
                    [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_questionLabel]-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:NSDictionaryOfVariableBindings(_questionLabel)]];
                    
                    [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_questionLabel]-|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:NSDictionaryOfVariableBindings(_questionLabel)]];
                }
                
            } else if (self.quizItem.question.questionImageResource || self.quizItem.question.questionImageUrl) {
                
                self.questionImageView.center = _headerView.center;
                
                [_headerView addSubview:self.questionImageView];
                
                [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_questionImageView]-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:NSDictionaryOfVariableBindings(_questionImageView)]];
                
                [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_questionImageView]-|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:NSDictionaryOfVariableBindings(_questionImageView)]];
                
            }
            
        }
    }
    return _headerView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectZero];
        _footerView.backgroundColor = [UIColor clearColor];
    }
    return _footerView;
}

- (UILabel *)questionLabel
{
    if (!_questionLabel) {
        _questionLabel = [[UILabel alloc] init];
        _questionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _questionLabel.backgroundColor = [UIColor clearColor];
        _questionLabel.textAlignment = NSTextAlignmentCenter;
        _questionLabel.font = self.style.font;
        _questionLabel.textColor = self.style.questionColor;
    }
    return _questionLabel;
}

- (UIImageView *)questionImageView
{
    if (!_questionImageView) {
        _questionImageView = [[UIImageView alloc] init];
        _questionImageView.backgroundColor = [UIColor clearColor];
        _questionImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _questionImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _questionImageView;
}

- (ROQuizStyle *)style
{
    if (!_style) {
        _style = [ROQuizStyle new];
    }
    return _style;
}

- (void)closeQuiz
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.answers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20.0f;
    }
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAnswerCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAnswerCell];
        cell.backgroundView = nil;
        cell.textLabel.textColor = self.style.answerColor;
        cell.textLabel.font = self.style.font;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = self.style.answerBackgroundColor;
        UIView *selectecedView = [[UIView alloc] init];
        selectecedView.backgroundColor = [self.style.answerColor colorWithAlphaComponent:0.1f];
        cell.selectedBackgroundView = selectecedView;
    }
    ROQuizAnswer *quizAnswer = self.answers[(NSUInteger)indexPath.section];
    cell.textLabel.text = quizAnswer.answer;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.answerIndex != -1) {
        ROQuizAnswer *answer = self.answers[(NSUInteger)indexPath.section];
        if (answer.isCorrect) {
            cell.backgroundColor = self.style.successColor;
        } else if (self.answerIndex == indexPath.section) {
            cell.backgroundColor = self.style.failureColor;
        }
    } else {
        cell.backgroundColor = self.style.answerBackgroundColor;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.answerIndex = indexPath.section;
    self.tableView.userInteractionEnabled = NO;
    
    ROQuizAnswer *answer = self.answers[(NSUInteger)indexPath.section];
    if (answer.isCorrect) {
        self.navController.points += self.quizItem.question.points;
    }
    
    CGFloat delaySec = [self.style.answerDelay floatValue];
    
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        
        [self.tableView reloadData];
        
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * delaySec);
        dispatch_after(delay, dispatch_get_main_queue(), ^(void){
            
            [self.navController next];
            
        });
        
    });
}


@end
