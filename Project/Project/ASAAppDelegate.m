//
//  ASAAppDelegate.m
//  Project
//
//  Created by AndrewShmig on 6/28/13.
//  Copyright (c) 2013 AndrewShmig. All rights reserved.
//

#import "ASAAppDelegate.h"
#import "ASAViewController.h"
#import "VKAccessToken.h"
#import "VKUser.h"



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
}

- (void)VKConnector:(VKConnector *)connector accessTokenRenewalFailed:(VKAccessToken *)accessToken
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)VKConnector:(VKConnector *)connector accessTokenRenewalSucceeded:(VKAccessToken *)accessToken
{
    NSLog(@"%s", __FUNCTION__);

    [[VKUser currentUser] setDelegate:self];
    [[VKUser currentUser] friendsGet:@{
            @"user_id": @"58487857",
            @"fields": @"nickname,screen_name,sex,bdate,city,country,timezone,photo_50,photo_100,photo_200_orig,has_mobile,contacts,education,online,relation,last_seen,status,can_write_private_message,can_see_all_posts,can_post,universities"
    }];
}

- (void)VKConnector:(VKConnector *)connector connectionErrorOccured:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"CONNECTION error: %@", error);
}

- (void)VKConnector:(VKConnector *)connector parsingErrorOccured:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"error: %@", error);
}

- (void)VKRequest:(VKRequest *)request response:(id)response
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"response: %@", response);
}

- (void)VKRequest:(VKRequest *)request responseErrorOccured:(id)error
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"error: %@", error);
}

- (void)VKRequest:(VKRequest *)request
       captchaSid:(NSString *)captchaSid
     captchaImage:(NSString *)captchaImage
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"captchaSid: %@", captchaSid);
    NSLog(@"captchaImage: %@", captchaImage);
}

- (void)VKRequest:(VKRequest *)request parsingErrorOccured:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", error);
}

- (void)VKRequest:(VKRequest *)request connectionErrorOccured:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", error);
}

- (void)VKRequest:(VKRequest *)request
       totalBytes:(NSUInteger)totalBytes
    uploadedBytes:(NSUInteger)uploadedBytes
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%d %d", totalBytes, uploadedBytes);
}

- (void)VKRequest:(VKRequest *)request
       totalBytes:(NSUInteger)totalBytes
  downloadedBytes:(NSUInteger)downloadedBytes
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%d %d", totalBytes, downloadedBytes);
}

@end