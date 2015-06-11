//
//  RODatasourceParams.m
//  RadarcOnlinesSDK
//
//  Created by Icinetic S.L. on 10/8/14.
//
//

#import "ROOptionsFilter.h"

@implementation ROOptionsFilter

- (NSMutableDictionary *)extra
{
    if (!_extra) {
        _extra = [NSMutableDictionary new];
    }
    return _extra;
}

- (NSMutableArray *) filters{
    if(!_filters) {
        _filters = [NSMutableArray new];
    }
    return _filters;
}

@end
