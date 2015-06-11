//
//  ROBingDatasource.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/6/14.
//

#import "RORSSDatasource.h"
#import "ROPagination.h"

@interface ROBingDatasource : RORSSDatasource <ROPagination>

@property (nonatomic, strong) NSString *searchString;

- (id)initWithSearchString:(NSString *)searchString;

@end
