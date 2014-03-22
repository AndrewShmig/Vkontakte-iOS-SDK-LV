//
//  VKConnector.m
//
//  Created by Andrew Shmig on 18.12.12.
//
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

#import "VKConnector.h"
#import "VkontakteSDK_Logger.h"


@implementation VKConnector
{
    NSString *_settings;
    NSString *_redirectURL;

    VKAccessToken *_accessToken;
}

#pragma mark - Init methods & Class methods

+ (instancetype)sharedInstance
{
    VK_LOG();

    static VKConnector *instanceVKConnector = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^
    {
        instanceVKConnector = [[self alloc] init];
    });

    return instanceVKConnector;
}

#pragma mark - VKConnector public methods

- (void)startWithAppID:(NSString *)appID
            permissons:(NSArray *)permissions
               webView:(UIWebView *)webView
              delegate:(id <VKConnectorDelegate>)delegate
{
    VK_LOG(@"%@", @{
            @"webView"     : webView,
            @"appID"       : appID,
            @"permissions" : permissions,
            @"delegate"    : delegate
    });

    _permissions = permissions;
    _appID = appID;
    _delegate = delegate;

    _settings = [self.permissions componentsJoinedByString:@","];
    _redirectURL = kVkontakteBlankURL;

    [webView setDelegate:self];

//    преобразование словаря параметров в строку параметров
    NSDictionary *params = @{@"client_id"     : self.appID,
                             @"redirect_uri"  : _redirectURL,
                             @"scope"         : _settings,
                             @"response_type" : @"token",
                             @"display"       : @"mobile"};
    NSMutableString *urlAsString = [[NSMutableString alloc] init];
    NSMutableArray *urlParams = [[NSMutableArray alloc] init];

    [urlAsString appendFormat:@"%@?", kVkontakteAuthorizationURL];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        [urlParams addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    [urlAsString appendString:[urlParams componentsJoinedByString:@"&"]];

//    запрос на страницу авторизации приложения
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

//    отображаем попап
    [webView loadRequest:request];
}

#pragma mark - WebView delegate methods

- (BOOL)           webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
            navigationType:(UIWebViewNavigationType)navigationType
{
    VK_LOG(@"%@", @{
            @"webView"        : webView,
            @"request"        : request,
            @"navigationType" : @(navigationType)
    });

    NSString *url = [[request URL] absoluteString];

//    разрешаем пользователю только сменить язык в окне авторизации, ничего более
    if ([[[NSURL URLWithString:url] host] endsWithString:@"vk.com"]) {
        return YES;
    }

    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    VK_LOG();

//    вызываем метод делегата, который уведомляет о завершении загрузки
    if ([self.delegate respondsToSelector:@selector(VKConnector:webViewDidFinishLoad:)]) {
        [self.delegate VKConnector:self
              webViewDidFinishLoad:webView];
    }

//    обрабатываем запрос
    NSString *url = [[[webView request] URL] absoluteString];

    if ([url hasPrefix:_redirectURL]) {
        NSString *queryString = [url componentsSeparatedByString:@"#"][1];
        NSArray *parts = [queryString componentsSeparatedByString:@"&"];

//        проверим, если мы пришли сюда после процесса валидации пользователя (security check)
//        или это обычная авторизация пользователя приложения
        if (([queryString hasPrefix:@"success"] && [parts count] >= 2) || [queryString hasPrefix:@"access_token"]) {
            NSString *accessToken;
            NSUInteger userID;
            NSUInteger liveTime;

            if ([queryString hasPrefix:@"success"]) {
//                проверим, пришел ли _только_ success параметр
//                если пришел, значит ничего не будем делать, а воспользуемся старым токеном доступа
//             парсим данные
                accessToken = [parts[1] componentsSeparatedByString:@"="][1];
                userID = [[parts[2] componentsSeparatedByString:@"="][1] unsignedIntValue];
                liveTime = 0;
            } else {
//            пользователь одобрил наше приложение, парсим полученные данные
                accessToken = [parts[0] componentsSeparatedByString:@"="][1];
                liveTime = [[parts[1] componentsSeparatedByString:@"="][1] unsignedIntValue];
                userID = [[parts[2] componentsSeparatedByString:@"="][1] unsignedIntValue];
            }

            _accessToken = [[VKAccessToken alloc]
                                           initWithUserID:userID
                                              accessToken:accessToken
                                                 liveTime:liveTime
                                              permissions:[_settings componentsSeparatedByString:@","]];

//            сохраняем токен доступа в хранилище
            VKStorageItem *storageItem = [[VKStorage sharedStorage]
                                                     createStorageItemForAccessToken:_accessToken];
            [[VKStorage sharedStorage] storeItem:storageItem];

//            уведомляем программиста, что токен был обновлён
            if ([self.delegate respondsToSelector:@selector(VKConnector:accessTokenRenewalSucceeded:)]) {

                [self.delegate VKConnector:self
               accessTokenRenewalSucceeded:_accessToken];
            }

        } else if ([queryString hasPrefix:@"success"]) { // всё прошло успешно, но токена не получили - хз, что делать дальше
//            никаких методов делегата не вызываем, потому что не знаю, что вызывать
        } else {
//            пользователь отказался авторизовать приложение
//            не удалось обновить/получить токен доступа
            if ([self.delegate respondsToSelector:@selector(VKConnector:accessTokenRenewalFailed:)]) {

                [self.delegate VKConnector:self
                  accessTokenRenewalFailed:nil];
            }
        }
    }

//    показываем пользователю окно только в том случае, если от него требуются
//    какие-то действия - ввод пароля, ввод капчи и тд
    if ([self showVKModalViewForWebView:webView]) {
        if (webView.hidden && [self.delegate respondsToSelector:@selector(VKConnector:willShowWebView:)]) {

            [self.delegate VKConnector:self
                       willShowWebView:webView];
        }
    }

//    прячем окно, если обработали либо авторизацию, либо отказ от авторизации
    if ([url hasPrefix:kVkontakteBlankURL]) {
        if (!webView.hidden && [self.delegate respondsToSelector:@selector(VKConnector:willHideWebView:)]) {

            [self.delegate VKConnector:self
                       willHideWebView:webView];
        }
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    VK_LOG();

//    вызываем метод делегата, который уведомляет о завершении загрузки
    if ([self.delegate respondsToSelector:@selector(VKConnector:webViewDidStartLoad:)]) {
        [self.delegate VKConnector:self
               webViewDidStartLoad:webView];
    }
}

- (void)     webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error
{
    VK_LOG(@"%@", @{
            @"webView" : webView,
            @"error"   : error
    });

    if ([self.delegate respondsToSelector:@selector(VKConnector:connectionError:)]) {

        if (!webView.hidden) {
            [self.delegate VKConnector:self
                       willHideWebView:webView];
        }

        [self.delegate VKConnector:self
                   connectionError:error];
    }
}

- (BOOL)showVKModalViewForWebView:(UIWebView *)webView
{
    VK_LOG(@"%@", @{
            @"webView" : webView
    });

//    получаем содержимое тега head
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('head')[0].innerHTML"];

//    если содержимое пустое значит загрузилась страница сообщающая об ошибке
//    удаления приложения
    if (nil == html || [html isEmpty]) {

        if ([self.delegate respondsToSelector:@selector(VKConnector:applicationWasDeleted:)]) {

            NSError *error = [NSError errorWithDomain:kVKErrorDomain
                                                 code:kVKApplicationWasDeletedErrorCode
                                             userInfo:nil];

            [self.delegate VKConnector:self
                 applicationWasDeleted:error];
        }

        return NO;
    }

//    ввод пароля или при смене айпишника - номера телефона
    NSURLRequest *request = [webView request];
    NSString *urlAsString = [[request URL] absoluteString];
    NSArray *actionPrefixes = @[kVkontakteAuthorizationURL];

    for (NSString *prefix in actionPrefixes) {
        if ([urlAsString startsWithString:prefix]) {
            return YES;
        }
    }

    return NO;
}

#pragma mark - Cookies manipulation methods

- (void)clearCookies
{
    VK_LOG();

    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];

    for (NSHTTPCookie *cookie in cookies) {
        if (NSNotFound != [cookie.domain rangeOfString:@"vk.com"].location) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]
                                  deleteCookie:cookie];
        }
    }
}

@end
