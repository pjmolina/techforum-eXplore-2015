//
//  RORefreshBehavior.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 30/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "RORefreshBehavior.h"
#import "ROStyle.h"
#import "SVProgressHUD.h"
#import "SVPullToRefresh.h"
#import "ROPagination.h"
#import "ROPage.h"

@interface RORefreshBehavior ()

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)refreshData;
- (void)refreshDataScroll;

@end

@implementation RORefreshBehavior

- (instancetype)initWithViewController:(ROViewController<RODataDelegate> *)viewController
{
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

+ (instancetype)behaviorViewController:(ROViewController<RODataDelegate> *)viewController
{
    return [[self alloc] initWithViewController:viewController];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        for (id subview in self.viewController.view.subviews) {
            if ([subview isKindOfClass:[UIScrollView class]]) {
                _scrollView = (UIScrollView *)subview;
                break;
            }
        }
    }
    return _scrollView;
}

- (UIRefreshControl *)refreshControl
{
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        _refreshControl.tintColor = [[ROStyle sharedInstance] foregroundColor];
    }
    return _refreshControl;
}

- (void)load
{
    if (self.viewController.page.ds) {
        if (self.scrollView) {
            [self.refreshControl addTarget:self action:@selector(refreshDataScroll) forControlEvents:UIControlEventValueChanged];
            [self.scrollView addSubview:self.refreshControl];
        } else {
            self.viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)];
        }
    }
}

- (void)onDataSuccess
{

}

- (void)refreshData
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [self.viewController.dataLoader refreshDataSuccessBlock:^(id dataObject) {
        
        [SVProgressHUD dismiss];
        [weakSelf.viewController loadDataSuccess:dataObject];
        
    } failureBlock:^(ROError *error) {
        
        [SVProgressHUD dismiss];
        [weakSelf.viewController loadDataError:error];
        
    }];
}

- (void)refreshDataScroll
{
    if ([self.viewController.page.ds conformsToProtocol:@protocol(ROPagination)]) {
        self.scrollView.showsInfiniteScrolling = YES;
    }
    __weak typeof (self) weakSelf = self;
    [self.viewController.dataLoader refreshDataSuccessBlock:^(id dataObject) {
        
        [weakSelf.refreshControl endRefreshing];
        [weakSelf.viewController loadDataSuccess:dataObject];
        
    } failureBlock:^(ROError *error) {
        
        [weakSelf.refreshControl endRefreshing];
        [weakSelf.viewController loadDataError:error];
        
    }];
}

@end
