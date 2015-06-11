//
//  ROCollectionViewController.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 16/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROViewController.h"

@protocol ROCollectionViewDelegate <NSObject>

/**
 *  Configure cell at index path
 *
 *  @param cell Cell to configure
 *  @param indexPath IndexPath
 */
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@interface ROCollectionViewController : ROViewController <RODataDelegate>

/**
 Collection view
 */
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 *  Items to load
 */
@property (nonatomic, strong) NSArray *items;

/**
 ROCollectionViewDelegate
 */
@property (nonatomic, weak) id<ROCollectionViewDelegate> collectionViewDelegate;

/**
 Number of columns
 */
@property (nonatomic, assign) NSInteger numberOfColumns;

/**
 Insets for sections
 */
@property (nonatomic, assign) UIEdgeInsets insetsSection;

/**
 Load data on pagination
 */
- (void)loadMore;

@end
