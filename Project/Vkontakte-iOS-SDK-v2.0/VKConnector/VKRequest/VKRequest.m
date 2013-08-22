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


#define INFO_LOG() NSLog(@"%s", __FUNCTION__)


#define kCaptchaErrorCode 14


@implementation VKRequest
{
    NSMutableURLRequest *_request;
    NSURLConnection *_connection;

    NSMutableData *_receivedData;
    NSMutableData* _body;
    NSString* _boundary, *_boundaryHeader, *_boundaryFooter;
    NSUInteger _expectedDataSize;

    BOOL _isBodyEmpty;
}

#pragma mark Visible VKRequest methods
#pragma mark - Class methods

+ (instancetype)request:(NSURLRequest *)request
               delegate:(id <VKRequestDelegate>)delegate
{
    INFO_LOG();

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
    INFO_LOG();

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
    INFO_LOG();

    VKRequest *request = [[VKRequest alloc]
                                     initWithMethod:methodName
                                            options:options];

    request.delegate = delegate;

    return request;
}

#pragma mark - Init methods

- (instancetype)initWithRequest:(NSURLRequest *)request
{
    INFO_LOG();

    self = [super init];

    if (nil == self)
        return nil;

    _request = [request mutableCopy];
    _receivedData = [[NSMutableData alloc] init];
    _body = [[NSMutableData alloc] init];
    _boundary = [[NSProcessInfo processInfo] globallyUniqueString];
    _boundaryHeader = [NSString stringWithFormat:@"\r\n--%@\r\n",
                                                 _boundary];
    _boundaryFooter = [NSString stringWithFormat:@"\r\n--%@--\r\n",
                                                 _boundary];
    _expectedDataSize = NSURLResponseUnknownContentLength;
    _cacheLiveTime = VKCachedDataLiveTimeOneHour;
    _offlineMode = NO;
    _isBodyEmpty = YES;

    return self;
}

- (instancetype)initWithHTTPMethod:(NSString *)httpMethod
                               URL:(NSURL *)url
                           headers:(NSDictionary *)headers
                              body:(NSData *)body
{
    INFO_LOG();

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    [request setHTTPMethod:[httpMethod uppercaseString]];
    [request setURL:url];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:body];

    return [self initWithRequest:request];
}

- (instancetype)initWithMethod:(NSString *)methodName
                       options:(NSDictionary *)options
{
    INFO_LOG();

    NSMutableString *fullURL = [NSMutableString string];
    [fullURL appendFormat:@"%@%@", kVKAPIURLPrefix, methodName];

//    нет надобности добавлять "?", если параметров нет
    if (0 != [options count])
        [fullURL appendString:@"?"];

    NSMutableArray *params = [NSMutableArray array];
    [options enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        NSString *param = [NSString stringWithFormat:@"%@=%@",
                                                     [[key description]
                                                           lowercaseString],
                                                     [[obj description]
                                                           encodeURL]];

        [params addObject:param];
    }];

//    сортировка нужна для того, чтобы одинаковые запросы имели одинаковый MD5
//    не стоит забывать, что при итерации по словарю порядок чтения записей может
//    быть каждый раз разный
    [params sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    [fullURL appendString:[params componentsJoinedByString:@"&"]];

    NSURL *url = [NSURL URLWithString:fullURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];

    return [self initWithRequest:request];
}

#pragma mark - Start & cancel request

- (void)start
{
    INFO_LOG();

//    установлен ли делегат? если нет, то и запрос выполнять нет смысла
    if (nil == self.delegate)
        return;

//    перед тем как начать выполнение запроса проверим кэш
    NSUInteger currentUserID = [[[VKUser currentUser] accessToken] userID];
    VKStorageItem *item = [[VKStorage sharedStorage]
                                      storageItemForUserID:currentUserID];

    NSData *cachedResponseData = [item.cachedData cachedDataForURL:[self removeAccessTokenFromURL:_request.URL]
                                                       offlineMode:_offlineMode];
    if (nil != cachedResponseData) {
        _receivedData = [cachedResponseData mutableCopy];
        [self connectionDidFinishLoading:_connection];

//        нет надобности следить за состоянием "обновляющего" запроса
//        только при удачном исходе данные в кэше будут обновлены
        self.delegate = nil;
    }

//    если тело запроса установлено, то внесем кое-какие завершающие штрихи
    if(!_isBodyEmpty){
        [_request setValue:[NSString stringWithFormat:@"%d", [_body length]]
        forHTTPHeaderField:@"Content-Length"];
        [_request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=\"%@\"", _boundary]
        forHTTPHeaderField:@"Content-Type"];

//        "закроем" тело
        [_body appendData:[_boundaryFooter dataUsingEncoding:NSUTF8StringEncoding]];
        [_request setHTTPBody:_body];
    }

    _connection = [[NSURLConnection alloc]
                                    initWithRequest:_request
                                           delegate:self
                                   startImmediately:YES];
}

