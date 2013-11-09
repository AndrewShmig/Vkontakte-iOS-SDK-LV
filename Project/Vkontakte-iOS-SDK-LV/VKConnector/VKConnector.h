//
//  VKConnector.h
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

#import <Foundation/Foundation.h>
#import "VKMethods.h"
#import "VKAccessToken.h"
#import "VKStorage.h"
#import "NSString+Utilities.h"
#import "VKStorageItem.h"


@class VKConnector;


static NSString *const kVKErrorDomain = @"kVkontakteErrorDomain";


typedef enum {
    kVKApplicationWasDeletedErrorCode
} kVkontakteErrorCode;


/** Протокол объявляет методы отслеживания изменения статуса токена доступа
 хранимого классом VKConnector.
 */
@protocol VKConnectorDelegate <NSObject>

@optional
/**
 @name Show/hide web view
 */
/** Метод вызывается в случае, если необходимо отобразить UIWebView для выполнения
пользователем некоторых действий (ввода пароля, ввод капчи, ввод телефна и тд)
 
 @param connector объект класса VKConnector отправляющий сообщение
 @param webView UIWebView отображающий страницу авторизации
 */
- (void)VKConnector:(VKConnector *)connector
  shouldShowWebView:(UIWebView *)webView;

/** Метод вызывается в случае, если необходимо скрыть UIWebView, после того, как
пользователь авторизовался, либо отказался авторизовываться, либо произошла
какая-то ошибка.
 
 @param connector объект класса VKConnector отправляющий сообщение
 @param webView UIWebView отображающий страницу авторизации
 */
- (void)VKConnector:(VKConnector *)connector
  shouldHideWebView:(UIWebView *)webView;

/**
 @name Access token
 */
/** Метод, вызов которого сигнализирует о том, что токен доступа успешно обновлён.
 
 @param connector объект класса VKConnector отправляющий сообщение.
 @param accessToken новый токен доступа, который был получен.
 */
- (void)        VKConnector:(VKConnector *)connector
accessTokenRenewalSucceeded:(VKAccessToken *)accessToken;

/** Метод, вызов которого сигнализирует о том, что обновление токена доступа не
 удалось.
 Причиной ошибки может быть прерывание связи, либо пользователь отказался авторизовывать
 приложение.
 
 @param connector объект класса VKConnector отправляющего сообщение.
 @param accessToken токен доступа (равен nil)
 */
- (void)     VKConnector:(VKConnector *)connector
accessTokenRenewalFailed:(VKAccessToken *)accessToken;

/**
 @name Connection & Parsing
 */
/** Метод, вызов которого сигнализирует о том, что произошла ошибка соединения при попытке осуществить запрос
 
 @param connector объект класса VKConnector отправляющего сообщение
 @param error объект ошибки содержащий описание причины возникновения ошибки
 */
- (void)   VKConnector:(VKConnector *)connector
connectionErrorOccured:(NSError *)error;

/** Метод, вызов которого сигнализирует о том, что приложение в ВК, которое
используется для авторизации пользователя, было удалено.

@param connector объект класса VKConnector отправляющий сообщение
@param error объект ошибки содержащий описание причины возникшей ошибки
*/
- (void)  VKConnector:(VKConnector *)connector
applicationWasDeleted:(NSError *)error;

@end


/** Класс предназначен для получения приложением доступа к пользовательской учетной
 записи и осуществления запросов к API сервиса методами GET/POST.

    - (void)applicationDidFinishLaunching:(UIApplication *)application
    {
        [[VKConnector sharedInstance] startWithAppID:@"YOUR_APP_ID"
                                          permissons:@[@"friends",@"wall"]];
    }

 */
@interface VKConnector : NSObject <UIWebViewDelegate>

/**
@name Свойства
*/
/** Делегат
 */
@property (nonatomic, weak, readonly) id <VKConnectorDelegate> delegate;

/** Идентификатор приложения Вконтакте
 */
@property (nonatomic, strong, readonly) NSString *appID;

/** Список разрешений
 */
@property (nonatomic, strong, readonly) NSArray *permissions;

/**
@name Методы класса
*/
/** Метод класса для получения экземпляра сиглтона.
Если объект отсутствует, то он будет создан. Не может быть равен nil или NULL.
*/
+ (id)sharedInstance;

/**
@name Авторизация пользователем приложения
*/
/** Инициализирует запуск коннектора с заданными параметрами

 @param appID Идентификатор приложения полученный при регистрации.
 @param permissions Массив доступов (разрешений), которые необходимо получить приложению.
 @param webView UIWebView в котором необходимо отображать страницу авторизации приложения ВК
 @param delegate делегат
*/
- (void)startWithAppID:(NSString *)appID
            permissons:(NSArray *)permissions
               webView:(UIWebView *)webView
              delegate:(id <VKConnectorDelegate>)delegate;

/**
@name Манипулирование куками авторизации
*/
/** Удаляет куки, которые были получены при авторизации последним пользователем приложения.
Может понадобиться в случае, если вы хотите, чтобы пользователь мог использовать
несколько своих учетных записей социальной сети или для авторизации другого пользователя.
*/
- (void)clearCookies;

@end
