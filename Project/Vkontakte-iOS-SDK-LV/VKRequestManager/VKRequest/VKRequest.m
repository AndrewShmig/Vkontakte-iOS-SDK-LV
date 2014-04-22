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

#import "VKRequest.h"
#import "VKMethods.h"
#import "VkontakteSDK_Logger.h"
#import "VKUser.h"
#import "VKRequestManager.h"


#define kCaptchaErrorCode 14
#define kValidationRequired 17


@interface VKRequest (Private)

- (instancetype)initWithHTTPMethod:(NSString *)HTTPMethod
                           HTTPURL:(NSURL *)HTTPURL
                          HTTPBody:(NSData *)HTTPBody
               HTTPQueryParameters:(NSDictionary *)queryParameters
                  HTTPHeaderFields:(NSDictionary *)headerFields
                          delegate:(id <VKRequestDelegate>)delegate;

@end


@implementation VKRequest
{
    NSURLConnection *_connection;
    NSMutableData *_receivedData;
    NSString *_boundary, *_boundaryHeader, *_boundaryFooter;
    NSInteger _expectedDataSize;
    BOOL _isFileAdded;
    BOOL _isDataFromCache;
}

#pragma mark - Init methods

- (instancetype)initWithHTTPMethod:(NSString *)httpMethod
                               URL:(NSURL *)URL
                           headers:(NSDictionary *)headers
                              body:(NSData *)body
                          delegate:(id <VKRequestDelegate>)delegate
{
    VK_LOG();

    return [self initWithHTTPMethod:httpMethod
                            HTTPURL:URL
                           HTTPBody:body
                HTTPQueryParameters:[NSDictionary new]
                   HTTPHeaderFields:headers
                           delegate:delegate];
}

- (instancetype)initWithHTTPMethod:(NSString *)httpMethod
                        methodName:(NSString *)methodName
                   queryParameters:(NSDictionary *)queryParameters
                          delegate:(id <VKRequestDelegate>)delegate
{
    VK_LOG();

    return [self initWithHTTPMethod:httpMethod
                            HTTPURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                                                                    kVkontakteAPIURL,
                                                                                    methodName]]
                           HTTPBody:[NSData new]
                HTTPQueryParameters:queryParameters
                   HTTPHeaderFields:[NSDictionary new]
                           delegate:delegate];
}

- (instancetype)initWithMethod:(NSString *)methodName
               queryParameters:(NSDictionary *)queryParameters
                      delegate:(id <VKRequestDelegate>)delegate
{
    VK_LOG();

    return [self initWithHTTPMethod:@"GET"
                            HTTPURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                                                                    kVkontakteAPIURL,
                                                                                    methodName]]
                           HTTPBody:[NSData new]
                HTTPQueryParameters:queryParameters
                   HTTPHeaderFields:[NSDictionary new]
                           delegate:delegate];
}

- (instancetype)initWithRequest:(NSURLRequest *)request
                       delegate:(id <VKRequestDelegate>)delegate
{
    VK_LOG();

//    преобразуем query строку в словарь ключей-значений
    NSMutableDictionary *queryParameters = [NSMutableDictionary new];

    NSArray *params = [request.URL.query componentsSeparatedByString:@"&"];
    [params enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        NSArray *param = [(NSString *) obj componentsSeparatedByString:@"="];
        NSString *key = param[0];
        NSString *value = param[1];

        queryParameters[key] = value;
    }];

//    получаем URL без query строки
    NSRange range = [request.URL.absoluteString rangeOfString:@"?"];
    NSString *urlWithoutQuery = [request.URL.absoluteString substringToIndex:range.location];

    NSURL *httpURL = [NSURL URLWithString:urlWithoutQuery];

    return [self initWithHTTPMethod:request.HTTPMethod
                            HTTPURL:httpURL
                           HTTPBody:request.HTTPBody
                HTTPQueryParameters:queryParameters
                   HTTPHeaderFields:[NSDictionary new]
                           delegate:delegate];
}


#pragma mark - Class methods

+ (instancetype)request:(NSURLRequest *)request
               delegate:(id <VKRequestDelegate>)delegate
{
    VK_LOG();

    return [[self alloc] initWithRequest:request
                                delegate:delegate];
}

