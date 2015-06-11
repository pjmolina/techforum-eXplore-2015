//
//  ROChartViewController.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 23/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROChartViewController.h"
#import "ROStyle.h"
#import "SVProgressHUD.h"
#import "ROError.h"
#import "ROBehavior.h"
#import "RORefreshBehavior.h"
#import "ROPage.h"

@interface ROChartViewController ()

@end

@implementation ROChartViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.behaviors addObject:[RORefreshBehavior behaviorViewController:self]];
    }
    return self;
}

- (void)viewDidLoad
{
    // Add chartView before [super viewDidLoad]
    
    [self.view addSubview:self.chartView];
    
    NSDictionary *viewsBindings = NSDictionaryOfVariableBindings(_chartView);
    
    // align tableView from the left and right
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_chartView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsBindings]];
    
    // align tableView from the top and bottom
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_chartView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsBindings]];
    
    
    [super viewDidLoad];

    switch (self.page.layoutType) {
        case ROLayoutChartBars:
            self.chartType = ROChartTypeBar;
            break;
        case ROLayoutChartPie:
            self.chartType = ROChartTypePie;
            break;
        case ROLayoutChartLines:
        default:
            self.chartType = ROChartTypeLine;
            break;
    }
    
    self.chartView.chartType = self.chartType;
    
}

- (void)dealloc
{
    if (_chartView) {
        if (_chartView.superview) {
            [_chartView removeFromSuperview];
        }
        _chartView = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ROChartView *)chartView
{
    if (!_chartView) {
        _chartView = [[ROChartView alloc] initWithFrame:CGRectZero];
        _chartView.translatesAutoresizingMaskIntoConstraints = NO;
        _chartView.foregroundColor = [[ROStyle sharedInstance] foregroundColor];
        _chartView.backgroundColor = [[ROStyle sharedInstance] backgroundColor];
        _chartView.fontName = [[ROStyle sharedInstance] fontName];
        _chartView.fontSize = [[[ROStyle sharedInstance] fontSize] floatValue];
    }
    return _chartView;
}

#pragma mark - Load data

- (void)loadData
{
    if (self.page.ds) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        __weak typeof(self) weakSelf = self;
        [self.dataLoader refreshDataSuccessBlock:^(NSArray *items) {
            
            [SVProgressHUD dismiss];
            [weakSelf loadDataSuccess:items];
            
        } failureBlock:^(ROError *error) {
            
            [SVProgressHUD dismiss];
            [weakSelf loadDataError:error];
            
        }];
    }
}

- (void)loadDataSuccess:(NSArray *)items
{
    self.items = items;
    
    if (self.xAxis) {
        if (self.xAxis.values) {
            [self.xAxis.values removeAllObjects];
        }
        self.chartView.xAxis = self.xAxis;
    }
    
    if (self.serie1 && self.serie1.values) {
        [self.serie1.values removeAllObjects];
    }
    if (self.serie2 && self.serie2.values) {
        [self.serie2.values removeAllObjects];
    }
    if (self.serie3 && self.serie2.values) {
        [self.serie3.values removeAllObjects];
    }
    if (self.serie4 && self.serie4.values) {
        [self.serie4.values removeAllObjects];
    }
    
    if ([self.items count] != 0) {
        for (NSInteger i=0; i != [self.items count]; i++) {
            [self.chartViewDelegate configureSeriesAtIndex:i];
        }
    }
    
    NSMutableArray *series = [NSMutableArray new];
    if (self.serie1) {
        [series addObject:self.serie1];
    }
    if (self.serie2) {
        [series addObject:self.serie2];
    }
    if (self.serie3) {
        [series addObject:self.serie3];
    }
    if (self.serie4) {
        [series addObject:self.serie4];
    }
    self.chartView.series = series;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.chartView setNeedsDisplay];
        
    });
    
    for (NSObject<ROBehavior> *behavior in self.behaviors) {
        [behavior onDataSuccess];
    }
}

- (void)loadDataError:(ROError *)error
{
    [error show];
}

@end
