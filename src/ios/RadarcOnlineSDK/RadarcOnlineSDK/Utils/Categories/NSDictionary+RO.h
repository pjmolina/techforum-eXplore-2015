//
//  NSDictionary+RO.h
//  RadarcOnlineSDK
//
//  Created by Víctor Jordán Rosado on 22/5/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (RO)

- (NSString *)ro_stringForKey:(id)key;

- (NSNumber *)ro_numberForKey:(id)key;

- (NSNumber *)ro_numberForKey:(id)key format:(NSNumberFormatter *)format;

- (double)ro_doubleForKey:(id)key;

- (NSDate *)ro_dateForKey:(id)key;

- (NSDate *)ro_dateForKey:(id)key format:(NSString *)format;

@end
