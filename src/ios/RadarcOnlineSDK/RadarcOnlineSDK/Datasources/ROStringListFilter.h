//
//  StringListFilter.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 2/5/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#ifndef RadarcOnlineSDK_ROStringListFilter_h
#define RadarcOnlineSDK_ROStringListFilter_h

#import <Foundation/Foundation.h>
#import "ROFilter.h"

/**
 * String list filter
 */
@interface ROStringListFilter : NSObject  <ROFilter>
+ (ROStringListFilter *)create:(NSString *)fieldName values:(NSMutableArray *)values;

@end

#endif