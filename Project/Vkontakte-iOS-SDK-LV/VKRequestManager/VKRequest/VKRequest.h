//
// Copyright (C) 3/22/14  Andrew Shmig ( andrewshmig@yandex.ru )
// Russian Bleeding Games. All rights reserved.
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program; if not, write to the Free Software Foundation, Inc.,
// 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//

#import "VKCache.h"


@class VKRequest;
@class VKRequestManager;


/** Current protocol describes basic methods which report states of a running request.

There is only one required method - method that is getting an answer from VK server.
*/
@protocol VKRequestDelegate <NSObject>

@required
/**
@name Required methods
*/
/** Returns server response as Foundation object

@param request request that changed its state
@param response server response as Foundation object
*/
- (void)VKRequest:(VKRequest *)request response:(id)response;

@optional
/**
@name Optional
*/
/** Method is called when connection error occurs

@param request request that changed its state
@param error error description
*/
- (void)VKRequest:(VKRequest *)request connectionError:(NSError *)error;

/** Method is called if any error occurs during server response parsing

@param request request that changed its state
@param error error description
*/
- (void)VKRequest:(VKRequest *)request parsingError:(NSError *)error;

/** Method is called if server response contains any error message

@param request request that changed its state
@param error error description as Foundation object obtained from server response
*/
- (void)VKRequest:(VKRequest *)request responseError:(NSError *)error;

/** Method is called if user needs to enter captcha

More info about how to work with captcha you can find here:
https://github.com/AndrewShmig/Vkontakte-iOS-SDK-v2.0/issues/11

@param request request that changed its state
@param captchaSid unique captcha identifier
@param captchaImage link to captcha (an image that should be shown to end user)
*/
- (void)VKRequest:(VKRequest *)request
       captchaSid:(NSString *)captchaSid
     captchaImage:(NSURL *)captchaImage;

/** Method is called if user needs to pass security validation (used _only_ for testing purposes)

@param request request that changed its state
@param redirectURL URI that user should open in any browser
*/
- (void)    VKRequest:(VKRequest *)request
validationRedirectURL:(NSURL *)redirectURL;

/** Method is called each time new portion of data is received

@param request request that changed its state
@param totalBytes total bytes to be transfered, if this value can not be determined
than 0 is used
@param downloadedBytes bytes already downloaded
*/
- (void)VKRequest:(VKRequest *)request
       totalBytes:(NSInteger)totalBytes
  downloadedBytes:(NSInteger)downloadedBytes;

/** Method is called each time new portion of data is sent (its recommended to use
this method while uploading images, audio, video files)

@param request request that changed its state
@param totalBytes total bytes to be received. If this value can not be determined
than 0 is used.
@param uploadedBytes bytes already uploaded
*/
- (void)VKRequest:(VKRequest *)request
       totalBytes:(NSInteger)totalBytes
    uploadedBytes:(NSInteger)uploadedBytes;

@end


