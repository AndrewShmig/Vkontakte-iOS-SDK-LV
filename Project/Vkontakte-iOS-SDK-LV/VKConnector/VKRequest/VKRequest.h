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
#import "VKCachedData.h"


/** Неизвестный размер передаваемых сервером данных
*/
#define NSURLResponseUnknownContentLength 0


/** Префикс URL на который производятся запросы к API социальной сети
*/
static NSString *const kVKAPIURLPrefix = @"https://api.vk.com/method/";


@class VKRequest;


/** Протокол инкапсулирует в себе основные методы для отслеживания состояния
осуществляемого запроса.

Обязательным является лишь один метод - метод, который возвращает ответ, остальные
являются опциональными.
*/
@protocol VKRequestDelegate <NSObject>

@required
/**
@name Обязательные
*/
/** Возвращает ответ сервера в виде Foundation объекта

@param request запрос к которому относится вызов метода делегата
@param response ответ сервера в виде Foundation объекта
*/
- (void)VKRequest:(VKRequest *)request
         response:(id)response;

@optional
/**
@name Опциональные
*/
/** Вызывается в случае, если произошла ошибка соединения

@param request запрос к которому относится вызов метода делегата
@param error ошибка с описанием причины сбоя при осуществлении запроса
*/
- (void)     VKRequest:(VKRequest *)request
connectionErrorOccured:(NSError *)error;

/** Вызывается в случае, если произошла ошибка парсинга ответа сервера

@param request запрос к которому относится вызов метода делегата
@param error ошибка с описанием причины сбоя при осуществлении парсинга данных
*/
- (void)  VKRequest:(VKRequest *)request
parsingErrorOccured:(NSError *)error;

/** Вызывается в случае, если в ответе есть ошибка

@param request запрос к которому относится вызов метода делегата
@param error ответ сервера с описанием ошибки
*/
- (void)   VKRequest:(VKRequest *)request
responseErrorOccured:(id)error;

/** Вызывается в случае, если требуется ввести капчу

Дополнительная информация по обработке капчи: https://github.com/AndrewShmig/Vkontakte-iOS-SDK-v2.0/issues/11

@param request запрос к которому относится вызов метода делегата
@param captchaSid идентификатор captcha
@param captchaImage ссылка на изображение, которое нужно показать пользователю, чтобы он ввел текст с этого изображения
*/
- (void)VKRequest:(VKRequest *)request
       captchaSid:(NSString *)captchaSid
     captchaImage:(NSString *)captchaImage;

/** Вызывается каждый раз, когда получена новая порция данных (метод удобно
использовать для отображения статуса загрузки данных)

@param request запрос к которому относится вызов метода делегата
@param totalBytes суммарное кол-во байт, которые необходимо получить. Если по каким-то
причинам не удаётся определить это кол-во, то будет передаваться 0
@param downloadedBytes кол-во уже загруженных байт
*/
- (void)VKRequest:(VKRequest *)request
       totalBytes:(NSUInteger)totalBytes
  downloadedBytes:(NSUInteger)downloadedBytes;

/** Вызывается каждый раз, когда отправлена очередная порция данных (метод удобно
использовать для отображения статуса отправки данных, будь то загрузка аудио файла,
видео файла или документа)

@param request запрос к которому отновится вызов метода делегата
@param totalBytes суммарное кол-во байт, которые необходимо получить. Если по каким-то
причинам не удаётся определить это кол-во, от будет передаваться 0
@param uploadedBytes кол-во уже загруженных байт
*/
- (void)VKRequest:(VKRequest *)request
       totalBytes:(NSUInteger)totalBytes
    uploadedBytes:(NSUInteger)uploadedBytes;

@end


/** Оболочка для осуществления запросов к социальной сети ВКонтакте
*/
@interface VKRequest : NSObject <NSURLConnectionDataDelegate, NSCopying>

/**
@name Свойства
*/
/** Делегат
*/
@property (nonatomic, weak, readwrite) id <VKRequestDelegate> delegate;

/** Произвольная подпись запроса. Позволит идентифицировать запрос в случае, если
один делегат осуществляет обработку нескольких запросов.
*/
@property (nonatomic, strong, readwrite) id signature;

/** Время жизни кэша текущего запроса. По умолчанию время жизни кэша один час.
*/
@property (nonatomic, assign, readwrite) VKCachedDataLiveTime cacheLiveTime;

