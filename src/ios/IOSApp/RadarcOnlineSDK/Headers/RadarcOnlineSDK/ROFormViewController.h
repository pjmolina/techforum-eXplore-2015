//
//  ROFormViewController.h
//  ReferenceApp
//
//  Created by Icinetic S.L. on 7/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROViewController.h"

@class ROItemCell;

@protocol ROFormDelegate <NSObject>

- (void)formSubmitted;

@end

@interface ROFormViewController : ROViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, strong) NSArray *fields;

@property (nonatomic, strong) NSMutableArray *filters;

@property (nonatomic, strong) id<ROFormDelegate> formDelegate;

+ (instancetype)form;

- (IBAction)submitButtonAction:(id)sender;

- (void)close;

- (void)cancel;

- (void)submit;

- (void)reset;

@end
