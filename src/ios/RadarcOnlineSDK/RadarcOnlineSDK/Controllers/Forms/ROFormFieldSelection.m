//
//  ROFormFieldSelectionMultiple.m
//  RadarcOnlineSDK
//
//  Created by Víctor Jordán Rosado on 16/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROFormFieldSelection.h"
#import "ROStringListFilter.h"
#import "ROStyle.h"
#import "ROOptionsViewController.h"
#import "NSBundle+RO.h"
#import "ROFormViewController.h"

static NSString *const kCellIdentifier  = @"fieldSelectionMultipleCell";

static NSString *const kSeparatorValue  = @", ";

@implementation ROFormFieldSelection

- (instancetype)initWithFieldLabel:(NSString *)fieldLabel
                         fieldName:(NSString *)fieldName
                        datasource:(id<RODatasource>)datasource
                    formController:(ROFormViewController *)formController
                            single:(BOOL)single
{
    self = [super init];
    if (self) {
        _fieldLabel = fieldLabel;
        _fieldName = fieldName;
        _datasource = datasource;
        _formController = formController;
        _single = single;
    }
    return self;
}

+ (instancetype)fieldLabel:(NSString *)fieldLabel
                 fieldName:(NSString *)fieldName
                datasource:(id<RODatasource>)datasource
            formController:(ROFormViewController *)formController
                    single:(BOOL)single
{
    return [[self alloc] initWithFieldLabel:fieldLabel
                                  fieldName:fieldName
                                 datasource:datasource
                             formController:formController
                                     single:single];
}

- (NSString *)placeholder
{
    if (!_placeholder) {
        _placeholder = NSLocalizedString(@"Select option", nil);
    }
    return _placeholder;
}

- (NSString *)fieldValue
{
    if (self.optionsSelected && [self.optionsSelected count] != 0) {
        return [self.optionsSelected componentsJoinedByString:kSeparatorValue];
    }
    return nil;
}

- (void)setFieldValue:(NSString *)fieldValue
{
    if (fieldValue) {
        self.optionsSelected = [[fieldValue componentsSeparatedByString:kSeparatorValue] mutableCopy];
    } else {
        [self.optionsSelected removeAllObjects];
        self.optionsSelected = nil;
    }
}

- (id<ROFilter>)filter
{
    if (self.optionsSelected && [self.optionsSelected count] != 0) {
        return [ROStringListFilter create:self.fieldName values:self.optionsSelected];
    }
    return nil;
}

#pragma mark - UI

- (NSInteger)numberOfRows
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        UIView *selectecedView = [[UIView alloc] init];
        selectecedView.backgroundColor = [[[ROStyle sharedInstance] accentColor] colorWithAlphaComponent:0.1f];
        cell.selectedBackgroundView = selectecedView;
        cell.backgroundColor = [[[ROStyle sharedInstance] backgroundColor] colorWithAlphaComponent:0.5f];
        cell.textLabel.font = [[ROStyle sharedInstance] font];
        cell.textLabel.textColor = [[ROStyle sharedInstance] foregroundColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.optionsSelected ? [self.optionsSelected componentsJoinedByString:kSeparatorValue] : self.placeholder;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ROOptionsViewController *optionsViewController = [[ROOptionsViewController alloc] initWithNibName:@"ROOptionsViewController" bundle:[NSBundle ro_resourcesBundle]];
    optionsViewController.formFieldSelection = self;
    [self.formController.navigationController pushViewController:optionsViewController animated:YES];
}

@end
