//
//  ROWebContent.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/25/14.
//

#import <Foundation/Foundation.h>

/**
 Model to web content.
 */
@interface ROWebContent : NSObject

/**
 Html content
 */
@property (nonatomic, strong) NSString *content;

/**
 Constructor with a content string
 @param content Html content
 @return Class instance
 */
- (id)initWithContent:(NSString *)content;

@end
