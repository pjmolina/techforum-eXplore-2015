//
//  ROAppDelegate.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 6/5/14.
//

#import "ROAppDelegate.h"
#import "NSUserDefaults+AESEncryptor.h"
#import "RONavigationViewController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "ROStyle.h"

@implementation ROAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // initialize AES Storage for user data
    [[NSUserDefaults standardUserDefaults]
        setAESKey:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
    
    // Network indicator
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // save last active state
    [self saveLastSuspendDate];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if(self.navigationViewController.ksViewController){
        if(![self.navigationViewController.ksViewController checkTrialStatus]){
            // Trial expired
            id mainController = [self.navigationViewController mainNavigationViewController];
            [mainController dismissViewControllerAnimated:YES completion:nil];
            
            [self.navigationViewController.ksViewController showExpiredTrialMessage];
            return;
        }
    }
    
    // check login status and redirect if needed
    if(self.navigationViewController.loginViewController){
        [self checkLoginStateAndRedirect];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self resetLoginState];
}

/// Login methods

- (void)saveLastSuspendDate
{
    NSDate *currentDate = [NSDate date];
    
    [[NSUserDefaults standardUserDefaults]
     encryptValue:[[NSNumber numberWithDouble:[currentDate timeIntervalSince1970]] stringValue]
     withKey:@"SuspendDate"];
}

- (void)checkLoginStateAndRedirect
{
    // check if the user is logged in
    NSString *lastSuspendStr = [[NSUserDefaults standardUserDefaults] decryptedValueForKey:@"SuspendDate"];
    // minutes
    NSString *expirationTimeStr = [[NSUserDefaults standardUserDefaults] decryptedValueForKey:@"ExpirationTime"];
    
    if(expirationTimeStr){
        // there was a succesful login previously, check that the user session has not expired
        if(!lastSuspendStr){
            // this should not happen, as applicationWillResignActive has been executed previously
        }
        else{
            double lastSuspendDate = [lastSuspendStr doubleValue];
            double expTimeInSeconds = [expirationTimeStr doubleValue] * 60;
            double now = [[NSDate date] timeIntervalSince1970];
            if (expTimeInSeconds != 0 && (lastSuspendDate + expTimeInSeconds < now)){
                // we need to reset navigation
                [self.navigationViewController.loginViewController reset];
                id mainController = [self.navigationViewController mainNavigationViewController];
                [mainController dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
}

- (void)resetLoginState
{
    [[NSUserDefaults standardUserDefaults]
     encryptValue:@"0"
     withKey:@"ExpirationTime"];
}

@end
