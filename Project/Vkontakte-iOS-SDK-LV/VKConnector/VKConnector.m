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
#import "VKAccessToken.h"
#import "VKModal.h"
#import "VKStorage.h"
#import "VKStorageItem.h"
#import "NSString+Utilities.h"


#define WIDTH_PADDING 25.0 // отступ по ширине всплывающего окна
#define HEIGHT_PADDING 255.0 // отступ по высоте всплывающего окна


@implementation VKConnector
{
    NSString *_settings;
    NSString *_redirectURL;

    UIWebView *_innerWebView;
    UIActivityIndicatorView *_activityIndicator;
    UIView *_mainView;

    VKAccessToken *_accessToken;
}

#pragma mark - Init methods & Class methods

+ (instancetype)sharedInstance
{
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
              delegate:(id <VKConnectorDelegate>)delegate
{
    _permissions = permissions;
    _appID = appID;
    _delegate = delegate;

    _settings = [self.permissions componentsJoinedByString:@","];
    _redirectURL = kVkontakteBlankURL;

    if (nil == _mainView) {
        // настраиваем попап окно для отображения UIWebView
        CGRect frame = [self makeFrameAccordingToOrientation];
        _mainView = [[UIView alloc] initWithFrame:frame];

        if (nil == _innerWebView) {
            _innerWebView = [[UIWebView alloc] initWithFrame:_mainView.frame];
            [_innerWebView setDelegate:self];
        }

        CGPoint centerPoint = [_innerWebView center];
        CGRect activityIndicatorFrame = CGRectMake(centerPoint.x - 20, centerPoint.y - 50, 30, 30);

        if (nil == _activityIndicator) {
            _activityIndicator = [[UIActivityIndicatorView alloc]
                                                           initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [_activityIndicator setColor:[UIColor darkGrayColor]];
            [_activityIndicator setFrame:activityIndicatorFrame];
            [_activityIndicator setHidesWhenStopped:YES];
            [_activityIndicator startAnimating];
        }

        [_innerWebView addSubview:_activityIndicator];
        [_mainView addSubview:_innerWebView];
    }

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
    [_innerWebView loadRequest:request];
}

#pragma mark - WebView delegate methods

- (BOOL)           webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
            navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [[request URL] absoluteString];

//    разрешаем пользователю только сменить язык в окне авторизации, ничего более
    if ([[[NSURL URLWithString:url] host] isEqualToString:@"vk.com"]) {
        return NO;
    }

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    останавливаем анимацию спинера
    [_activityIndicator stopAnimating];

//    обрабатываем запрос
    NSString *url = [[[webView request] URL] absoluteString];

    if ([url hasPrefix:_redirectURL]) {
        NSString *queryString = [url componentsSeparatedByString:@"#"][1];

//        проверяем одобрил ли пользователь наше приложение или нет
        if ([queryString hasPrefix:@"access_token"]) {
            NSArray *parts = [queryString componentsSeparatedByString:@"&"];

//            пользователь одобрил наше приложение, парсим полученные данные
            NSString *accessToken = [parts[0] componentsSeparatedByString:@"="][1];
            NSTimeInterval liveTime = [[parts[1] componentsSeparatedByString:@"="][1] doubleValue];
            NSUInteger userID = [[parts[2] componentsSeparatedByString:@"="][1] unsignedIntValue];

            _accessToken = [[VKAccessToken alloc]
                                           initWithUserID:userID
                                              accessToken:accessToken
                                                 liveTime:liveTime
                                              permissions:[_settings componentsSeparatedByString:@","]];

//            сохраняем токен доступа в хранилище
            VKStorageItem *storageItem = [[VKStorage sharedStorage]
                                                     createStorageItemForAccessToken:_accessToken];
            [[VKStorage sharedStorage] addItem:storageItem];

//            уведомляем программиста, что токен был обновлён
            if ([self.delegate respondsToSelector:@selector(VKConnector:accessTokenRenewalSucceeded:)])
                [self.delegate VKConnector:self
               accessTokenRenewalSucceeded:_accessToken];

        } else {
//            пользователь отказался авторизовать приложение
//            не удалось обновить/получить токен доступа
            if ([self.delegate respondsToSelector:@selector(VKConnector:accessTokenRenewalFailed:)])
                [self.delegate VKConnector:self
                  accessTokenRenewalFailed:nil];
        }
    }

//    показываем пользователю окно только в том случае, если от него требуются
//    какие-то действия - ввод пароля, ввод капчи и тд
    if (![[VKModal sharedInstance] isVisible] &&
            [self showVKModalViewForURL:[webView request]]) {

        [[VKModal sharedInstance] setDelegate:self];
        [[VKModal sharedInstance] showWithContentView:_mainView
                                          andAnimated:YES];
    }

//    прячем окно, если обработали либо авторизацию, либо отказ от авторизации
    if ([url hasPrefix:kVkontakteBlankURL]) {
        [[VKModal sharedInstance] hideAnimated:NO];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    запускаем анимацию спинера
    [_activityIndicator startAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(VKConnector:connectionErrorOccured:)]) {
        [self.delegate VKConnector:self
            connectionErrorOccured:error];

        [[VKModal sharedInstance] hideAnimated:NO];
    }
}

- (BOOL)showVKModalViewForURL:(NSURLRequest *)request
{
//    обработка случае, если приложение было удалено... хак грязный, иначе
//    никак не определить. Парсить HTML через JS не вариант.
    NSDictionary *headers = [request allHTTPHeaderFields];
    if (nil == headers[@"Accept-Encoding"] || nil == headers[@"Accept-Language"]) {

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
    NSString *urlAsString = [[request URL] absoluteString];
    NSArray *actionPrefixes = @[kVkontakteAuthorizationURL];

    for (NSString *prefix in actionPrefixes) {
        if ([urlAsString startsWithString:prefix]) {
            return YES;
        }
    }

    return NO;
}

#pragma mark - VKModal delegate

- (void)VKModalWillAppear:(VKModal *)vkModal
{
    if ([self.delegate respondsToSelector:@selector(VKConnector:willShowModalView:)]) {
        [self.delegate VKConnector:self
                 willShowModalView:[VKModal sharedInstance]];
    }
}

- (void)VKModalWillDisappear:(VKModal *)vkModal
{
    if ([self.delegate respondsToSelector:@selector(VKConnector:willHideModalView:)]) {
        [self.delegate VKConnector:self
                 willHideModalView:[VKModal sharedInstance]];
    }
}

#pragma mark - Cookies manipulation methods

- (void)clearCookies
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];

    for (NSHTTPCookie *cookie in cookies) {
        if (NSNotFound != [cookie.domain rangeOfString:@"vk.com"].location) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]
                                  deleteCookie:cookie];
        }
    }
}

#pragma mark - Device orientation

- (CGRect)makeFrameAccordingToOrientation
{
    CGRect frame;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]
                                                         statusBarOrientation];

    frame.origin = screenBounds.origin;
    frame.size.width = screenBounds.size.width - WIDTH_PADDING;

    if (UIInterfaceOrientationIsPortrait(orientation)) { // portrait
        frame.size.height = screenBounds.size.height - HEIGHT_PADDING;
    } else { // landscape
        frame.size.height = screenBounds.size.width - WIDTH_PADDING;
    }

    return frame;
}

@end
