//
//  RONavigationAction.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/29/14.
//

#import <Foundation/Foundation.h>
#import "ROAction.h"

/**
 Sets navigation between controllers
 */
@interface RONavigationAction : NSObject <ROAction>

/**
 Destination controller
 */
@property (nonatomic, strong) UIViewController *destinationController;

/**
 Detail object
 */
@property (nonatomic, strong) NSObject *detailObject;

/**
 Destination controller class
 */
@property (nonatomic, strong) Class destinationClass;

/**
 Contructor with destination controller or class
 @param destination Destination controller or class
 @return Class instance
 */
- (id)initWithValue:(id)destination;

@end
