//
//  ROCellDescriptor.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 24/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ROCellDescriptor <NSObject>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)receiveMemoryWarning;

- (void)registerInTableView:(UITableView *)tableView;

- (BOOL)isEmpty;

@end
