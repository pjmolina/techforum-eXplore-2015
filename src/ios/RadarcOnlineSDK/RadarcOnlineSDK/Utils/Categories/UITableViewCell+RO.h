//
//  UITableViewCell+RO.h
//  RadarcOnlineSDK
//
//  Created by Víctor Jordán Rosado on 24/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ROAction.h"

@interface UITableViewCell (RO)

- (void)ro_configureSelectedView;

- (void)ro_configureAction:(NSObject<ROAction> *)action;

@end
