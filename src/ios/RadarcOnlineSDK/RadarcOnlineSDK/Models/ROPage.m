//
//  ROPage.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/24/14.
//

#import "ROPage.h"
#import "ROViewController.h"

@implementation ROPage

- (id)initWithLabel:(NSString *)label
       atLayoutType:(ROLayoutType)layoutType
        atImageName:(NSString *)imageName
  atControllerClass:(Class)controllerClass
       atDatasource:(id<RODatasource>)datasource
{
    self = [super init];
    if (self) {
        _label = label;
        _layoutType = layoutType;
        _imageName = imageName;
        _controllerClass = controllerClass;
        _ds = datasource;
    }
    return self;
}

- (id)initWithLabel:(NSString *)label
       atLayoutType:(ROLayoutType)layoutType
  atControllerClass:(Class)controllerClass
       atDatasource:(id<RODatasource>)datasource
{
    self = [self initWithLabel:label
                  atLayoutType:layoutType
                   atImageName:nil
             atControllerClass:controllerClass
                  atDatasource:datasource];
    if (self) {
        
    }
    return self;
}

- (id)viewController {
    if (!_controllerClass) {
        return nil;
    } else {
        id obj = [[_controllerClass alloc] init];
        [obj setPage:self];
        return obj;
    }
}

@end
