//
//  ROFormViewController.m
//  ReferenceApp
//
//  Created by Icinetic S.L. on 7/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROFormViewController.h"
#import "NSBundle+RO.h"
#import "ROFormField.h"
#import "NSBundle+RO.h"
#import "ROStyle.h"
#import "ROOptionsViewController.h"
#import "ActionSheetDatePicker.h"
#import "UIImage+RO.h"

@interface ROFormViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableDictionary *fieldValues;

@end

@implementation ROFormViewController


- (void)viewDidLayoutSubviews {
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        UIEdgeInsets currentInsets = self.tableView.contentInset;
        self.tableView.contentInset = (UIEdgeInsets){
            .top = self.topLayoutGuide.length,
            .bottom = currentInsets.bottom,
            .left = currentInsets.left,
            .right = currentInsets.right
        };
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Apply styles
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tintColor = [[ROStyle sharedInstance] accentColor];    
    self.tableView.separatorColor = [[[ROStyle sharedInstance] accentColor] colorWithAlphaComponent:0.5f];
    
    self.submitButton.tintColor = [[ROStyle sharedInstance] applicationBarTextColor];
    self.submitButton.backgroundColor = [[ROStyle sharedInstance] applicationBarBackgroundColor];
    [self.submitButton setTitleColor:[[[ROStyle sharedInstance] accentColor] colorWithAlphaComponent:0.1f] forState:UIControlStateHighlighted];
    
    // Configure navigation bar
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                               target:self
                                                                               action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = closeItem;
    
    UIBarButtonItem *resetItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reset", nil) style:UIBarButtonItemStylePlain target:self action:@selector(reset)];
    
    self.navigationItem.rightBarButtonItem = resetItem;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (NSMutableArray *)filters
{
    if (!_filters) {
        _filters = [NSMutableArray new];
    }
    return _filters;
}

- (void)setFields:(NSArray *)fields
{
    _fields = fields;
    
    // Save init values
    self.fieldValues = [NSMutableDictionary new];
    for (id<ROFormField>formField in self.fields) {
        
        // Save values
        NSString *value = [formField fieldValue];
        if (value) {
            [self.fieldValues setObject:value forKey:[formField fieldName]];
        }
        
    }
}

+ (instancetype)form
{
    return [[self alloc] initWithNibName:@"ROFormViewController" bundle:[NSBundle ro_resourcesBundle]];
}

- (IBAction)submitButtonAction:(id)sender {
    [self submit];
}

- (void)cancel
{
    for (id<ROFormField> formField in self.fields) {
        NSString *value = self.fieldValues[[formField fieldName]];
        [formField setFieldValue:value];
    }
    [self close];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submit
{
    [self.filters removeAllObjects];

    [self.fieldValues removeAllObjects];
    
    for (id<ROFormField> formField in self.fields) {

        // Create filters
        id <ROFilter> filter = [formField filter];
        if (filter) {
            [self.filters addObject:filter];
        }

        // Save values
        NSString *value = [formField fieldValue];
        if (value) {
            [self.fieldValues setObject:value forKey:[formField fieldName]];
        }
        
    }
    [self close];
    if (_formDelegate && [_formDelegate conformsToProtocol:@protocol(ROFormDelegate)]) {

        [_formDelegate formSubmitted];
        
    }
}

- (void)reset
{
    for (id<ROFormField> formField in self.fields) {
        [formField setFieldValue:nil];
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fields count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<ROFormField> formField = self.fields[section];
    return [formField numberOfRows];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.fields[section] fieldLabel];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<ROFormField> formField = self.fields[indexPath.section];
    return [formField tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id<ROFormField> formField = self.fields[(NSUInteger)indexPath.section];
    [formField tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