/** Current class allows to perform different kind of requests to VK servers.

Simple example which shows how to use VKRequest class (uploading an audio file).

AppDelegate.m file:

        - (BOOL)          application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        // ... code ...

        [[VKConnector sharedInstance] startWithAppID:kVKAppID
                                          permissons:[kVKPermissionsArray componentsSeparatedByString:@","]
                                             webView:self.webView
                                            delegate:self];

        // ... code ...
    }

    - (void)        VKConnector:(VKConnector *)connector
    accessTokenRenewalSucceeded:(VKAccessToken *)accessToken
    {
        _rm = [[VKRequestManager alloc]
                                 initWithDelegate:self
                                             user:[VKUser currentUser]];

        _rm.startAllRequestsImmediately = NO;

        VKRequest *firstStep = [_rm audioGetUploadServer:nil];
        firstStep.signature = @"firstStep";

        [firstStep start];
    }

    - (void)VKRequest:(VKRequest *)request
             response:(id)response
    {
        if ([request.signature isEqualToString:@"firstStep"]) {
            NSString *uploadURL = response[@"response"][@"upload_url"];
            NSString *audioPath = [[NSBundle mainBundle]
                                             pathForResource:@"123" ofType:@"mp3"];

            VKRequest *secondStep = [VKRequest requestHTTPMethod:@"POST"
                                                             URL:[NSURL URLWithString:uploadURL]
                                                         headers:nil
                                                            body:nil
                                                        delegate:self];
            [secondStep attachFile:[NSData dataWithContentsOfFile:audioPath]
                              name:@"Above & Beyond - Alone Tonight.mp3"
                             field:@"file"];
            secondStep.signature = @"secondStep";

            [secondStep start];
        } else if ([request.signature isEqualToString:@"secondStep"]) {
            VKRequest *thirdStep = [_rm audioSave:@{
                    @"server" : response[@"server"],
                    @"hash"   : response[@"hash"],
                    @"audio"  : response[@"audio"]
            }];

            thirdStep.signature = @"thirdStep";
            thirdStep.delegate = self;

            [thirdStep start];
        } else if ([request.signature isEqualToString:@"thirdStep"]) {
            NSLog(@"File was successfully uploaded!");
        }
    }

*/
@interface VKRequest : NSObject <NSURLConnectionDataDelegate, NSCopying>


/**
@name Properties
*/
/** Delegate
*/
@property (nonatomic, weak, readwrite) id <VKRequestDelegate> delegate;
/** Request Manager to which current request belongs to.
*/
@property (nonatomic, strong, readwrite) VKRequestManager *requestManager;
/** Request signature. Can be used as identifier for each request object.
*/
@property (nonatomic, strong, readwrite) id signature;
/** Cache lifetime for current request. Defaults to VKCacheLiveTimeNever.
*/
@property (nonatomic, assign, readwrite) VKCacheLiveTime cacheLiveTime;
/** Offline mode for current request. Current mode is used to return cache data even
if its lifetime ended, no deletion occurs (use this mode if no internet connection exists).

Defaults to NO.
*/
@property (nonatomic, assign, readwrite) BOOL offlineMode;

/** HTTP method: GET or POST
*/
@property (nonatomic, strong, readwrite) NSString *HTTPMethod;
/** HTTP URL
*/
@property (nonatomic, strong, readwrite) NSURL *HTTPURL;
/** Dictionary with key-value pairs for HTTP query URL part

Info:

    URL: http://vk.com/user.get?key=value&key2=value2
    Query: key=value&key2=value2

*/
@property (nonatomic, strong, readwrite) NSMutableDictionary *HTTPQueryParameters;
/** HTTP body
*/
@property (nonatomic, strong, readwrite) NSMutableData *HTTPBody;
/** HTTP headers
*/
@property (nonatomic, strong, readwrite) NSMutableDictionary *HTTPHeaderFields;

/**
@name Class methods
*/
/** Creates a VKRequest request

@param request NSURLRequest which will be used as base for VKRequest
@param delegate delegate that will receive notifications (should conform to
VKRequestDelegate protocol)

@return VKRequest instance
*/
+ (instancetype)request:(NSURLRequest *)request
               delegate:(id <VKRequestDelegate>)delegate;

/** Creates a VKRequest request

Example:

    VKRequest *r = [VKRequest requestMethod:@"users.get"
                            queryParameters:@{@"fields": @"nickname,age,city", @"count":@(100)}
                                   delegate:self];

@warning HTTP method defaults to GET.

@param methodName VK method name (users.get, wall.post etc)
@param queryParameters params which should be sent (key = value)
@param delegate delegate that will receive notifications (should conform to
VKRequestDelegate protocol)

@return VKRequest instance
*/
+ (instancetype)requestMethod:(NSString *)methodName
              queryParameters:(NSDictionary *)queryParameters
                     delegate:(id <VKRequestDelegate>)delegate;

