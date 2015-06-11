//
//  ROFormFieldSelectionMultiple.h
//  RadarcOnlineSDK
//
//  Created by Víctor Jordán Rosado on 16/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROFormField.h"
#import "RODatasource.h"

@class ROFormViewController;

@interface ROFormFieldSelection : NSObject <ROFormField>

@property (nonatomic, strong) NSString *fieldLabel;

@property (nonatomic, strong) NSString *fieldName;

@property (nonatomic, strong) NSString *placeholder;


@property (nonatomic, strong) id<RODatasource> datasource;

@property (nonatomic, strong) NSArray *options;

@property (nonatomic, strong) NSMutableArray *optionsSelected;

@property (nonatomic, assign) BOOL single;

@property (nonatomic, strong) ROFormViewController *formController;

- (instancetype)initWithFieldLabel:(NSString *)fieldLabel
                         fieldName:(NSString *)fieldName
                        datasource:(id<RODatasource>)datasource
                    formController:(ROFormViewController *)formController
                            single:(BOOL)single;

+ (instancetype)fieldLabel:(NSString *)fieldLabel
                 fieldName:(NSString *)fieldName
                datasource:(id<RODatasource>)datasource
            formController:(ROFormViewController *)formController
                            single:(BOOL)single;

@end
