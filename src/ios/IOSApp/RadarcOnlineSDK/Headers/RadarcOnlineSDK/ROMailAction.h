//
//  ROMailAction.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 11/05/14.
//

#import "ROUriAction.h"
#import "ROAction.h"

/**
 Send mail with subject and message
 */
@interface ROMailAction : ROUriAction<ROAction>

/**
 Email subject
 */
@property (nonatomic, strong) NSString *subject;

/**
 Email recipinet
 */
@property (nonatomic, strong) NSString *recipient;

/**
 Email body
 */
@property (nonatomic, strong) NSString *body;

/**
 Constructor with values
 @param recipient Email recipient
 @param subject Email subject
 @param body Email body
 @return Class instance
 */
- (id)initWithRecipient:(NSString *)recipient atSubject:(NSString *)subject atBody:(NSString *)body;

/**
 Constructor with email
 @param recipient Email recipient
 @return Class instance
 */
- (id)initWithValue:(NSString *)recipient;

@end
