//
//  ASAAppDelegate.m
//  Project
//
//  Created by AndrewShmig on 6/28/13.
//  Copyright (c) 2013 AndrewShmig. All rights reserved.
//

#import "ASAAppDelegate.h"
#import "ASAViewController.h"


//static NSString *const kVKAppID = @"3974432";
static NSString *const kVKAppID = @"3541027";
static NSString *const kVKPermissionsArray = @"photos,friends,wall,audio,video,docs,notes,pages,status,groups,messages";


@implementation ASAAppDelegate

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

- (void)VKConnector:(VKConnector *)connector
    willHideWebView:(UIWebView *)webView
{
    NSLog(@"%s", __FUNCTION__);
    self.webView.hidden = YES;
}

- (void)VKConnector:(VKConnector *)connector
    willShowWebView:(UIWebView *)webView
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)     VKConnector:(VKConnector *)connector
accessTokenRenewalFailed:(VKAccessToken *)accessToken
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)        VKConnector:(VKConnector *)connector
accessTokenRenewalSucceeded:(VKAccessToken *)accessToken
{
    NSLog(@"%s", __FUNCTION__);

    NSLog(@"Access token: %@", accessToken);

    VKRequestManager *rm = [[VKRequestManager alloc]
                                              initWithDelegate:self
                                                          user:[VKUser currentUser]];

    [rm wallPost:@{
            @"message": @"111: ппц, сижу ржу дома, не могу успокоиться))\n222: чего там?\n111: короче стою сегодня курю около метро, после универа.ко мне подходит поцан и спрашивает спички. а я как раз утром из дома коробок прихватил. ну я ни слова не говорю, вытаскиваю из кармана, протягиваю.\n222: ))\n111: он так смотрит, грит, зажигалкой то удобнее\n111: я опять же молча лезу в тот же карман и достаю крикет\n111: он прикуривает, отдает зажигалку, смотрит на меня секунд десять и говорит типо в шутку какой карман удивительный, все что не попросишь, все есть, небось и конфеты есть\n222: тааак, я начинаю догадываться)\n111: ))))не поверишь, уже неделю ношу с собой несколько бон пари.\n111: я молча достаю из того же кармана леденец, он ошарашенно берет его, его глаза полны ужаса\n222: ппц, бедняга))\n111: после этого я говорю ему ты потратил все три своих желания, выкидываю сигарету, разворачиваюсь и ухожу"
    }];

}

- (void)   VKConnector:(VKConnector *)connector
connectionErrorOccured:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"CONNECTION error: %@", error);
}

- (void)VKRequest:(VKRequest *)request
         response:(id)response
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"response: %@", response);
}

- (void)   VKRequest:(VKRequest *)request
responseErrorOccured:(id)error
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

- (void)  VKRequest:(VKRequest *)request
parsingErrorOccured:(NSError *)error
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

- (void)  VKConnector:(VKConnector *)connector
applicationWasDeleted:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"Error: %@", error);
}

@end
