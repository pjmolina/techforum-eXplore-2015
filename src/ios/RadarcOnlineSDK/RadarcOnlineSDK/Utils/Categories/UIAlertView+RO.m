//
//  UIAlertView+RO.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 8/20/14.
//
//

#import "UIAlertView+RO.h"

@implementation UIAlertView (RO)

+ (void)ro_showWithErrorMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                message:message
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                      otherButtonTitles:nil] show];
}

+ (void)ro_showWithInfoMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", nil)
                                message:message
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                      otherButtonTitles:nil] show];
}

@end