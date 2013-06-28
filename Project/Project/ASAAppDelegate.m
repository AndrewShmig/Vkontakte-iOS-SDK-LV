//
//  ASAAppDelegate.m
//  Project
//
//  Created by AndrewShmig on 6/28/13.
//  Copyright (c) 2013 AndrewShmig. All rights reserved.
//

#import "ASAAppDelegate.h"

#import "ASAViewController.h"

@implementation ASAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ASAViewController alloc] initWithNibName:@"ASAViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end