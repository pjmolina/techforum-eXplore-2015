//
//  UIView+RO.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/30/14.
//

#import "UIView+RO.h"

@implementation UIView (RO)

- (void)ro_setBackgroundImage:(UIImage *)image
{
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:image];
    backgroundView.opaque = NO;
    backgroundView.clipsToBounds = YES;
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    CGRect viewFrame = self.frame;
    CGRect imageFrame = backgroundView.frame;
    
    if (CGRectGetHeight(imageFrame) < CGRectGetHeight(viewFrame) || CGRectGetWidth(imageFrame) < CGRectGetWidth(viewFrame)) {
        
        backgroundView.contentMode = UIViewContentModeScaleAspectFit;
        
    } else {
        
        backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    backgroundView.frame = self.frame;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        tableView.backgroundView = nil;
        tableView.backgroundView = backgroundView;
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        collectionView.backgroundView = nil;
        collectionView.backgroundView = backgroundView;
    } else {
        [self insertSubview:backgroundView atIndex:0];
    }
}

- (void)ro_setBackgroundPattern:(UIImage *)image
{
    [self setBackgroundColor:[UIColor colorWithPatternImage:image]];
}

- (void)ro_setBackgroundColor:(UIColor *)color
{
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        tableView.backgroundColor = color;
        tableView.backgroundView = nil;
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        collectionView.backgroundColor = color;
        collectionView.backgroundView = nil;
    } else {
        self.backgroundColor = color;
    }
}

@end
