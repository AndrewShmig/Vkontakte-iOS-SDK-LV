//
// Copyright (c) 2013 Andrew Shmig
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import "VKMethods.h"
#import "VKAccessToken.h"
#import "VKStorage.h"
#import "NSString+Utilities.h"
#import "VKStorageItem.h"


@class VKConnector;


static NSString *const kVKErrorDomain = @"kVkontakteErrorDomain";


typedef enum
{
    kVKApplicationWasDeletedErrorCode
} kVkontakteErrorCode;


/** Protocol incapsulates methods that are triggered during user authorization
 process or access token status changes.
 */
@protocol VKConnectorDelegate <NSObject>

@optional
/**
 @name Show/hide web view
 */
/** Method is called when user needs to perform some action (enter login and
password, authorize your application etc)

@param connector VKConnector instance that sends notifications
@param webView UIWebView that displays authorization page
*/
- (void)VKConnector:(VKConnector *)connector
    willShowWebView:(UIWebView *)webView;

/** Method is called when UIWebView should be hidden, this method is called after
user has entered login+password or has authorized an application (or pressed
cancel button etc).

@param connector VKConnector instance that sends notifications
@param webView UIWebView that displays authorization page and needs to be hidden
*/
- (void)VKConnector:(VKConnector *)connector
    willHideWebView:(UIWebView *)webView;

/**
@name UIWebView started/finished loading a frame
*/
/** Method is called when UIWebView starts loading a frame

@param connector VKConnector instance that sends notifications
@param webView UIWebView that displays authorization page
*/
- (void)VKConnector:(VKConnector *)connector
webViewDidStartLoad:(UIWebView *)webView;

/** Method is called when UIWebView finishes loading a frame

@param connector VKConnector instance that sends notifications
@param webView UIWebView that displays authorization page
*/
- (void) VKConnector:(VKConnector *)connector
webViewDidFinishLoad:(UIWebView *)webView;

/**
 @name Access token
 */
/** Method is called when access token is successfully updated

@param connector VKConnector instance that sends notifications
@param accessToken updated access token
*/
- (void)        VKConnector:(VKConnector *)connector
accessTokenRenewalSucceeded:(VKAccessToken *)accessToken;

/** Method is called when access token failed to be updated. The main reason
could be that user denied/canceled to authorize your application.

@param connector VKConnector instance that sends notifications
@param accessToken access token (equals to nil)
*/
- (void)     VKConnector:(VKConnector *)connector
accessTokenRenewalFailed:(VKAccessToken *)accessToken;

/**
 @name Connection & Parsing
 */
/** Method is called when connection error occurred during authorization process.

@param connector VKConnector instance that sends notifications
@param error error description
*/
- (void)VKConnector:(VKConnector *)connector
    connectionError:(NSError *)error;

/** Method is called if VK application was deleted.

@param connector VKConnector instance that sends notifications
@param error error description
*/
- (void)  VKConnector:(VKConnector *)connector
applicationWasDeleted:(NSError *)error;

@end


/** The main purpose of this class is to process user authorization and obtain
access token which then will be used to perform requests from behalf of current
user.

Example:

    [[VKConnector sharedInstance] startWithAppID:@"12345567"
                                  permissions:@[@"wall"]
                                  webView:webView
                                  delegate:self];
*/
@interface VKConnector : NSObject <UIWebViewDelegate>

/**
@name Properties
*/
/** Delegate
 */
@property (nonatomic, weak, readonly) id <VKConnectorDelegate> delegate;

/** Application's unique identifier
*/
@property (nonatomic, strong, readonly) NSString *appID;

/** Permissions
*/
@property (nonatomic, strong, readonly) NSArray *permissions;

/**
@name Class methods
*/
/** Returns shared instances of VKConnector class.
*/
+ (id)sharedInstance;

/**
@name User authorization
*/
/** Starts user authorization process.

@param appID application's unique identifier
@param permissions array of permissions (wall, friends, audio, video etc)
@param webView UIWebView which will be used to display VK authorization page
@param delegate delegate which will receive notifications
*/
- (void)startWithAppID:(NSString *)appID
            permissons:(NSArray *)permissions
               webView:(UIWebView *)webView
              delegate:(id <VKConnectorDelegate>)delegate;

/**
@name Cookies
*/
/** Removes all cookies which were obtained after user has authorized VK
application. This method is used to log out current user.
*/
- (void)clearCookies;

@end
