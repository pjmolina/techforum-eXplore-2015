//
//  ROMapAction.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 11/05/14.
//

#import "ROMapAction.h"
#import "UIImage+RO.h"

@implementation ROMapAction

- (id)initWithValue:(NSString *)mapUri
{
    NSMutableString *uri = [[NSMutableString alloc] initWithString:@"http://maps.apple.com/?"];
    if (mapUri) {
        [uri appendString:[mapUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    self = [super initWithUri:uri
                       atIcon:[UIImage ro_imageNamed:@"location"]];
    if (self) {
        _mapUri = mapUri;
    }
    return self;
}

@end
