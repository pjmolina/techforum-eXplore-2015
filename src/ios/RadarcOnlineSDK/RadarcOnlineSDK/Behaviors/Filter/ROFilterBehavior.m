//
//  ROFilterBehavior.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 29/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROFilterBehavior.h"
#import "ROFormViewController.h"
#import "NSBundle+RO.h"
#import "UIImage+RO.h"
#import "ROTableViewController.h"
#import "ROCollectionViewController.h"
#import "ROOptionsFilter.h"

@interface ROFilterBehavior () <ROFormDelegate>

@property (nonatomic, strong) ROFormViewController *filterController;

- (void)openFilter;

@end

@implementation ROFilterBehavior

- (instancetype)initWithViewController:(ROViewController<RODataDelegate> *)viewController filterControllerClass:(Class)filterControllerClass
{
    self = [super init];
    if (self) {
        _viewController = viewController;
        _filterControllerClass = filterControllerClass;
    }
    return self;
}

+ (instancetype)behaviorViewController:(ROViewController<RODataDelegate> *)viewController filterControllerClass:(Class)filterControllerClass
{
    return [[self alloc] initWithViewController:viewController filterControllerClass:filterControllerClass];
}

- (void)load
{
    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc] initWithImage:[UIImage ro_imageNamed:@"filter"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(openFilter)];
    self.viewController.navigationItem.rightBarButtonItem = filterItem;
}

- (void)onDataSuccess
{

}

- (ROFormViewController *)filterController
{
    if (!_filterController) {
        if (_filterControllerClass) {
            _filterController = [[_filterControllerClass alloc] initWithNibName:@"ROFormViewController"
                                                                         bundle:[NSBundle ro_resourcesBundle]];
        } else {
            _filterController = [ROFormViewController form];
        }
        _filterController.page = self.viewController.page;
        _filterController.formDelegate = self;
    }
    return _filterController;
}

- (void)openFilter
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.filterController];
    [self.viewController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Filter / Form delegate

- (void)formSubmitted
{
    ROOptionsFilter *optionsFilter = [[self.viewController dataLoader] optionsFilter];
    optionsFilter.searchText = nil;
    optionsFilter.filters = self.filterController.filters;
    [self.viewController.dataLoader setOptionsFilter:optionsFilter];
    [self.viewController loadData];
}

@end
