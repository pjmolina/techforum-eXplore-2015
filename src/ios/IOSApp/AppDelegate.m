//
//  AppDelegate.h
//  EXplore101
//
//  This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "NavigationViewController.h"
#import "ROStyle.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "ROKillSwitchViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];

    [[SDImageCache sharedImageCache] cleanDisk];
    //Add a custom read-only cache path
    NSString *bundledPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CachePathImages"];
    [[SDImageCache sharedImageCache] addReadOnlyCachePath:bundledPath];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // process app style
    [[ROStyle sharedInstance] process];

    // initialize controllers
    NavigationViewController *navigationController = [NavigationViewController sharedInstance];

    // This is the radarc online trial kill switch. Remove these lines to disable it.
    ROKillSwitchViewController *ksController = [[ROKillSwitchViewController alloc]
                                                initWithTimeout:2880]; // minutes
    navigationController.ksViewController = ksController;

    // save view controller for later use (see delegated events in ROAppDelegate)
    self.navigationViewController = navigationController;
    
    // initialize navigation and show view    
    [self.window setRootViewController:[navigationController mainNavigationViewController]];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
