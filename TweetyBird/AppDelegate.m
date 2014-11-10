//
//  AppDelegate.m
//  TweetyBird
//
//  Created by Larry Wei on 10/29/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "HomeViewController.h"
#import "HamburgerViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void) beginSession {
    HamburgerViewController *vc = [[HamburgerViewController alloc] init];
    //UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    NSLog(@"Should launch new view controller");
    self.window.rootViewController = vc;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogOut) name:USER_DID_LOGOUT_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogIn) name:USER_DID_LOGIN_NOTIFICATION object:nil];

        
    User *user = [User currentUser];
    if (user != nil) {
        NSLog(@"Welcome back, %@", user.name);
        [self beginSession];
    }
    else {
        NSLog(@"Hello New User. Please log in!");
        LoginViewController *vc = [[LoginViewController alloc] init];
        self.window.rootViewController = vc;
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//application handling
-(BOOL) application: (UIApplication*) application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"URL: %@", url);
    [[TwitterClient sharedInstance] openURL:url];
    return YES;
}

-(void)userDidLogOut{
    //NSLog(@"*****LOGOUT HAPPENED********");
    self.window.rootViewController = [[LoginViewController alloc] init];
}
-(void)userDidLogIn{
    NSLog(@"*****LOGIN HAPPENED********");
    //self.window.rootViewController = [[HamburgerViewController alloc] init];
}
@end
