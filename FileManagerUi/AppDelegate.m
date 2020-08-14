//
//  AppDelegate.m
//  FileManagerUi
//
//  Created by mt010 on 2020/7/1.
//  Copyright © 2020 FileManager. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    ViewController *vc = [ViewController new];
    UINavigationController *SystemNav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window setRootViewController:SystemNav];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
