//
//  ROWebBrowserAction.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 11/05/14.
//

#import "ROUriAction.h"
#import "ROAction.h"

/**
 Open web browser with url
 */
@interface ROWebBrowserAction : ROUriAction<ROAction>

/**
 Constructor with url string
 @param urlString Url string
 @return Class instance
 */
- (id)initWithValue:(NSString *)urlString;

@end
