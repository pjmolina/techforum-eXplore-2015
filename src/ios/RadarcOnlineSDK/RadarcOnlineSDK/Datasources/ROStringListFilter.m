//
//  ROStringFilter.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 2/5/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROStringListFilter.h"

@interface ROStringListFilter () {

    NSMutableArray *validValues;
    NSString *fieldName;
    
}

@end

@implementation ROStringListFilter

+ (ROStringListFilter *)create:(NSString *)fieldName values:(NSMutableArray *)values{
    ROStringListFilter *theFilter = [[ROStringListFilter alloc] initWith:fieldName andValues:values];
    return theFilter;
}

- initWith:(NSString *)field andValues:(NSMutableArray *)values{
    self = [super init];
    if(self){
        fieldName = field;
        validValues = values;
    }
    return self;
}

- (BOOL)applyFilter:(NSObject *)fieldValue{
    if (validValues == nil || validValues.count == 0){
        return YES;
    }
    
    for (NSString *filter in validValues) {
        if ([[filter description] compare:[fieldValue description]] == NSOrderedSame)
            return YES;
    }
    
    return NO;
}

- (NSString *)getField{
    return fieldName;
}

- (NSString *)getQueryString{
    if(validValues == nil || validValues.count == 0)
        return nil;
    
    NSMutableString *res = [NSMutableString stringWithString:@"\""];
    [res appendString:fieldName];
    [res appendString:@"\":{$in:[\""];
    [res appendString:[validValues componentsJoinedByString:@"\",\""]];
    
    return [res stringByAppendingString:@"\"]}"];
}

@end