//
//  RODetailViewController.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 24/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROCustomTableViewController.h"
#import "ROStyle.h"
#import "ROCellDescriptor.h"
#import "SVProgressHUD.h"
#import "ROError.h"
#import "ROBehavior.h"
#import "RORefreshBehavior.h"
#import "ROPage.h"

@interface ROCustomTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ROCustomTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if (self.page.layoutType == ROLayoutCustom) {
            [self.behaviors addObject:[RORefreshBehavior behaviorViewController:self]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    // Add tableView before [super viewDidLoad]
    
    [self.view addSubview:self.tableView];
    
    NSDictionary *viewsBindings = NSDictionaryOfVariableBindings(_tableView);
    
    // align tableView from the left and right
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsBindings]];
    
    // align tableView from the top and bottom
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsBindings]];
    
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    for (NSObject<ROCellDescriptor> *cellDescriptor in self.items) {
        [cellDescriptor receiveMemoryWarning];
    }
}

- (void)dealloc
{
    if (_tableView) {
        if (_tableView.superview) {
            [_tableView removeFromSuperview];
        }
        _tableView = nil;
    }
    if (_customTableViewDelegate) {
        _customTableViewDelegate = nil;
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.tableViewStyle];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.userInteractionEnabled = YES;
        _tableView.tintColor = [[ROStyle sharedInstance] accentColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [[ROStyle sharedInstance] backgroundColor];
        _tableView.backgroundView = nil;
        //_tableView.rowHeight = UITableViewAutomaticDimension;
        //_tableView.estimatedRowHeight = [[[ROStyle sharedInstance] tableViewCellHeightMin] floatValue];
    }
    return _tableView;
}

- (void)loadData
{
    if (self.dataItem) {
        
        [self loadDataSuccess:self.dataItem];
        
    } else if (self.page.ds) {
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        __weak typeof(self) weakSelf = self;
        [self.dataLoader refreshDataSuccessBlock:^(NSObject *dataItem) {
           
            [SVProgressHUD dismiss];
            [weakSelf loadDataSuccess:dataItem];
            
        } failureBlock:^(ROError *error) {
            
            [SVProgressHUD dismiss];
            [weakSelf loadDataError:error];
            
        }];
    }
}

- (void)loadDataSuccess:(NSObject *)dataItem
{
    self.dataItem = dataItem;
    
    [self.customTableViewDelegate configureWithDataItem:self.dataItem];
    
    NSMutableArray *items = [NSMutableArray new];
    NSMutableArray *descriptorClasses = [NSMutableArray new];
    for (NSObject<ROCellDescriptor> *cellDescriptor in self.items) {
        Class descriptorClass = [cellDescriptor class];
        if (![descriptorClasses containsObject:descriptorClass]) {
            [descriptorClasses addObject:descriptorClass];
            [cellDescriptor registerInTableView:self.tableView];
        }
        if (![cellDescriptor isEmpty]) {
            [items addObject:cellDescriptor];
        }
    }
    self.items = [NSArray arrayWithArray:items];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self.tableView reloadData];
    });
    
    for (NSObject<ROBehavior> *behavior in self.behaviors) {
        [behavior onDataSuccess];
    }
}

- (void)loadDataError:(ROError *)error
{
    [error show];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject<ROCellDescriptor> *cellDescriptor = self.items[indexPath.row];
    return [cellDescriptor tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSObject<ROCellDescriptor> *cellDescriptor = self.items[indexPath.row];
    [cellDescriptor tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject<ROCellDescriptor> *cellDescriptor = self.items[indexPath.row];
    return [cellDescriptor tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end
