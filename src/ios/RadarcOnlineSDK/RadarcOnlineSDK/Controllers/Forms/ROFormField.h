//
//  ROFormField.h
//  RadarcOnlineSDK
//
//  Created by Víctor Jordán Rosado on 16/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROFilter.h"

@protocol ROFormField <NSObject>

- (NSString *)fieldLabel;

- (NSString *)fieldName;

- (NSString *)fieldValue;

- (void)setFieldValue:(NSString *)fieldValue;

- (id<ROFilter>)filter;

- (NSInteger)numberOfRows;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
