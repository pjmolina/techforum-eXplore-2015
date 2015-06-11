//
//  ROFormFieldRange.h
//  RadarcOnlineSDK
//
//  Created by Víctor Jordán Rosado on 16/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROFormField.h"

@class ROFormViewController;

@interface ROFormFieldDateRange : NSObject <ROFormField>

@property (nonatomic, strong) NSString *fieldLabel;
@property (nonatomic, strong) NSString *fieldName;
@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic,strong) NSString *minLabel;
@property (nonatomic,strong) NSDate *minDate;
@property (nonatomic,strong) NSString *maxLabel;
@property (nonatomic,strong) NSDate *maxDate;

@property (nonatomic, strong) ROFormViewController *formController;

- (instancetype)initWithFieldLabel:(NSString *)fieldLabel
                         fieldName:(NSString *)fieldName
                    formController:(ROFormViewController *)formController;

+ (instancetype)fieldLabel:(NSString *)fieldLabel
                 fieldName:(NSString *)fieldName
            formController:(ROFormViewController *)formController;

@end