/** Creates a VKRequest request

Example:

    VKRequest *r = [VKRequest requestHTTPMethod:@"POST"
                                     methodName:@"audio.save"
                                queryParameters:@{@"server": @"23434", @"hash":@"14c234f32f2"}
                                       delegate:self];

@param httpMethod GET/POST
@param methodName VK method name (users.get, wall.post etc)
@param queryParameters params which should be sent (key = value)
@param delegate delegate that will receive notifications (should conform to
VKRequestDelegate protocol)

@return VKRequest instance
*/
+ (instancetype)requestHTTPMethod:(NSString *)httpMethod
                       methodName:(NSString *)methodName
                  queryParameters:(NSDictionary *)queryParameters
                         delegate:(id <VKRequestDelegate>)delegate;

/** Creates a VKRequest request

@param httpMethod GET/POST/PUT/DELETE
@param URL NSURL on which a request will be performed
@param headers request headers
@param body request body
@param delegate delegate that will receive notifications (should conform to
VKRequestDelegate protocol)

@return VKRequest instance
*/
+ (instancetype)requestHTTPMethod:(NSString *)httpMethod
                              URL:(NSURL *)URL
                          headers:(NSDictionary *)headers
                             body:(NSData *)body
                         delegate:(id <VKRequestDelegate>)delegate;

/**
@name Instance methods
*/
/** Main method for VKRequest initialization

@param request NSURLRequest which will be used as a base request for VKRequest
@param delegate delegate that will receive notifications (should conform to
VKRequestDelegate protocol)

@return VKRequest instance
*/
- (instancetype)initWithRequest:(NSURLRequest *)request
                       delegate:(id <VKRequestDelegate>)delegate;

/** Method for VKRequest initialization

Example:

    VKRequest *request = [[VKRequest alloc] initWithMethod:@"users.get"
                                        queryParameters:@{@"fields": @"nickname,bdate,status"}
                                        delegate:self];

@param methodName VK method name (users.get, wall.post etc)
@param queryParameters params that should be transmitted to VK method
@param delegate delegate that will receive notifications (should conform to
VKRequestDelegate protocol)

@return VKRequest instance
*/
- (instancetype)initWithMethod:(NSString *)methodName
               queryParameters:(NSDictionary *)queryParameters
                      delegate:(id <VKRequestDelegate>)delegate;

/** Method for VKRequest initialization

@param httpMethod GET/POST
@param methodName VK method name (users.get, wall.post etc)
@param queryParameters params that should be transmitted to VK method
@param delegate delegate that will receive notifications (should conform to
VKRequestDelegate protocol)

@return VKRequest instance
*/
- (instancetype)initWithHTTPMethod:(NSString *)httpMethod
                        methodName:(NSString *)methodName
                   queryParameters:(NSDictionary *)queryParameters
                          delegate:(id <VKRequestDelegate>)delegate;

/** Method for VKRequest initialization

@param httpMethod GET/POST
@param URL NSURL on which a request will be performed
@param headers request headers
@param body request body
@param delegate delegate that will receive notifications (should conform to
VKRequestDelegate protocol)

@return VKRequest instance
*/
- (instancetype)initWithHTTPMethod:(NSString *)httpMethod
                               URL:(NSURL *)URL
                           headers:(NSDictionary *)headers
                              body:(NSData *)body
                          delegate:(id <VKRequestDelegate>)delegate;

/** Starts request
*/
- (void)start;

/** Cancels request
*/
- (void)cancel;

/**
@name Appending files
*/
/** Content of any file is added

Example:

    [secondStep attachFile:[NSData dataWithContentsOfFile:audioPath]
                      name:@"Above & Beyond - Alone Tonight.mp3"
                     field:@"file"];

@param file file byte representation
@param name file name
@param field HTML field name, which will be used to send (wrap) data
*/
- (void)attachFile:(NSData *)file name:(NSString *)name field:(NSString *)field;

@end