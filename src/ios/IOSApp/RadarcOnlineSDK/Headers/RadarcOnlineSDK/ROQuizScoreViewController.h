//
//  ROQuizScoreViewController.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 23/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ROQuizScoreViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *currentScoreLabel;

@property (strong, nonatomic) IBOutlet UILabel *currentScoreTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *bestScoreTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *bestScoreLabel;

@property (strong, nonatomic) IBOutlet UIButton *playAgainButton;

@property (strong, nonatomic) IBOutlet UIImageView *bestScoreImageView;

- (IBAction)playAgainButtonAction:(id)sender;

@end
