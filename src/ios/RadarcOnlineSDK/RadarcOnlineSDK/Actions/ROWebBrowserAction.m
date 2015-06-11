//
//  ROWebBrowserAction.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 11/05/14.
//

#import "ROWebBrowserAction.h"
#import "UIImage+RO.h"

@implementation ROWebBrowserAction

- (id)initWithValue:(NSString *)urlString
{
    NSString *url = @"";
    if (urlString) {
        url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSRange prefixRange = [url rangeOfString:@"://"];
        if (prefixRange.location == NSNotFound) {
            url = [NSString stringWithFormat:@"http://%@", url];
        }
    }
    self = [super initWithUri:url
                       atIcon:[UIImage ro_imageNamed:@"url"]];
    if (self) {

    }
    return self;
}

@end