- (void)cancel
{
    INFO_LOG();

    _receivedData = nil;
    _expectedDataSize = NSURLResponseUnknownContentLength;
    [_connection cancel];
}

#pragma mark - Request body manipulations


- (void)appendAudioFile:(NSData *)file
                   name:(NSString *)name
                  field:(NSString *)field
{
    [self appendFile:file
                name:name
               field:field];
}

- (void)appendDocumentFile:(NSData *)file
                      name:(NSString *)name
                     field:(NSString *)field
{
    [self appendFile:file
                name:name
               field:field];
}

- (void)appendImageFile:(NSData *)file
                   name:(NSString *)name
                  field:(NSString *)field
{
    [self appendFile:file
                name:name
               field:field];
}

- (void)appendVideoFile:(NSData *)file
                   name:(NSString *)name
                  field:(NSString *)field
{
    [self appendFile:file
                name:name
               field:field];
}

#pragma mark - Overridden methods

- (NSString *)description
{
    NSDictionary *description = @{
            @"delegate"      : self.delegate,
            @"signature"     : self.signature,
            @"cacheLiveTime" : @(self.cacheLiveTime),
            @"offlineMode"   : (self.offlineMode ? @"YES" : @"NO"),
            @"request"       : [_request description]
    };

    return [description description];
}

- (id)copyWithZone:(NSZone *)zone
{
    VKRequest *copy = [[VKRequest alloc]
                                  initWithRequest:_request];

    copy.signature = _signature;
    copy.cacheLiveTime = _cacheLiveTime;
    copy.offlineMode = _offlineMode;

    return copy;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    INFO_LOG();

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;

    if (200 != [httpResponse statusCode]) {

        if (nil != self.delegate && [self.delegate respondsToSelector:@selector(VKRequest:connectionErrorOccured:)]) {

            NSError *error = [NSError errorWithDomain:@"VKRequestErrorDomain"
                                                 code:[httpResponse statusCode]
                                             userInfo:@{
                                                     @"Response headers"             : [httpResponse allHeaderFields],
                                                     @"Localized status code string" : [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]
                                             }];

            [self.delegate VKRequest:self
              connectionErrorOccured:error];
        }

        return;
    }

    if (NSURLResponseUnknownLength == response.expectedContentLength) {
        NSString *contentLength = httpResponse.allHeaderFields[@"Content-Length"];

        if (nil != contentLength) {
            _expectedDataSize = (NSUInteger) [contentLength integerValue];
        } else {
            _expectedDataSize = NSURLResponseUnknownContentLength;
        }
    } else {
        _expectedDataSize = (NSUInteger) response.expectedContentLength;
    }
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    INFO_LOG();

    [_receivedData appendData:data];

    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(VKRequest:totalBytes:downloadedBytes:)]) {

        if (nil != self.delegate && [self.delegate respondsToSelector:@selector(VKRequest:totalBytes:downloadedBytes:)]) {

            [self.delegate VKRequest:self
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
    INFO_LOG();

    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(VKRequest:totalBytes:uploadedBytes:)]) {

        if (nil != self.delegate && [self.delegate respondsToSelector:@selector(VKRequest:totalBytes:uploadedBytes:)]) {

            [self.delegate VKRequest:self
                          totalBytes:[_body length]
                       uploadedBytes:(NSUInteger) totalBytesWritten];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    INFO_LOG();

//    обработка полного ответа сервера
    NSJSONReadingOptions mask = NSJSONReadingAllowFragments |
            NSJSONReadingMutableContainers |
            NSJSONReadingMutableLeaves;
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:_receivedData
                                              options:mask
                                                error:&error];

    if (nil != error) {
        if (nil != self.delegate && [self.delegate respondsToSelector:@selector(VKRequest:parsingErrorOccured:)]) {
            [self.delegate VKRequest:self
                 parsingErrorOccured:error];
        }

        return;
    }

//    проверим, если в ответе содержится ошибка
    if(nil != json[@"error"]){

//      капча ли?
        if(kCaptchaErrorCode == [json[@"error"][@"error_code"] integerValue]){

            if(nil != self.delegate && [self.delegate respondsToSelector:@selector(VKRequest:captchaSid:captchaImage:)]){
                NSString *captchaSid = json[@"error"][@"captcha_sid"];
                NSString *captchaImage = json[@"error"][@"captcha_img"];

                [self.delegate VKRequest:self
                              captchaSid:captchaSid
                            captchaImage:captchaImage];
            }

//        прекращаем дальнейшую обработку
//        кэшировать ошибки не будем
            return;
        }

//        другая ошибка
        if(nil != self.delegate && [self.delegate respondsToSelector:@selector(VKRequest:responseErrorOccured:)]){
            [self.delegate VKRequest:self
                responseErrorOccured:json[@"error"]];
        }

//        прекращаем дальнейшую обработку
//        кэшировать ошибки не будем
        return;
    }

//    кэшируем данные запроса, если:
//    1. данные запроса не из кэша
//    2. время жизни кэша не установлено в "никогда"
//    3. метод запроса GET
    if (VKCachedDataLiveTimeNever != self.cacheLiveTime && ![@"POST" isEqualToString:_request.HTTPMethod]) {

        NSUInteger currentUserID = [[[VKUser currentUser] accessToken] userID];
        VKStorageItem *item = [[VKStorage sharedStorage]
                                          storageItemForUserID:currentUserID];

        [item.cachedData addCachedData:_receivedData
                                forURL:[self removeAccessTokenFromURL:_request.URL]
                              liveTime:self.cacheLiveTime];
    }

//    возвращаем Foundation объект
    [self.delegate VKRequest:self
                    response:json];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    INFO_LOG();

    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(VKRequest:connectionErrorOccured:)]) {
        [self.delegate VKRequest:self
          connectionErrorOccured:error];
    }
}

