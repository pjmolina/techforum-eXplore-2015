//
//  Filter.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 2/5/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#ifndef RadarcOnlineSDK_Filter_h
#define RadarcOnlineSDK_Filter_h

@protocol ROFilter <NSObject>

// Returns the field this filter is associated to
- (NSString *)getField;

// Returns the query string for querying remote datasources. IT CAN BE NULL
- (NSString *)getQueryString;

// Apply this filter to the provided value
- (BOOL)applyFilter:(NSObject *) fieldValue;

@end


#endif
