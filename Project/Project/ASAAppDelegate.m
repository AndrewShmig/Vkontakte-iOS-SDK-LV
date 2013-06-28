//
//  ASAAppDelegate.m
//  Project
//
//  Created by AndrewShmig on 6/28/13.
//  Copyright (c) 2013 AndrewShmig. All rights reserved.
//

#import "ASAAppDelegate.h"
#import "ASAViewController.h"


static NSString *const kVKAppID = @"3541027";
static NSString *const kVKPermissionsArray = @"photos,friends,wall,audio,video,docs,notes,pages,status,groups,messages";

@implementation ASAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [[VKConnector sharedInstance] setDelegate:self];
    [[VKConnector sharedInstance] startWithAppID:kVKAppID
                                      permissons:[kVKPermissionsArray componentsSeparatedByString:@","]];

    // Override point for customization after application launch.
    self.viewController = [[ASAViewController alloc] initWithNibName:@"ASAViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)VKConnector:(VKConnector *)connector willShowModalView:(KGModal *)view
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)VKConnector:(VKConnector *)connector willHideModalView:(KGModal *)view
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)VKConnector:(VKConnector *)connector accessTokenInvalidated:(VKAccessToken *)accessToken
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", accessToken);
}

- (void)VKConnector:(VKConnector *)connector accessTokenRenewalFailed:(VKAccessToken *)accessToken
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"accessToken: %@", accessToken);
}

- (void)VKConnector:(VKConnector *)connector accessTokenRenewalSucceeded:(VKAccessToken *)accessToken
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"accessToken: %@", accessToken);
}

- (void)VKConnector:(VKConnector *)connector connectionErrorOccured:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"error: %@", error);
}

- (void)VKConnector:(VKConnector *)connector parsingErrorOccured:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"error: %@", error);
}

@end