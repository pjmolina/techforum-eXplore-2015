//
//  ROHtmlDatasource.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/28/14.
//

#import <Foundation/Foundation.h>
#import "RODatasource.h"
#import "ROObject.h"

@class ROWebContent;

@interface ROHtmlDatasource : ROObject <RODatasource>

@property (nonatomic, strong) ROWebContent *webContent;

@end