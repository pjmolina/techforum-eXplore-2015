//
//  ROAction.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/29/14.
//

#import <Foundation/Foundation.h>

/**
  Generic protocol to handle actions
 */
@protocol ROAction <NSObject>

/**
 Action to do
 */
- (void)doAction;

/**
 Can do action
 */
- (BOOL)canDoAction;

/*
 Action icon
 */
- (UIImage *)actionIcon;

@end
