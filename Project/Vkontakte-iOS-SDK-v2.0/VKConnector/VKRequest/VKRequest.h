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


@class VKRequest;


@protocol VKRequestProtocol

@required
- (void)VKRequest:(NSURLRequest *)request
         response:(id)response;

@optional
- (void)     VKRequest:(NSURLRequest *)request
connectionErrorOccured:(NSError *)error;

- (void)  VKRequest:(NSURLRequest *)request
parsingErrorOccured:(NSError *)error;

- (void)VKRequest:(NSURLRequest *)request
       totalBytes:(NSUInteger)totalBytes
  downloadedBytes:(NSUInteger)downloadedBytes;

- (void)VKRequest:(NSURLRequest *)request
       totalBytes:(NSUInteger)totalBytes
     uplodedBytes:(NSUInteger)uploadedBytes;

@end


@interface VKRequest : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak, readwrite) id <VKRequestProtocol> delegate;

+ (instancetype)request:(NSURLRequest *)request
               delegate:(id <VKRequestProtocol>)delegate;

+ (instancetype)requestHTTPMethod:(NSString *)httpMethod
                              URL:(NSURL *)url
                          headers:(NSDictionary *)headers
                             body:(NSData *)body
                         delegate:(id <VKRequestProtocol>)delegate;

+ (instancetype)requestMethod:(NSString *)methodName
                      options:(NSDictionary *)options
                     delegate:(id <VKRequestProtocol>)delegate;

- (instancetype)initWithRequest:(NSURLRequest *)request;

- (instancetype)initWithHTTPMethod:(NSString *)httpMethod
                               URL:(NSURL *)url
                           headers:(NSDictionary *)headers
                              body:(NSData *)body;

- (instancetype)initWithMethod:(NSString *)methodName
                       options:(NSDictionary *)options;

- (void)start;

- (void)cancel;

@end