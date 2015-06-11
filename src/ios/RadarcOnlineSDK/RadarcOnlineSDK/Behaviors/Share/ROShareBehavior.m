//
//  ROShareBehavior.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 30/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROShareBehavior.h"
#import "ROCustomTableViewController.h"
#import "ROCellDescriptor.h"
#import "ROHeaderCellDescriptor.h"
#import "ROTextCellDescriptor.h"

@interface ROShareBehavior ()

@property (nonatomic, strong) ROCustomTableViewController *customTableViewController;
@property (nonatomic, strong) NSMutableArray *objectsToShare;

- (void)share;

@end

@implementation ROShareBehavior

- (instancetype)initWithViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

+ (instancetype)behaviorViewController:(UIViewController *)viewController
{
    return [[self alloc] initWithViewController:viewController];
}

- (ROCustomTableViewController *)customTableViewController
{
    if (!_customTableViewController) {
        if ([self.viewController isKindOfClass:[ROCustomTableViewController class]]) {
            _customTableViewController = (ROCustomTableViewController *)self.viewController;
        }
    }
    return _customTableViewController;
}

- (NSMutableArray *)objectsToShare
{
    if (!_objectsToShare) {
        _objectsToShare = [NSMutableArray new];
        for (NSObject<ROCellDescriptor> *cellDescriptor in self.customTableViewController.items) {
            if (![cellDescriptor isEmpty]){
                if ([cellDescriptor isKindOfClass:[ROHeaderCellDescriptor class]]) {
                    ROHeaderCellDescriptor *headerCellDescriptor = (ROHeaderCellDescriptor *)cellDescriptor;
                    if (headerCellDescriptor.text) {
                        [_objectsToShare addObject:headerCellDescriptor.text];
                    }
                } else if ([cellDescriptor isKindOfClass:[ROTextCellDescriptor class]]) {
                    ROTextCellDescriptor *textCellDescriptor = (ROTextCellDescriptor *)cellDescriptor;
                    if (textCellDescriptor.text) {
                        [_objectsToShare addObject:textCellDescriptor.text];
                    }
                }
            }
        }
    }
    return _objectsToShare;
}

- (void)load
{

}

- (void)onDataSuccess
{
    if (self.customTableViewController && [self.objectsToShare count] != 0) {
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                   target:self
                                                                                   action:@selector(share)];
        self.viewController.navigationItem.rightBarButtonItem = shareItem;
    }
}

- (void)share
{
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:self.objectsToShare applicationActivities:nil];
    
    // Present the controller
    [self.viewController presentViewController:activityController animated:YES completion:nil];
}

@end
