//
//  ROModel.h
//  RadarcOnlineSDK
//
//  Created by Víctor Jordán Rosado on 22/5/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ROModelDelegate <NSObject>

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)updateWithDictionary:(NSDictionary *)dictionary;

@end