//
//  ROViewController.m
//  AppWorks
//
//  Created by Icinetic S.L. on 4/24/14.
//

#import "ROViewController.h"
#import "ROPage.h"
#import "UIView+RO.h"
#import "ROStyle.h"
#import "ROBehavior.h"

@interface ROViewController ()

@end

@implementation ROViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    for (NSObject<ROBehavior> *behavior in self.behaviors) {
        [behavior load];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Configure status bar
    UIColor *constrainsColor = [[ROStyle sharedInstance] backgroundColor];
    if (self.navigationController) {
        constrainsColor = [[ROStyle sharedInstance] applicationBarBackgroundColor];
        // Show title
        if (self.page && self.page.label) {
            self.navigationItem.title = self.page.label;
        }
    }
    if ([[ROStyle sharedInstance] useStyleLightForColor:constrainsColor]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController) {
        // Remove back button text
        self.navigationItem.title = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ROViewController

+ (ROPage *)entryPage
{
#ifdef DEBUG
    NSLog(@"%s must be override", __PRETTY_FUNCTION__);
#endif
    return [[ROPage alloc] initWithLabel:NSStringFromClass([self class])
                            atLayoutType:ROLayoutMenuTitle
                             atImageName:nil
                       atControllerClass:[self class]
                            atDatasource:nil];
}

- (id)initWithPage:(ROPage *)page
{
    self = [super init];
    if (self) {
        _page = page;
    }
    return self;
}

- (ROPage *)page
{
    if (!_page) {
        _page = [[self class] entryPage];
    }
    return _page;
}

- (NSMutableArray *)behaviors
{
    if (!_behaviors) {
        _behaviors = [NSMutableArray new];
    }
    return _behaviors;
}

/**
 Default implementation that colors the background with the bg color and image
 */
- (void)configureView
{
    // Do any additional setup after loading the view.
    [self.view ro_setBackgroundColor:[[ROStyle sharedInstance] backgroundColor]];
    UIImage *backgroundImage = [[ROStyle sharedInstance] backgroundImage];
    if (_page) {
        if (_page.label) {
            [self setTitle:_page.label];
        }
        if (_page.imageName) {
            backgroundImage = [UIImage imageNamed:_page.imageName];
        }
    }
    if (backgroundImage) {
        //self.automaticallyAdjustsScrollViewInsets = NO;
        [self.view ro_setBackgroundImage:backgroundImage];
    }
}

@end
