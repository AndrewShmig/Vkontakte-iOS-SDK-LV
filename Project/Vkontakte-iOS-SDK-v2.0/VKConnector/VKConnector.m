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
#import "KGModal.h"
#import "VKStorage.h"
#import "VKStorageItem.h"


#define MARGIN_WIDTH 25.0 // ширина отступа от границ экрана
#define MARGIN_HEIGHT 50.0 // высота отступа


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

    @synchronized (self) {
        if (instanceVKConnector == nil) {
            instanceVKConnector = [[self alloc] init];
        }
    }

    return instanceVKConnector;
}

#pragma mark - VKConnector public methods

- (void)startWithAppID:(NSString *)appID
            permissons:(NSArray *)permissions
{
    _permissions = permissions;
    _appID = appID;

    _settings = [self.permissions componentsJoinedByString:@","];
    _redirectURL = @"https://oauth.vk.com/blank.html";

    if (nil == _mainView) {
        // настраиваем попап окно для отображения UIWebView
        CGRect frame = [[UIScreen mainScreen] bounds];
        frame.size.height -= MARGIN_HEIGHT;
        frame.size.width -= MARGIN_WIDTH;
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

    [urlAsString appendString:@"https://oauth.vk.com/authorize?"];
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

    [[KGModal sharedInstance] setDelegate:self];
    [[KGModal sharedInstance] showWithContentView:_mainView
                                      andAnimated:YES];
}

#pragma mark - WebView delegate methods

- (BOOL)           webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
            navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [[request URL] absoluteString];

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

    if ([url hasPrefix:@"https://oauth.vk.com/blank.html"]) {
        [[KGModal sharedInstance] hideAnimated:YES];
    }

//    разрешаем пользователю только сменить язык в окне авторизации, ничего более
    if([url hasPrefix:@"https://vk.com"] || [url hasPrefix:@"http://vk.com"] ||
            ([url hasPrefix:@"https://m.vk.com"] && ![url hasPrefix:@"https://m.vk.com/settings"])){
        return NO;
    }

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicator stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityIndicator startAnimating];
}

#pragma mark - KGModal delegate

- (void)KGModalWillAppear:(KGModal *)kgModal
{
    if ([self.delegate respondsToSelector:@selector(VKConnector:willShowModalView:)])
        [self.delegate VKConnector:self
                 willShowModalView:[KGModal sharedInstance]];
}

- (void)KGModalWillDisappear:(KGModal *)kgModal
{
    if ([self.delegate respondsToSelector:@selector(VKConnector:willHideModalView:)])
        [self.delegate VKConnector:self
                 willHideModalView:[KGModal sharedInstance]];
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

@end
