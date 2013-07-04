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
#import "VKRequest.h"
#import "VKUser.h"
#import "NSString+encodeURL.h"
#import "VKStorage.h"
#import "VKStorageItem.h"
#import "VKAccessToken.h"


@implementation VKRequest
{
    NSMutableURLRequest *_request;
    NSURLConnection *_connection;

    NSMutableData *_receivedData;
    NSUInteger _expectedDataSize;
}

#pragma mark Visible VKRequest methods
#pragma mark - Class methods

+ (instancetype)request:(NSURLRequest *)request
               delegate:(id <VKRequestDelegate>)delegate
{
    VKRequest *returnRequest = [[VKRequest alloc]
                                           initWithRequest:request];
    returnRequest.delegate = delegate;

    return returnRequest;
}

+ (instancetype)requestHTTPMethod:(NSString *)httpMethod
                              URL:(NSURL *)url
                          headers:(NSDictionary *)headers
                             body:(NSData *)body
                         delegate:(id <VKRequestDelegate>)delegate
{
    VKRequest *request = [[VKRequest alloc]
                                     initWithHTTPMethod:httpMethod
                                                    URL:url
                                                headers:headers
                                                   body:body];

    request.delegate = delegate;

    return request;
}

+ (instancetype)requestMethod:(NSString *)methodName
                      options:(NSDictionary *)options
                     delegate:(id <VKRequestDelegate>)delegate
{
    VKRequest *request = [[VKRequest alloc]
                                     initWithMethod:methodName
                                            options:options];

    request.delegate = delegate;

    return request;
}

#pragma mark - Init methods

- (instancetype)initWithRequest:(NSURLRequest *)request
{
    self = [super init];

    if (nil == self)
        return nil;

    _request = [request mutableCopy];
    _receivedData = [[NSMutableData alloc] init];
    _connection = [[NSURLConnection alloc]
                                    initWithRequest:_request
                                           delegate:self];
    _expectedDataSize = NSURLResponseUnknownContentLength;
    _cacheLiveTime = VKCachedDataLiveTimeOneHour;
    _offlineMode = NO;
}

- (instancetype)initWithHTTPMethod:(NSString *)httpMethod
                               URL:(NSURL *)url
                           headers:(NSDictionary *)headers
                              body:(NSData *)body
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:[httpMethod uppercaseString];
    [request setURL:url];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:body];

    return [self initWithRequest:request];
}

- (instancetype)initWithMethod:(NSString *)methodName
                       options:(NSDictionary *)options
{
    NSMutableString *fullURL = [NSMutableString string];
    [fullURL appendFormat:@"%@%@", kVKAPIURLPrefix, methodName];

    NSMutableArray *params = [NSMutableArray array];
    [options enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        NSString *objString = (NSString *) obj;
        NSString *keyString = (NSString *) key;
        NSString *param = [NSString stringWithFormat:@"%@=%@",
                                                     keyString,
                                                     [objString encodeURL]];

        [params addObject:param];
    }];

    [fullURL appendString:[params componentsJoinedByString:@"&"]];

    NSURL *url = [NSURL URLWithString:fullURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];

    return [self initWithRequest:request];
}

#pragma mark - Start & cancel request

- (void)start
{
//    перед тем как начать выполнение запроса проверим кэш
    NSUInteger currentUserID = [[[VKUser currentUser] accessToken] userID];
    VKStorageItem *item = [[VKStorage sharedStorage]
                                      storageItemForUserID:currentUserID];

    NSData *cachedResponseData = [item.cachedData cachedDataForURL:_connection.currentRequest.URL
                                                       offlineMode:_offlineMode];
    if(nil != cachedResponseData){
        _receivedData = [cachedResponseData mutableCopy];

        [self connectionDidFinishLoading:_connection];

        return;
    }

    [_connection start];
}

- (void)cancel
{
    _receivedData = nil;
    _expectedDataSize = NSURLResponseUnknownContentLength;
    [_connection cancel];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

    if(200 != [httpResponse statusCode]){

        if(nil != _delegate && [_delegate respondsToSelector:@selector(VKRequest:connectionErrorOccured:)]){

            NSError *error = [NSError errorWithDomain:@"VKRequestErrorDomain"
                                                 code:[httpResponse statusCode]
                                             userInfo:@{
                                                     @"Response headers": [httpResponse allHeaderFields],
                                                     @"Localized status code string": [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]
                                             }];

            [_delegate VKRequest:self
          connectionErrorOccured:error];
        }

        return;
    }

    if(NSURLResponseUnknownLength == response.expectedContentLength)
        _expectedDataSize = NSURLResponseUnknownContentLength;
    else
        _expectedDataSize = (NSUInteger)response.expectedContentLength;
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];

    if(nil != _delegate && [_delegate respondsToSelector:@selector(VKRequest:totalBytes:downloadedBytes:)]){

        if(nil != _delegate && [_delegate respondsToSelector:@selector(VKRequest:totalBytes:downloadedBytes:)]){

            [_delegate VKRequest:self
                      totalBytes:_expectedDataSize
                 downloadedBytes:[_receivedData length]];
        }
    }
}

- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
        totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if(nil != _delegate && [_delegate respondsToSelector:@selector(VKRequest:totalBytes:uploadedBytes:)]){

        if(nil != _delegate && [_delegate respondsToSelector:@selector(VKRequest:totalBytes:uploadedBytes:))]){

            [_delegate VKRequest:self
                      totalBytes:(NSUInteger)totalBytesExpectedToWrite
                   uploadedBytes:(NSUInteger)totalBytesWritten];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    обработка полного ответа сервера
    NSJSONReadingOptions mask = NSJSONReadingAllowFragments |
                                NSJSONReadingAllowFragments |
                                NSJSONReadingMutableContainers |
                                NSJSONReadingMutableLeaves;
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:_receivedData
                                              options:mask
                                                error:&error];

    if(nil != error){
        if(nil != _delegate && [_delegate respondsToSelector:@selector(VKRequest:parsingErrorOccured:)]){
            [_delegate VKRequest:self
             parsingErrorOccured:error];
        }

        return;
    }

//    кэшируем данные запроса, если запрос GET
    NSUInteger currentUserID = [[[VKUser currentUser] accessToken] userID];
    VKStorageItem *item = [[VKStorage sharedStorage]
                                      storageItemForUserID:currentUserID];

    if(VKCachedDataLiveTimeNever != _cacheLiveTime && ![@"POST" isEqualToString:connection.currentRequest.HTTPMethod]){
        [item.cachedData addCachedData:_receivedData
                                forURL:connection.currentRequest.URL
                              liveTime:_cacheLiveTime];
    }

//    возвращаем Foundation объект
    [_delegate VKRequest:self
                response:json];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    if (nil != _delegate && [_delegate respondsToSelector:@selector(VKRequest:connectionErrorOccured:)]) {
        [_delegate VKRequest:self
      connectionErrorOccured:error];
    }
}

@end