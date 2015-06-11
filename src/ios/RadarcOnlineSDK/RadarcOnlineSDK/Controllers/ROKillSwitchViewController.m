//
//  ROKillSwitchControllerViewController.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 10/2/14.
//
//

#import "ROKillSwitchViewController.h"
#import "NSUserDefaults+AESEncryptor.h"
#import "NSBundle+RO.h"
#import "UIImage+RO.h"

@interface ROKillSwitchViewController ()

@end

@implementation ROKillSwitchViewController

int mTimeout;
KSSuccessBlock mSuccessBlock;

-(id)initWithTimeout:(int)timeout
{
    mTimeout = timeout;
    
    self = [self initWithNibName:@"ROKillSwitchViewController" bundle:[NSBundle ro_resourcesBundle]];
    
    return self;

}

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
    // Do any additional setup after loading the view from its nib.
    // initialize message
    [self.message setText:[NSString stringWithFormat:
                           NSLocalizedString(@"This app is only for testing and can not be distributed. After %d hours it will stop working.", nil),
                           (mTimeout / 60)]];
    
    UIImage *image = [UIImage ro_imageNamed:@"radarconline"];
    
    [self.logoimage setImage:image];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // check expiration status
    if([self checkTrialStatus]){
        // we are in trial period, continue after a few seconds
        [self performSelector:@selector(continueTrial) withObject:self afterDelay:5];
    }
    else{
        // Show expired message
        [self showExpiredTrialMessage];
    }
}

-(BOOL)checkTrialStatus {
    NSString *firstActivation = [[NSUserDefaults standardUserDefaults] decryptedValueForKey:@"FirstActivation"];
    
    double now = [[NSDate date] timeIntervalSince1970];
    
    if(!firstActivation){
        firstActivation = [[NSNumber numberWithDouble:now] stringValue];
        [[NSUserDefaults standardUserDefaults] encryptValue:firstActivation withKey:@"FirstActivation"];
    }
    
    double lastActivation = [firstActivation doubleValue];
    double timeoutInSeconds = mTimeout * 60;
    
    return (lastActivation + timeoutInSeconds > now) ? YES : NO;
}

- (void)continueTrial {
    if(mSuccessBlock) {
        mSuccessBlock();
    }
}

- (void)showExpiredTrialMessage {
#ifdef DEBUG
    NSLog(@"Trial expired after %d minutes", mTimeout);
#endif
    [self.message setText:@"The trial period of this app has expired. If you want to continue testing, generate your app again."];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setOnSuccessBlock:(KSSuccessBlock)success
{
    mSuccessBlock = success;
}

@end
