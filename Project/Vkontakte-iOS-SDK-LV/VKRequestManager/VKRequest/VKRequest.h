//
// Created by AndrewShmig on 6/28/13.
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
#import "VKCache.h"
#import "VKMethods.h"
#import "NSString+Utilities.h"
#import "VKStorage.h"
#import "VKStorageItem.h"
#import "VKUser.h"
#import "VKAccessToken.h"


/** Unknown content length of server response
*/
#define NSURLResponseUnknownContentLength 0


@class VKRequest;


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
- (void)VKRequest:(VKRequest *)request
         response:(id)response;

@optional
/**
@name Optional
*/
/** Method is called when connection error occurs

@param request request that changed its state
@param error error description
*/
- (void)     VKRequest:(VKRequest *)request
connectionErrorOccured:(NSError *)error;

/** Method is called if any error occurs during server response parsing

@param request request that changed its state
@param error error description
*/
- (void)  VKRequest:(VKRequest *)request
parsingErrorOccured:(NSError *)error;

/** Method is called if server response contains any error message

@param request request that changed its state
@param error error description as Foundation object obtained from server response
*/
- (void)   VKRequest:(VKRequest *)request
responseErrorOccured:(id)error;

/** Method is called if user needs to enter captcha

More info about how to work with captcha you can find here:
https://github.com/AndrewShmig/Vkontakte-iOS-SDK-v2.0/issues/11

@param request request that changed its state
@param captchaSid unique captcha identifier
@param captchaImage ссылка на изображение, которое нужно показать пользователю, чтобы он ввел текст с этого изображения
@param captchaImage link to captcha (an image that should be shown to end user)
*/
- (void)VKRequest:(VKRequest *)request
       captchaSid:(NSString *)captchaSid
     captchaImage:(NSString *)captchaImage;

/** Method is called each time new portion of data is received

@param request request that changed its state
@param totalBytes total bytes to be transfered, if this value can not be determined
than 0 is used
@param downloadedBytes bytes already downloaded
*/
- (void)VKRequest:(VKRequest *)request
       totalBytes:(NSUInteger)totalBytes
  downloadedBytes:(NSUInteger)downloadedBytes;

/** Method is called each time new portion of data is sent (its recommended to use
this method while uploading images, audio, video files)

@param request request that changed its state
@param totalBytes total bytes to be received. If this value can not be determined
than 0 is used.
@param uploadedBytes bytes already uploaded
*/
- (void)VKRequest:(VKRequest *)request
       totalBytes:(NSUInteger)totalBytes
    uploadedBytes:(NSUInteger)uploadedBytes;

@end


/** Current class allows to perform different kind of requests to VK servers.
*/
@interface VKRequest : NSObject <NSURLConnectionDataDelegate, NSCopying>

/**
@name Properties
*/
/** Delegate
*/
@property (nonatomic, weak, readwrite) id <VKRequestDelegate> delegate;

/** Request signature. Can be used as identifier for each request object.
*/
@property (nonatomic, strong, readwrite) id signature;

/** Cache lifetime for current request. Defaults to one hour.
*/
@property (nonatomic, assign, readwrite) VKCacheLiveTime cacheLiveTime;

/** Offline mode for current request. Current mode is used to return cache data even
if its lifetime ended, no deletion occurs (use this mode if no internet connection exists).

Defaults to NO.
*/
@property (nonatomic, assign, readwrite) BOOL offlineMode;

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

@param httpMethod GET/POST/PUT/DELETE
@param url NSURL on which a request will be performed
@param headers request headers
@param body request body
@param delegate delegate that will receive notifications (should conform to
VKRequestDelegate protocol)

@return VKRequest instance
*/
+ (instancetype)requestHTTPMethod:(NSString *)httpMethod
                              URL:(NSURL *)url
                          headers:(NSDictionary *)headers
                             body:(NSData *)body
                         delegate:(id <VKRequestDelegate>)delegate;

/** Creates a VKRequest request

@param httpMethod GET/POST/PUT/DELETE
@param methodName VK method name (users.get, wall.post etc)
@param options params which should be sent (key = value)
@param delegate delegate that will receive notifications (should conform to
VKRequestDelegate protocol)

@return VKRequest instance
*/
+ (instancetype)requestHTTPMethod:(NSString *)httpMethod
                       methodName:(NSString *)methodName
                          options:(NSDictionary *)options
                         delegate:(id <VKRequestDelegate>)delegate;

/** Creates a VKRequest request

@param methodName VK method name (user.get, wall.post etc)
@param options params which should be sent (key = value)
@param delegate delegate that will receive notifications (should conform to
VKRequestDelegate protocol)

@return VKRequest instance
*/
+ (instancetype)requestMethod:(NSString *)methodName
                      options:(NSDictionary *)options
                     delegate:(id <VKRequestDelegate>)delegate;

/**
@name Instance methods
*/
/** Main method for VKRequest initialization

@param request NSURLRequest which will be used as a base request for VKRequest

@return VKRequest instance
*/
- (instancetype)initWithRequest:(NSURLRequest *)request;

/** Method for VKRequest initialization

@param httpMethod GET/POST/PUT/DELETE
@param url NSURL on which a request will be performed
@param headers request headers
@param body request body

@return VKRequest instance
*/
- (instancetype)initWithHTTPMethod:(NSString *)httpMethod
                               URL:(NSURL *)url
                           headers:(NSDictionary *)headers
                              body:(NSData *)body;

/** Method for VKRequest initialization

Example:

    VKRequest *request = [[VKRequest alloc] initWithMethod:@"users.get"
                                        options:@{@"fields": @"nickname,bdate,status"}];

@param methodName VK method name (users.get, wall.post etc)
@param options params that should be transmitted to VK method

@return VKRequest instance
*/
- (instancetype)initWithMethod:(NSString *)methodName
                       options:(NSDictionary *)options;

/** Starts request
*/
- (void)start;

/** Cancels request
*/
- (void)cancel;

/**
@name Appending files
*/
/** Content of an audio file is added

@param file audio file in byte representation
@param name audio file name
@param field HTML field name, which will be used to send (wrap) data
*/
- (void)appendAudioFile:(NSData *)file
                   name:(NSString *)name
                  field:(NSString *)field;

/** Content of a video file is added

@param file video file in byte representation
@param name video file name
@param field HTML field name, which will be used to send (wrap) data
*/
- (void)appendVideoFile:(NSData *)file
                   name:(NSString *)name
                  field:(NSString *)field;

/** Content of a document file is added

@param file document file in byte representation
@param name document file name
@param field HTML field name, which will be used to send (wrap) data
*/
- (void)appendDocumentFile:(NSData *)file
                      name:(NSString *)name
                     field:(NSString *)field;

/** Content of an image file is added

@param file image file in byte representation
@param name image file name
@param field HTML field name, which will be used to send (wrap) data
*/
- (void)appendImageFile:(NSData *)file
                   name:(NSString *)name
                  field:(NSString *)field;
@end