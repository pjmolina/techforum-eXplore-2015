//
//  ROTableViewController_.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 18/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROViewController.h"

@protocol ROTableViewDelegate <NSObject>

/**
 *  Configure cell at index path
 *
 *  @param cell Cell to configure
 *  @param indexPath IndexPath
 */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@interface ROTableViewController : ROViewController <RODataDelegate>

/**
 *  Table view
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 *  Table view style
 */
@property (nonatomic, assign) UITableViewStyle tableViewStyle;

/**
 *  Items to load
 */
@property (nonatomic, strong) NSArray *items;

/**
 ROTableViewDelegate
 */
@property (nonatomic, weak) id<ROTableViewDelegate> tableViewDelegate;

/**
 Load data on pagination
 */
- (void)loadMore;

@end
