//
//  ROMapSearchAction.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 11/05/14.
//

#import "ROMapAction.h"

/**
 Open map with search location
 */
@interface ROMapSearchAction : ROMapAction

/**
 Search location
 */
@property (nonatomic, strong) NSString *location;

/**
 Constructor with location
 @param location Location search
 @return Class instance
 */
- (id)initWithValue:(NSString *)location;


@end
