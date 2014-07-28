//
//  ASAAppDelegate.m
//  Project
//
//  Created by AndrewShmig on 6/28/13.
//  Copyright (c) 2013 AndrewShmig. All rights reserved.
//

#import "ASAAppDelegate.h"
#import "ASAViewController.h"


static NSString *const kVKAppID = @"4249589";
static NSString *const kVKPermissionsArray = @"photos,friends,wall,audio,video,docs,notes,pages,status,groups,messages";


@implementation ASAAppDelegate
{
  VKRequestManager *_rm;
}

- (BOOL)          application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc]
                 initWithFrame:[[UIScreen mainScreen] bounds]];
  
  self.webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen]
                                                   bounds]];
  self.webView.hidden = NO;
  
  [[VKConnector sharedInstance] startWithAppID:kVKAppID
                                    permissons:[kVKPermissionsArray componentsSeparatedByString:@","]
                                       webView:self.webView
                                      delegate:self];
  
  // Override point for customization after application launch.
  self.viewController = [[ASAViewController alloc]
                         initWithNibName:@"ASAViewController"
                         bundle:nil];
  [self.viewController.view addSubview:self.webView];
  self.window.rootViewController = self.viewController;
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)        connector:(VKConnector *)connector
accessTokenRenewalSucceeded:(VKAccessToken *)accessToken
{
  NSLog(@"%s", __FUNCTION__);
  
  NSLog(@"Access token: %@", accessToken);
  
  _rm = [[VKRequestManager alloc] initWithDelegate:self];
  [_rm info:@{@"user_ids": @"christian.burns"}];
  
}

- (void)request:(VKRequest *)request responseError:(NSError *)error
{
  [[VKConnector sharedInstance] startWithAppID:kVKAppID
                                    permissons:[kVKPermissionsArray componentsSeparatedByString:@","]
                                       webView:self.webView
                                      delegate:self];
}

- (void)request:(VKRequest *)request
         response:(id)response
{
  NSLog(@"%s", __FUNCTION__);
  NSLog(@"request: %@", request);
  NSLog(@"response: %@", response);
}

@end
