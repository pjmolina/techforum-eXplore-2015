//
//  ROSearchBehavior.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 29/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROSearchBehavior.h"
#import "ROStyle.h"
#import "NSString+RO.h"
#import "ROTableViewController.h"
#import "ROCollectionViewController.h"
#import "ROOptionsFilter.h"

@interface ROSearchBehavior () <UISearchBarDelegate>

@end

@implementation ROSearchBehavior

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

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.viewController.view.bounds), 44)];
        _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchBar.tintColor = [[ROStyle sharedInstance] applicationBarTextColor];
        _searchBar.barTintColor = [[ROStyle sharedInstance] applicationBarBackgroundColor];
        
        // Hide clear button
        NSArray *subviews = _searchBar.subviews.count == 1 ? [_searchBar.subviews.firstObject subviews] : _searchBar.subviews;
        for (id view in subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)view;
                textField.clearButtonMode = UITextFieldViewModeNever;
                break;
            }
        }
    }
    return _searchBar;
}

- (void)load
{
    self.searchBar.delegate = self;
    if ([self.viewController isKindOfClass:[ROTableViewController class]]) {
        
        ROTableViewController *tableViewController = (ROTableViewController *)self.viewController;
        
        NSArray *constrains = tableViewController.view.constraints;
        
        [tableViewController.view removeConstraints:constrains];
        
        [tableViewController.view addSubview:self.searchBar];
        
        NSDictionary *viewsBindings = @{
                                        @"searchBar" : self.searchBar,
                                        @"tableView" : tableViewController.tableView
                                        };
        
        // align tableView from the left and right
        [tableViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[searchBar]-0-|"
                                                                          options:NSLayoutFormatDirectionLeadingToTrailing
                                                                          metrics:nil
                                                                            views:viewsBindings]];
        
        // align tableView from the left and right
        [tableViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|"
                                                                          options:NSLayoutFormatDirectionLeadingToTrailing
                                                                          metrics:nil
                                                                            views:viewsBindings]];
        
        // align tableView from the top and bottom
        [tableViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[searchBar]-[tableView]-0-|"
                                                                          options:NSLayoutFormatDirectionLeadingToTrailing
                                                                          metrics:nil
                                                                            views:viewsBindings]];
         
    } else if ([self.viewController isKindOfClass:[ROCollectionViewController class]]) {
        
        ROCollectionViewController *collectionViewController = (ROCollectionViewController *)self.viewController;

        NSArray *constrains = collectionViewController.view.constraints;
        
        [collectionViewController.view removeConstraints:constrains];
        
        [collectionViewController.view addSubview:self.searchBar];
        
        NSDictionary *viewsBindings = @{
                                        @"searchBar" : self.searchBar,
                                        @"collectionView" : collectionViewController.collectionView
                                        };
        
        // align tableView from the left and right
        [collectionViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[searchBar]-0-|"
                                                                                              options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                              metrics:nil
                                                                                                views:viewsBindings]];
        
        // align tableView from the left and right
        [collectionViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|"
                                                                                              options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                              metrics:nil
                                                                                                views:viewsBindings]];
        
        // align tableView from the top and bottom
        [collectionViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[searchBar]-[collectionView]-0-|"
                                                                                              options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                              metrics:nil
                                                                                                views:viewsBindings]];
    }
}

- (void)onDataSuccess
{

}

#pragma mark - Search bar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (!searchBar.showsCancelButton) {
        [searchBar setShowsCancelButton:YES animated:YES];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (searchBar.showsCancelButton) {
        [searchBar setShowsCancelButton:NO animated:YES];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text && [[searchBar.text ro_trim] length] != 0) {
        [self search:searchBar.text];
    } else {
        [self search:nil];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    [self search:nil];
}

- (void)search:(NSString *)searchText
{
    [self.viewController.view endEditing:YES];
    ROOptionsFilter *optionsFilter = [self.viewController.dataLoader optionsFilter];
    optionsFilter.searchText = searchText;
    [self.viewController.dataLoader setOptionsFilter:optionsFilter];
    [self.viewController loadData];
}

@end
