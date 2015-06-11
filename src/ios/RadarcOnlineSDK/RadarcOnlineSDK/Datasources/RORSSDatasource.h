//
//  RORSSDatasource.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/2/14.
//

#import <Foundation/Foundation.h>
#import "RODatasource.h"

@interface RORSSDatasource : NSObject <RODatasource>

@property (nonatomic, strong) NSString *urlString;

- (id)initWithUrlString:(NSString *)urlString;

- (NSURLRequest *)prepareRequest;

@end