#pragma mark - private methods

- (NSURL *)removeAccessTokenFromURL:(NSURL *)url
{
//    уберем токен доступа из строки запроса
//    токен доступа может меняться при каждом обновлении (повторном входе пользователя),
//    но создавать каждый раз новый кэш для одинаковых запросов с всего лишь разными
//    токенами доступа нет смысла.
    NSString *query = [url query];
    NSArray *params = [query componentsSeparatedByString:@"&"];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF BEGINSWITH \"access_token\")"];
    NSArray *newParams = [params filteredArrayUsingPredicate:predicate];

    NSString *part1 = [[url absoluteString] componentsSeparatedByString:@"?"][0];
    NSString *part2 = [newParams componentsJoinedByString:@"&"];
    NSURL *newURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", part1, part2]];

    return newURL;
}

- (void)appendFile:(NSData *)file
              name:(NSString *)name
             field:(NSString *)field
{
//    header part
    [_body appendData:[_boundaryHeader dataUsingEncoding:NSUTF8StringEncoding]];

    NSString *contentDisposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
                                                              field,
                                                              name];
    [_body appendData:[contentDisposition dataUsingEncoding:NSUTF8StringEncoding]];

//    Content-Type
    NSString *contentType = [self determineContentTypeFromExtension:[[name componentsSeparatedByString:@"."]
                                                                           lastObject]];
    if (nil != contentType) {
        NSString *fullContentType = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",
                                                               contentType];
        [_body appendData:[fullContentType dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        [_body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }

//    file part
    [_body appendData:file];

    _isBodyEmpty = NO;
}

- (NSString *)determineContentTypeFromExtension:(NSString *)extension
{
    NSDictionary *contentTypes = @{

//            audio
            @"mid"  : @"audio/midi",
            @"midi" : @"audio/midi",
            @"mpg"  : @"audio/mpeg",
            @"mp3"  : @"audio/mpeg3",
            @"wav"  : @"audio/wav",

//            video
            @"avi"  : @"video/avi",
            @"mpeg" : @"video/mpeg",
            @"mpg"  : @"video/mpeg",
            @"mov"  : @"video/quicktime",

//            image
            @"bmp"  : @"image/bmp",
            @"gif"  : @"image/gif",
            @"jpeg" : @"image/jpeg",
            @"jpg"  : @"image/jpeg",
            @"png"  : @"image/png",
            @"tif"  : @"image/tiff",
            @"tiff" : @"image/tiff",
            @"ico"  : @"image/x-icon",

//            documents
            @"pdf"  : @"application/pdf",
            @"xls"  : @"application/excel",
            @"ppt"  : @"application/mspowerpoint",
            @"pps"  : @"application/mspowerpoint",
            @"doc"  : @"application/msword",
            @"docx" : @"application/msword",
            @"psd"  : @"application/octet-stream",
            @"rtf"  : @"application/rtf",
            @"gz"   : @"application/x-compressed",
            @"tgz"  : @"application/x-compressed",
            @"zip"  : @"application/x-compressed"
    };

    return contentTypes[[extension lowercaseString]];
}

@end