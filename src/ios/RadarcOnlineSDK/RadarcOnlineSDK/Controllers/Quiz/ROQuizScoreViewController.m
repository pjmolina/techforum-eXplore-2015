//
//  ROQuizScoreViewController.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 23/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROQuizScoreViewController.h"
#import "ROQuizNavigationController.h"
#import "ROQuizStyle.h"
#import "ROStyle.h"
#import "UIView+RO.h"
#import "ROQuiz.h"
#import "NSBundle+RO.h"
#import "UIImage+RO.h"

@interface ROQuizScoreViewController ()

@property (strong, nonatomic) ROQuizNavigationController *navController;

@property (strong, nonatomic) ROQuizStyle *style;

@end

@implementation ROQuizScoreViewController

- (instancetype)init
{
    self = [super initWithNibName:@"ROQuizScoreViewController" bundle:[NSBundle ro_resourcesBundle]];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.navController = (ROQuizNavigationController *)self.navigationController;
    self.style = self.navController.quiz.style;
    
    // Styles
    
    self.view.backgroundColor = [[ROStyle sharedInstance] backgroundColor];
    [self.view ro_setBackgroundImage:[[ROStyle sharedInstance] backgroundImage]];
    
    self.currentScoreLabel.font = [self.style.font fontWithSize:80];
    self.currentScoreLabel.textColor = self.style.questionColor;
    self.currentScoreLabel.backgroundColor = self.style.questionBackgroundColor;
    self.currentScoreLabel.layer.borderWidth = 2.0f;
    self.currentScoreLabel.layer.borderColor = [self.style.questionBackgroundColor colorWithAlphaComponent:1.0f].CGColor;
    self.currentScoreLabel.layer.masksToBounds = YES;
    self.currentScoreLabel.layer.cornerRadius = self.currentScoreLabel.bounds.size.height / 2;

    self.currentScoreTitleLabel.font = [self.style.font fontWithSize:22];
    self.currentScoreTitleLabel.textColor = [[ROStyle sharedInstance] foregroundColor];
    
    self.bestScoreTitleLabel.font = [self.style.font fontWithSize:22];
    self.bestScoreTitleLabel.textColor = [[ROStyle sharedInstance] foregroundColor];
    
    self.bestScoreLabel.font = [self.style.font fontWithSize:28];
    self.bestScoreLabel.textColor = self.style.questionColor;
    
    self.playAgainButton.tintColor = self.style.answerColor;
    self.playAgainButton.backgroundColor = self.style.answerBackgroundColor;
    self.playAgainButton.titleLabel.font = self.style.font;

    self.bestScoreImageView.image = [[UIImage ro_imageNamed:@"crown"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.bestScoreImageView setTintColor:self.style.questionColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.navController.quiz.title;
    
    NSInteger currentScore = self.navController.points;
    
    self.currentScoreLabel.text = [@(currentScore) stringValue];
    
    NSInteger bestScore = self.navController.quiz.bestScore;
    
    NSString *bestScoreTitle = NSLocalizedString(@"Best", nil);
    if (currentScore > bestScore) {
        bestScoreTitle = NSLocalizedString(@"New best score!", nil);
        bestScore = currentScore;
        self.navController.quiz.bestScore = bestScore;
    }
    self.bestScoreTitleLabel.text = bestScoreTitle;
    self.bestScoreLabel.text = [@(bestScore) stringValue];
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeQuiz)];
    self.navigationItem.leftBarButtonItem = closeItem;
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = shareItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeQuiz
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)share:(id)sender
{
    NSString *shareString = [NSString stringWithFormat:@"I’ve just scored %li playing %@",
                             (long)self.navController.points,
                             self.navController.quiz.title];
    
    NSArray *objectsToShare = @[shareString];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    // Present the controller
    [self presentViewController:activityController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)playAgainButtonAction:(id)sender {
    [self.navController reset];
}

@end
