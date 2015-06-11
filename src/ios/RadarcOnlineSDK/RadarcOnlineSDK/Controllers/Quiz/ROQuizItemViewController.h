//
//  ROQuestionViewController.h
//  FilterTest
//
//  Created by Víctor Jordán Rosado on 21/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROViewController.h"

@class ROQuizItem;
@class ROQuizStyle;

/**
 Question controller
 */
@interface ROQuizItemViewController : UIViewController

/**
 Answers view
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 Question view
 */
@property (nonatomic, strong) UIView *headerView;

/**
 Question footer view (empty by default)
 */
@property (nonatomic, strong) UIView *footerView;

/**
 Question label
 */
@property (nonatomic, strong) UILabel *questionLabel;

/**
 Question image view
 */
@property (nonatomic, strong) UIImageView *questionImageView;

/**
 Quiz item
 */
@property (nonatomic, strong) ROQuizItem *quizItem;

/**
 Init with item
 @param quizItem Quiz item
 @return Class instance
 */
- (instancetype)initWithQuizItem:(ROQuizItem *)quizItem;

@end
