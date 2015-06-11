//
//  RODateRangeFilter.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 2/5/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#ifndef RadarcOnlineSDK_RODateRangeFilter_h
#define RadarcOnlineSDK_RODateRangeFilter_h

#import <Foundation/Foundation.h>
#import "ROFilter.h"

/**
 * Date range filter
 */
@interface RODateRangeFilter : NSObject  <ROFilter>
+ (RODateRangeFilter *)create:(NSString *)fieldName minDate:(NSDate *)minDate maxDate:(NSDate *) maxDate;

@end

#endif
