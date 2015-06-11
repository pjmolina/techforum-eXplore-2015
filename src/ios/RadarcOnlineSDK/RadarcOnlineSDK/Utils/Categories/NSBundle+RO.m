//
//  NSBundle+RO.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 12/10/14.
//

#import "NSBundle+RO.h"

@implementation NSBundle (RO)

+ (NSBundle*)ro_resourcesBundle
{
    static dispatch_once_t onceToken;
    static NSBundle *bundle = nil;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"RadarcOnlineSDKResources" withExtension:@"bundle"]];
    });
    return bundle;
}

@end