+ (instancetype)requestMethod:(NSString *)methodName
              queryParameters:(NSDictionary *)queryParameters
                     delegate:(id <VKRequestDelegate>)delegate
{
    VK_LOG();

    return [[self alloc] initWithMethod:methodName
                        queryParameters:queryParameters
                               delegate:delegate];
}

+ (instancetype)requestHTTPMethod:(NSString *)httpMethod
                       methodName:(NSString *)methodName
                  queryParameters:(NSDictionary *)queryParameters
                         delegate:(id <VKRequestDelegate>)delegate
{
    VK_LOG();

    return [[self alloc] initWithHTTPMethod:httpMethod
                                 methodName:methodName
                            queryParameters:queryParameters
                                   delegate:delegate];
}

+ (instancetype)requestHTTPMethod:(NSString *)httpMethod
                              URL:(NSURL *)URL
                          headers:(NSDictionary *)headers
                             body:(NSData *)body
                         delegate:(id <VKRequestDelegate>)delegate
{
    VK_LOG();

    return [[self alloc] initWithHTTPMethod:httpMethod
                                        URL:URL
                                    headers:headers
                                       body:body
                                   delegate:delegate];
}

#pragma mark - Instance methods

- (void)start
{
    VK_LOG();

//    установлен ли делегат? если нет, то и запрос выполнять нет смысла
    if (nil == self.delegate)
        return;

//    перед тем как начать выполнение запроса проверим кэш
    NSUInteger currentUserID = self.requestManager.user.accessToken.userID;
    VKStorageItem *item = [[VKStorage sharedStorage]
                                      storageItemForUserID:currentUserID];

    NSData *cachedResponseData = [item.cache cacheForURL:[self uniqueRequestURL]
                                             offlineMode:self.offlineMode];
    if (nil != cachedResponseData) {
        _receivedData = [cachedResponseData mutableCopy];

//        данные взяты из кэша
        _isDataFromCache = YES;

        [self connectionDidFinishLoading:_connection];

//        нет надобности следить за состоянием "обновляющего" запроса
//        только при удачном исходе данные в кэше будут обновлены
        self.delegate = nil;
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

//    добавляем пользовательский токен доступа
    self.HTTPQueryParameters[@"access_token"] = item.accessToken.token;

//    HTTP метод отправки запроса
    request.HTTPMethod = self.HTTPMethod;

//    сформируем УРЛ на который будет отправлен запрос
//    в зависимости от метода отправки запроса параметры запроса пойдут либо
//    в УРЛ, либо в тело запроса
    NSURL *finalURL = [self createFinalURL];
    request.URL = finalURL;

//    формируем тело запроса
    NSMutableData *finalBody = [NSMutableData new];

    if ([[self.HTTPMethod lowercaseString] isEqualToString:@"post"]) {
        if ([self.HTTPQueryParameters count] != 0) {
//            параметры надо добавить в тело запроса
            NSMutableArray *queryParams = [NSMutableArray new];

            [self.HTTPQueryParameters enumerateKeysAndObjectsUsingBlock:^(id key,
                                                                          id value,
                                                                          BOOL *stop)
            {
                [queryParams addObject:[NSString stringWithFormat:@"%@=%@",
                                                                  [[key description]
                                                                        lowercaseString],
                                                                  [[value description]
                                                                          encodeURL]]];
            }];

            [finalBody appendData:[[NSString stringWithFormat:@"%@",
                                                              [queryParams componentsJoinedByString:@"&"]]
                                                              dataUsingEncoding:NSUTF8StringEncoding]];
        }

        if (_isFileAdded) {
            //    добавим _boundaryHeader
            [finalBody appendData:[_boundaryHeader dataUsingEncoding:NSUTF8StringEncoding]];

            //    добавим основную часть тела
            [finalBody appendData:self.HTTPBody];

            //    добавим _boundaryFooter
            [finalBody appendData:[_boundaryFooter dataUsingEncoding:NSUTF8StringEncoding]];

            //       установим необходимые поля хэдеров
            self.HTTPHeaderFields[@"Content-Length"] = [NSString stringWithFormat:@"%d",
                                                                                  self.HTTPBody.length];
            self.HTTPHeaderFields[@"Content-Type"] = [NSString stringWithFormat:@"multipart/form-data; boundary=\"%@\"",
                                                                                _boundary];
        }

        request.HTTPBody = finalBody;
    }

//    устанавливаем ключи-значения для хедеров
    request.allHTTPHeaderFields = self.HTTPHeaderFields;

//    создаем NSURLConnection и стартуем запрос
    _connection = [[NSURLConnection alloc]
                                    initWithRequest:request
                                           delegate:self
                                   startImmediately:YES];
}

- (void)cancel
{
    VK_LOG();

    _receivedData = nil;
    _expectedDataSize = NSURLResponseUnknownLength;
    [_connection cancel];
}

- (void)attachFile:(NSData *)file
              name:(NSString *)name
             field:(NSString *)field
{
    VK_LOG(@"%@", @{
            @"file"  : file,
            @"name"  : name,
            @"field" : field
    });

//    файл добавляем в тело запроса
    _isFileAdded = YES;

    NSString *contentDisposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
                                                              field,
                                                              name];
    [self.HTTPBody appendData:[contentDisposition dataUsingEncoding:NSUTF8StringEncoding]];

//    Content-Type
    NSString *contentType = [self determineContentTypeFromExtension:[[name componentsSeparatedByString:@"."]
                                                                           lastObject]];
    if (nil != contentType) {
        NSString *fullContentType = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",
                                                               contentType];
        [self.HTTPBody appendData:[fullContentType dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        [self.HTTPBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }

//    file part
    [self.HTTPBody appendData:file];
}

- (id)copyWithZone:(NSZone *)zone
{
    VK_LOG();

    VKRequest *copyRequest = [[VKRequest alloc]
                                         initWithHTTPMethod:self.HTTPMethod
                                                    HTTPURL:self.HTTPURL
                                                   HTTPBody:self.HTTPBody
                                        HTTPQueryParameters:self.HTTPQueryParameters
                                           HTTPHeaderFields:self.HTTPHeaderFields
                                                   delegate:self.delegate];

    copyRequest.signature = self.signature;
    copyRequest.cacheLiveTime = self.cacheLiveTime;
    copyRequest.offlineMode = self.offlineMode;

    return copyRequest;
}

- (NSString *)description
{
    VK_LOG();

    NSDictionary *description = @{
            @"delegate"            : self.delegate,
            @"signature"           : self.signature,
            @"cacheLiveTime"       : @(self.cacheLiveTime),
            @"offlineMode"         : (self.offlineMode ? @"YES" : @"NO"),
            @"HTTPMethod"          : self.HTTPMethod,
            @"HTTPURL"             : self.HTTPURL,
            @"HTTPQueryParameters" : self.HTTPQueryParameters,
            @"HTTPBody"            : self.HTTPBody,
            @"HTTPHeaderFields"    : self.HTTPHeaderFields
    };

    return [description description];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    VK_LOG(@"%@", @{
            @"connection" : connection,
            @"response"   : response
    });

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;

    if (200 != [httpResponse statusCode]) {
        if ([self.delegate respondsToSelector:@selector(VKRequest:connectionError:)]) {
            NSError *error = [NSError errorWithDomain:@"VKRequestErrorDomain"
                                                 code:[httpResponse statusCode]
                                             userInfo:@{
                                                     @"Response headers"             : [httpResponse allHeaderFields],
                                                     @"Localized status code string" : [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]
                                             }];

            [self.delegate VKRequest:self
                     connectionError:error];
        }

        return;
    }

    if (NSURLResponseUnknownLength == response.expectedContentLength) {
        NSString *contentLength = httpResponse.allHeaderFields[@"Content-Length"];

        if (nil != contentLength) {
            _expectedDataSize = (NSInteger) [contentLength integerValue];
        } else {
            _expectedDataSize = NSURLResponseUnknownLength;
        }
    } else {
        _expectedDataSize = (NSInteger) response.expectedContentLength;
    }
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    VK_LOG(@"%@", @{
            @"connection" : connection,
            @"data"       : data
    });

    [_receivedData appendData:data];

    if ([self.delegate respondsToSelector:@selector(VKRequest:totalBytes:downloadedBytes:)]) {

        [self.delegate VKRequest:self
                      totalBytes:_expectedDataSize
                 downloadedBytes:_receivedData.length];
    }
}

- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
        totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    VK_LOG(@"%@", @{
            @"connection"                : connection,
            @"bytesWritten"              : @(bytesWritten),
            @"totalBytesWritten"         : @(totalBytesWritten),
            @"totalBytesExpectedToWrite" : @(totalBytesExpectedToWrite)
    });

    if ([self.delegate respondsToSelector:@selector(VKRequest:totalBytes:uploadedBytes:)]) {

        [self.delegate VKRequest:self
                      totalBytes:self.HTTPBody.length
                   uploadedBytes:(NSUInteger) totalBytesWritten];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    VK_LOG(@"%@", @{
            @"connection" : connection
    });

//    обработка полного ответа сервера
    NSJSONReadingOptions mask = NSJSONReadingAllowFragments |
            NSJSONReadingMutableContainers |
            NSJSONReadingMutableLeaves;
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:_receivedData
                                              options:mask
                                                error:&error];

    if (nil != error) {
        if ([self.delegate respondsToSelector:@selector(VKRequest:parsingError:)]) {
            [self.delegate VKRequest:self
                        parsingError:error];
        }

        return;
    }

//    проверим, если в ответе содержится ошибка
    if (nil != json[@"error"]) {

//      капча ли?
        if (kCaptchaErrorCode == [json[@"error"][@"error_code"] integerValue]) {

            if ([self.delegate respondsToSelector:@selector(VKRequest:captchaSid:captchaImage:)]) {
                NSString *captchaSid = json[@"error"][@"captcha_sid"];
                NSString *captchaImage = json[@"error"][@"captcha_img"];

                [self.delegate VKRequest:self
                              captchaSid:captchaSid
                            captchaImage:[NSURL URLWithString:captchaImage]];
            }

//        прекращаем дальнейшую обработку
//        кэшировать ошибки не будем
            return;
        }

//        ошибка валидации пользователя? (security check)
        if (kValidationRequired == [json[@"error"][@"error_code"] integerValue]) {

            if ([self.delegate respondsToSelector:@selector(VKRequest:validationRedirectURL:)]) {
                NSString *validationURI = json[@"error"][@"redirect_uri"];

                [self.delegate VKRequest:self
                   validationRedirectURL:[NSURL URLWithString:validationURI]];
            }

            return;
        }

//        другая ошибка
        if ([self.delegate respondsToSelector:@selector(VKRequest:responseError:)]) {
            [self.delegate VKRequest:self
                       responseError:json[@"error"]];
        }

//        прекращаем дальнейшую обработку
//        кэшировать ошибки не будем
        return;
    }

//    кэшируем данные запроса, если:
//    1. данные запроса не из кэша
//    2. время жизни кэша не установлено в "никогда"
//    3. метод запроса GET
    if (!_isDataFromCache && VKCacheLiveTimeNever != self.cacheLiveTime && [[self.HTTPMethod lowercaseString]
                                                                                             isEqualToString:@"get"]) {
        NSUInteger currentUserID = self.requestManager.user.accessToken.userID;
        VKStorageItem *item = [[VKStorage sharedStorage]
                                          storageItemForUserID:currentUserID];

        [item.cache addCache:_receivedData
                      forURL:[self uniqueRequestURL]
                    liveTime:self.cacheLiveTime];
    }

//    возвращаем Foundation объект
    [self.delegate VKRequest:self
                    response:json];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    VK_LOG(@"%@", @{
            @"connection" : connection,
            @"error"      : error
    });

    if ([self.delegate respondsToSelector:@selector(VKRequest:connectionError:)]) {
        [self.delegate VKRequest:self
                 connectionError:error];
    }
}

#pragma mark - Private methods

- (instancetype)initWithHTTPMethod:(NSString *)HTTPMethod
                           HTTPURL:(NSURL *)HTTPURL
                          HTTPBody:(NSData *)HTTPBody
               HTTPQueryParameters:(NSDictionary *)queryParameters
                  HTTPHeaderFields:(NSDictionary *)headerFields
                          delegate:(id <VKRequestDelegate>)delegate
{
    VK_LOG();
    self = [super init];

    if (self) {
        _HTTPMethod = HTTPMethod;
        _HTTPURL = HTTPURL;
        _HTTPBody = (HTTPBody != nil ? [HTTPBody mutableCopy] : [NSMutableData new]);
        _HTTPQueryParameters = (queryParameters != nil ? [queryParameters mutableCopy] : [NSMutableDictionary new]);
        _HTTPHeaderFields = (headerFields != nil ? [headerFields mutableCopy] : [NSMutableDictionary new]);
        _delegate = delegate;
        _cacheLiveTime = VKCacheLiveTimeNever;
        _offlineMode = NO;
        _signature = nil;
        _receivedData = [NSMutableData new];
        _expectedDataSize = NSURLResponseUnknownLength;
        _boundary = [[NSProcessInfo processInfo] globallyUniqueString];
        _boundaryHeader = [NSString stringWithFormat:@"\r\n--%@\r\n",
                                                     _boundary];
        _boundaryFooter = [NSString stringWithFormat:@"\r\n--%@--\r\n",
                                                     _boundary];
        _isFileAdded = NO;
        _isDataFromCache = NO;
    }

    return self;
}

// для идентификации файла кэша
- (NSURL *)uniqueRequestURL
{
    VK_LOG();

    NSMutableString *urlAsString = [NSMutableString new];

//    добавляем часть УРЛа без query строки
    [urlAsString appendFormat:@"%@", self.HTTPURL.absoluteString];

//    добавляем параметры, которые идут в строке запроса
//    исключаем токен доступа и данные каптчи
    if ([self.HTTPQueryParameters count] != 0) {
        NSMutableArray *params = [NSMutableArray array];

        [self.HTTPQueryParameters enumerateKeysAndObjectsUsingBlock:^(id key,
                                                                      id obj,
                                                                      BOOL *stop)
        {
//            исключим из УРЛа временные параметры
            if ([[key description] isEqualToString:@"access_token"] ||
                    [[key description] isEqualToString:@"captcha_sid"] ||
                    [[key description] isEqualToString:@"captcha_key"]) {
            } else {
                NSString *param = [NSString stringWithFormat:@"%@=%@",
                                                             [[key description]
                                                                   lowercaseString],
                                                             [[obj description]
                                                                   encodeURL]];

                [params addObject:param];
            }
        }];

//      сортировка нужна для того, чтобы одинаковые запросы имели одинаковый MD5
//      не стоит забывать, что при итерации по словарю порядок чтения записей может
//      быть каждый раз разный
        [params sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

        [urlAsString appendFormat:@"?"];
        [urlAsString appendString:[params componentsJoinedByString:@"&"]];
    }

    return [NSURL URLWithString:urlAsString];
}

// для определения окончательного вида строки запроса (URL)
- (NSURL *)createFinalURL
{
    VK_LOG();

    NSMutableString *urlAsString = [NSMutableString new];

//    добавляем часть УРЛа без query строки
    [urlAsString appendFormat:@"%@", self.HTTPURL.absoluteString];

    if ([[self.HTTPMethod lowercaseString] isEqualToString:@"get"] &&
            [self.HTTPQueryParameters count] != 0) {

        [urlAsString appendFormat:@"?"];

        //    добавляем параметры, которые идут в строке запроса
        [self.HTTPQueryParameters enumerateKeysAndObjectsUsingBlock:^(id k,
                                                                      id o,
                                                                      BOOL *stop)
        {
            NSString *key = [(NSString *) k lowercaseString];
            NSString *value = (NSString *) o;

            [urlAsString appendFormat:@"%@=%@&",
                                      [[key description] lowercaseString],
                                      [[value description] encodeURL]];
        }];

        //        удаляем последний символ &
        [urlAsString deleteCharactersInRange:NSMakeRange([urlAsString length] - 1, 1)];
    }


    return [NSURL URLWithString:urlAsString];
}

- (NSString *)determineContentTypeFromExtension:(NSString *)extension
{
    VK_LOG(@"%@", @{
            @"extension" : extension
    });

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