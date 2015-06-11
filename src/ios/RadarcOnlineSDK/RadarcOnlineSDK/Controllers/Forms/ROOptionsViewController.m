//
//  ROOptionsViewController.m
//  ReferenceApp
//
//  Created by Icinetic S.L. on 10/2/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROOptionsViewController.h"
#import "NSBundle+RO.h"
#import "ROPage.h"
#import "ROFormFieldSelection.h"
#import "SVProgressHUD.h"
#import "ROStyle.h"
#import "NSString+RO.h"

static NSString *const kCellDefault         = @"cellDefault";

@interface ROOptionsViewController ()

@property (nonatomic, strong) NSArray *allOptions;

@property (nonatomic, strong) NSMutableArray *optionsSelected;

- (void)doSelection;

@end

@implementation ROOptionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;   // iOS 7 specific
    }
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [[[ROStyle sharedInstance] accentColor] colorWithAlphaComponent:0.5f];
    self.tableView.tintColor = [[ROStyle sharedInstance] accentColor];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.searchBar.barTintColor = [[ROStyle sharedInstance] applicationBarBackgroundColor];
    
    if (!self.formFieldSelection.single) {
        
        UIBarButtonItem *selectionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                       target:self
                                                                                       action:@selector(doSelection)];
        self.navigationItem.rightBarButtonItem = selectionItem;
        
    }
    
    [self.formFieldSelection.datasource getDistinctValues:self.formFieldSelection.fieldName onSuccess:^(NSArray *objects) {
        
        self.allOptions = objects;
        self.formFieldSelection.options = objects;

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            
        });
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response) {
        
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Load data error", nil)];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.optionsSelected = self.formFieldSelection.optionsSelected ? [self.formFieldSelection.optionsSelected mutableCopy] : [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doSelection
{
    if ([self.optionsSelected count] != 0) {
        self.formFieldSelection.optionsSelected = [self.optionsSelected mutableCopy];
    } else {
        self.formFieldSelection.optionsSelected = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setFormFieldSelection:(ROFormFieldSelection *)formFieldSelection
{
    _formFieldSelection = formFieldSelection;
    ROPage *page = [ROPage new];
    page.label = formFieldSelection.fieldLabel;
    self.page = page;
}

#pragma mark - Search bar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (!searchBar.showsCancelButton) {
        [searchBar setShowsCancelButton:YES animated:YES];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (searchBar.showsCancelButton) {
        [searchBar setShowsCancelButton:NO animated:YES];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text && [[searchBar.text ro_trim] length] != 0) {
        [self searchBy:searchBar.text];
    } else {
        [self searchBy:nil];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    [self searchBy:nil];
}

- (void)searchBy:(NSString *)searchText
{
    [self.view endEditing:YES];
    if (!searchText) {
        self.formFieldSelection.options = self.allOptions;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains[cd] %@", searchText];
        self.formFieldSelection.options = [self.allOptions filteredArrayUsingPredicate:predicate];
    }
    [self.tableView reloadData];    
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.formFieldSelection.options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellDefault];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellDefault];
        UIView *selectecedView = [[UIView alloc] init];
        selectecedView.backgroundColor = [[[ROStyle sharedInstance] accentColor] colorWithAlphaComponent:0.1f];
        cell.selectedBackgroundView = selectecedView;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [[ROStyle sharedInstance] font];
        cell.textLabel.textColor = [[ROStyle sharedInstance] foregroundColor];
    }
    NSString *option = self.formFieldSelection.options[(NSUInteger)indexPath.row];
    cell.textLabel.text = [option description];
    if ([self.optionsSelected containsObject:[option description]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *option = self.formFieldSelection.options[(NSUInteger)indexPath.row];
    
    if (self.formFieldSelection.single) {
        
        BOOL add = YES;
        if ([self.optionsSelected containsObject:[option description]]) {
            add = NO;
        }
        [self.optionsSelected removeAllObjects];
        if (add) {
            [self.optionsSelected addObject:option];
        }
        
        [self doSelection];
        
    } else {
        
        if ([self.optionsSelected containsObject:option]) {
            [self.optionsSelected removeObject:option];
        } else {
            [self.optionsSelected addObject:option];
        }
        
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
    }
}

@end
