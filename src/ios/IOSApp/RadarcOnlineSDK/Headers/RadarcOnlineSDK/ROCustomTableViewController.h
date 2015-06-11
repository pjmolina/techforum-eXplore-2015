//
//  RODetailViewController.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 24/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROViewController.h"

@protocol ROCustomTableViewDelegate <NSObject>

- (void)setDataItem:(NSObject *)dataItem;

- (void)configureWithDataItem:(NSObject *)dataItem;

@end

@interface ROCustomTableViewController : ROViewController <RODataDelegate>

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
 Custom object to show
 */
@property (nonatomic, strong) NSObject *dataItem;

/**
 ROCustomTableViewDelegate
 */
@property (nonatomic, weak) id<ROCustomTableViewDelegate> customTableViewDelegate;

@end
