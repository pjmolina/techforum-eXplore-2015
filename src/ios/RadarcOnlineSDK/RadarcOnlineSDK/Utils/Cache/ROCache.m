//
//  ROCache.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 9/15/14.
//
//

#import "ROCache.h"
#import "NSString+RO.h"

@implementation ROCache

+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (UIImage *)imageForUrl:(NSString *)urlString
{
    NSString *key = [urlString ro_md5];
    return [self objectForKey:key];
}

- (void)setImage:(UIImage *)image forUrl:(NSString *)urlString
{
    NSString *key = [urlString ro_md5];
    [self setObject:image forKey:key];
}

@end
