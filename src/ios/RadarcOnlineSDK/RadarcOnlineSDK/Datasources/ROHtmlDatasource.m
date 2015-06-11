//
//  ROHtmlDatasource.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/28/14.
//

#import "ROHtmlDatasource.h"
#import "ROWebContent.h"
#import "ROStyle.h"
#import <Colours/Colours.h>

@implementation ROHtmlDatasource

- (void)setWebContent:(id)webContent
{
    if ([webContent isKindOfClass:[NSDictionary class]]) {
        _webContent = [ROWebContent new];
        [_webContent setValuesForKeysWithDictionary:webContent];
    } else {
        _webContent = webContent;
    }
    _webContent.content = [NSString stringWithFormat:@"%@<style>body{background:none;color:%@;font-family:'%@';font-size:%@px;}</style>",_webContent.content, [[[ROStyle sharedInstance] foregroundColor] hexString], [[ROStyle sharedInstance] fontFamily], [[ROStyle sharedInstance] fontSize]];
}

- (BOOL)hasPullToRefresh
{
    return NO;
}

- (void)loadOnSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock
{
    NSArray *objects = @[_webContent.content];
    if (successBlock) {
        successBlock(objects);
    }
}

- (void)loadWithOptionsFilter:(ROOptionsFilter *)optionsFilter onSuccess:(RODatasourceSuccessBlock)successBlock onFailure:(RODatasourceErrorBlock)failureBlock
{
    [self loadOnSuccess:successBlock onFailure:failureBlock];
}

@end
