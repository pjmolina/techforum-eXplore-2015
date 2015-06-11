//
//  RONavigationViewController.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/24/14.
//

#import "RONavigationViewController.h"
#import "ROPage.h"
#import "ECSlidingViewController.h"
#import "RONavigationBasicController.h"
#import "RONavigationMenuSlidingController.h"
#import "RONavigationMainSlidingController.h"
#import "ROStyle.h"
#import "NSUserDefaults+AESEncryptor.h"

@interface RONavigationViewController ()

- (id)retrieveMainNavigationViewController;

@end

@implementation RONavigationViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithPage:(ROPage *)page
{
    self = [super initWithPage:page];
    if (self) {
        self.navigationType = [[ROStyle sharedInstance] navigationTypeDefault];
    }
    return self;
}

#pragma mark - RONavigationViewController

+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)mainNavigationViewController {
    id theController;
    if(_loginViewController){
        // add logout option
        self.pages = [self.pages arrayByAddingObject:[[ROPage alloc] initWithLabel:@"Logout" atLayoutType:0 atControllerClass:nil atDatasource:nil]];
        
        __weak id lvc = _loginViewController;
        __weak id navigationViewController = self;
        [_loginViewController setOnSuccessBlock:^{
            // reset navigation
            // redirect to main
            [lvc presentViewController:[navigationViewController retrieveMainNavigationViewController] animated:YES completion:nil];
        } onFailureBlock:^{
            // do nothing
        }];
        
        theController = _loginViewController;
    }
    else{
        theController = [self retrieveMainNavigationViewController];
    }
    
    if(_ksViewController){
        __weak id controller = theController;
        __weak id weakKs = _ksViewController;
        [_ksViewController setOnSuccessBlock:^{
            [weakKs presentViewController:controller animated:YES completion:nil];
        }];
        theController = _ksViewController;
    }
    
    return theController;
}

- (ECSlidingViewController *)retrieveNavigationSlidingWithActionCallback:(ROActionCallback) callback
{
    ROPage *page = [_pages objectAtIndex:0];
    RONavigationMenuSlidingController *navMenuController =
    [[RONavigationMenuSlidingController alloc] initWithPages:_pages
                                                      atPage:self.page
                                                    callback:callback];
    
    RONavigationMainSlidingController *navMainController = [[RONavigationMainSlidingController alloc] initWithRootViewController:[page viewController]];
    
    _navigationController = navMainController;
    
    ECSlidingViewController *navSlidingViewController = [ECSlidingViewController slidingWithTopViewController:navMainController];
    navMenuController.edgesForExtendedLayout = UIRectEdgeTop | UIRectEdgeBottom | UIRectEdgeLeft;
    navSlidingViewController.underLeftViewController = navMenuController;
    [navSlidingViewController.topViewController.view addGestureRecognizer:navSlidingViewController.panGesture];
    navSlidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    return navSlidingViewController;
}

- (RONavigationBasicController *)retrieveNavigationBasicWithActionCallback:(ROActionCallback)callback
{
    RONavigationBasicController *navBasic = [[RONavigationBasicController alloc] initWithPages:_pages
                                                                                        atPage:self.page
                                                                                      callback:callback];
    _navigationController = navBasic;
    return navBasic;
}

- (id)retrieveNavigationCustomWithActionCallback:(ROActionCallback)callback
{
    return [[ROViewController alloc] init];
}

- (id)retrieveMainNavigationViewController
{
    ROActionCallback logoutCallback = ^(NSInteger index){
        [_loginViewController reset];
        [_mainNavigationViewController dismissViewControllerAnimated:true completion:^{
            
        }];
    };
    switch (_navigationType) {
        case RONavigationTypeSliding: {
            _mainNavigationViewController = [self retrieveNavigationSlidingWithActionCallback:logoutCallback];
            break;
        }
        case RONavigationTypeBasic: {
            _mainNavigationViewController = [self retrieveNavigationBasicWithActionCallback:logoutCallback];
            break;
        }
        case RONavigationTypeCustom: {
            _mainNavigationViewController = [self retrieveNavigationCustomWithActionCallback:logoutCallback];
            break;
        }
        default: {
            break;
        }
    }
    return _mainNavigationViewController;
}

@end