/** Оффлайн режим запроса. В данном режиме данные будут запрошены из кэша и возвращены
даже в случае истечения срока их действия (удаления не произойдет).
По умолчанию режим выключен.
*/
@property (nonatomic, assign, readwrite) BOOL offlineMode;

/**
@name Методы класса
*/
/** Создает и возвращает запроса

@param request запрос, который будет использован в качестве основы
@param delegate делегат, который будет получать уведомления/сообщения об изменении
состояния объекта и данных

@return экземпляр класса VKRequest
*/
+ (instancetype)request:(NSURLRequest *)request
               delegate:(id <VKRequestDelegate>)delegate;

/** Создает и возвращает запрос

@param httpMethod GET или POST
@param url URL на который будет осуществлен запрос
@param headers заголовки запроса
@param body тело запроса
@param delegate делегат, который будет получать уведомления/сообщения об изменении
состояния объекта и данных

@return экземпляр класса VKRequest
*/
+ (instancetype)requestHTTPMethod:(NSString *)httpMethod
                              URL:(NSURL *)url
                          headers:(NSDictionary *)headers
                             body:(NSData *)body
                         delegate:(id <VKRequestDelegate>)delegate;

/** Создает и возвращает запрос

@param methodName наименование метода API (users.get, groups.join etc)
@param options словарь передаваемых параметров этому методу
@param delegate делегат, который будет получать уведомления/сообщения об изменении
состояния объекта и данных

@return экземпляр класса VKRequest
*/
+ (instancetype)requestMethod:(NSString *)methodName
                      options:(NSDictionary *)options
                     delegate:(id <VKRequestDelegate>)delegate;

/**
@name Методы экземпляра
*/
/** Основной методы инициализации объекта

@param request запрос, который будет использован в качестве основы

@return объект типа VKRequest
*/
- (instancetype)initWithRequest:(NSURLRequest *)request;

/** Метод инициализации объекта

@param httpMethod GET или POST
@param url URL на который будет осуществлен запрос
@param headers заголовки запроса
@param body тело запроса

@return объекта типа VKRequest
*/
- (instancetype)initWithHTTPMethod:(NSString *)httpMethod
                               URL:(NSURL *)url
                           headers:(NSDictionary *)headers
                              body:(NSData *)body;

/** Метод инициализации объекта

Рассмотрим пример:

    VKRequest *request = [[VKRequest alloc] initWithMethod:@"users.get"
                                        options:@{@"fields": @"nickname,bdate,status"}];

Будет создан объект VKRequest и в последующем осуществлен вызов метода users.get
социальной сети. Параметр fields будет равен "nickname,bdate,status", а значит
социальная сеть вернет ник, дату рождения и статус текущего пользователя.

@param methodName наименования метода API (users.get, groups.join etc)
@param options словарь передаваемых параметров этому методу

@return объекта класса VKRequest
*/
- (instancetype)initWithMethod:(NSString *)methodName
                       options:(NSDictionary *)options;

/** Старт запроса
*/
- (void)start;

/** Отмена запроса
*/
- (void)cancel;

/**
@name Добавление файлов в тело запроса
*/
/** Добавление данных аудио файла в содержимое тела HTTP запроса

@param file байтовое представление аудио файла
@param name имя аудио файла
@param field наименования HTML поля, которое использовалось для отправки файла
*/
- (void)appendAudioFile:(NSData *)file
                   name:(NSString *)name
                  field:(NSString *)field;

/** Добавление данных видео файла в содержимое тела HTTP запроса

@param file байтовое представление видео файла
@param name имя видео файла
@param field наименование HTML поля, которое использовалось для отправки файла
*/
- (void)appendVideoFile:(NSData *)file
                   name:(NSString *)name
                  field:(NSString *)field;

/** Добавление данных документа в содержимое тела HTTP запроса

@param file байтовое представление документа
@param name имя файла документа
@param field наименование HTML поля, которое использовалось для отправки файла
*/
- (void)appendDocumentFile:(NSData *)file
                      name:(NSString *)name
                     field:(NSString *)field;

/** Добавление данных изображения в содержимое тела HTTP запроса

@param file байтовое представление изображения
@param name имя файла изображения
@param field наименование HTML поля, которое использовалось для отправки файла
*/
- (void)appendImageFile:(NSData *)file
                   name:(NSString *)name
                  field:(NSString *)field;
@end