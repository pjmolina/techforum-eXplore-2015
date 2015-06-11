//
//  RONavigationAction.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/29/14.
//

#import "RONavigationAction.h"
#import "RONavigationViewController.h"
#import "ROBaseViewController.h"
#import "UIImage+RO.h"
#import "ROCustomTableViewController.h"
#import "ROBaseViewController.h"

@implementation RONavigationAction

- (id)initWithValue:(id)destination
{
    self = [super init];
    if (self && destination) {
        if ([destination isKindOfClass:[UIViewController class]]) {
            _destinationController = destination;
            _destinationClass = [_destinationController class];
        } else {
            _destinationController = nil;
            _destinationClass = destination;
        }
    }
    return self;
}

- (void)doAction
{
    if ([self canDoAction]) {
        if (!_destinationController && _destinationClass) {
            _destinationController = [_destinationClass new];
        }
        if (_destinationController) {
            if (_detailObject) {
                if ([_destinationController isKindOfClass:[ROCustomTableViewController class]]) {
                    
                    ROCustomTableViewController *viewController = (ROCustomTableViewController *)_destinationController;
                    viewController.dataItem = _detailObject;
                    
                } else if ([_destinationController isKindOfClass:[ROBaseViewController class]]) {
                    
                    ROBaseViewController *viewController = (ROBaseViewController *)_destinationController;
                    viewController.obj = _detailObject;
                    
                }
            }
            [[[RONavigationViewController sharedInstance] navigationController] pushViewController:_destinationController animated:YES];
        }

    }
}

- (BOOL)canDoAction
{
    return ([[[RONavigationViewController sharedInstance] navigationController] respondsToSelector:@selector(pushViewController:animated:)] && (_destinationClass || _destinationController));
}

- (UIImage *)actionIcon
{
    return [UIImage ro_imageNamed:@"arrow"];
}

@end
