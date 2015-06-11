//
//  ROBehavior.h
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 27/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ROBehavior <NSObject>

- (void)load;

- (void)onDataSuccess;

- (UIViewController *)viewController;


@end
