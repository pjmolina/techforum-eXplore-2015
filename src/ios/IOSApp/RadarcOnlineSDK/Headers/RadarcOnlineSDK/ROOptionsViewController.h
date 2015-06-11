//
//  ROOptionsViewController.h
//  ReferenceApp
//
//  Created by Icinetic S.L. on 10/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROViewController.h"

@class ROFormFieldSelection;

@interface ROOptionsViewController : ROViewController

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ROFormFieldSelection *formFieldSelection;

@end
