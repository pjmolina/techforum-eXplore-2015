//
//  ROCache.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 9/15/14.
//
//

#import <Foundation/Foundation.h>

@interface ROCache : NSCache

+ (instancetype)sharedInstance;

- (UIImage *)imageForUrl:(NSString *)urlString;

- (void)setImage:(UIImage *)image forUrl:(NSString *)urlString;

@end
