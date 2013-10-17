//
// Created by AndrewShmig on 5/28/13.
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
//
#import <Foundation/Foundation.h>


/**
 Класс содержит информацию о пользовательском токене доступа.

 Кроме самого токена доступа хранится следующая информация:

 - список прав к которым есть доступ приложения (offline, photo, docs, friends, ex и др)
 - срок истечения действия токена
 - пользовательский идентификатор в социальной сети ВКонтакте
 - токен доступа
 */

@interface VKAccessToken : NSObject <NSCopying, NSCoding>

/**
 @name Свойства
 */

/**
 Массив пользовательских разрешений к которым был получен доступ приложением
 */
@property (nonatomic, copy, readonly) NSArray *permissions;

/**
Время создания токена
*/
@property (nonatomic, assign, readonly) NSTimeInterval creationTime;

/**
 Время жизни токена доступа.
 */
@property (nonatomic, assign, readonly) NSTimeInterval liveTime;

/**
 Пользовательский идентификатор в социальной сети ВКонтакте.
 */
@property (nonatomic, assign, readonly) NSUInteger userID;

/**
 Токен доступа.
 */
@property (nonatomic, copy, readonly) NSString *token;

/**
 Истекло ли время действия текущего токена доступа или нет.
 NO - если токен всё еще действует, иначе - YES.

 NO в следующих случаях:

 - Время истечения токена больше нуля и больше текущего времени.
 - Время истечения токена равно нулю и в списке доступов присутствует "offline" доступ

 */
@property (nonatomic, readonly) BOOL isExpired;

/** Действителен ли токен.

 Возвращает YES, если токен неравен nil и срок его действия не истек.
 */
@property (nonatomic, readonly) BOOL isValid;

/**
 @name Методы инициализации
 */

/**
 Основной метод инициализации.

 @param userID Пользовательский идентификатор в социальной сети ВКонтакте.
 @param token Токен доступа.
 @param liveTime Время жизни токена доступа.
 @param permissions Список полученных приложением прав.
 @return Объект VKAccessToken класса.
 */
- (instancetype)initWithUserID:(NSUInteger)userID
                   accessToken:(NSString *)token
                      liveTime:(NSTimeInterval)liveTime
                   permissions:(NSArray *)permissions;

/**
 Вторичный метод инициализации класса.

 permissions принимает значение по умолчанию  @[].

 @see initWithUserID:accessToken:liveTime:permissions:

 @param userID Пользовательский идентификатор в социальной сети ВКонтакте.
 @param token Токен доступа.
 @param liveTime Время жизни токена доступа.
 @return Объект VKAccessToken класса.
 */
- (instancetype)initWithUserID:(NSUInteger)userID
                   accessToken:(NSString *)token
                      liveTime:(NSTimeInterval)liveTime;

/**
Вторичный метод инициализации класса.

 permissions принимает значение по умолчанию @[].

 liveTime принимает значение по умолчанию 0.

 @see initWithUserID:accessToken:liveTime:permissions:

 @param userID Пользовательский идентификатор в социальной сети ВКонтакте
 @param token Токен доступа.
 @return Объект VKAccessToken класса.
 */
- (instancetype)initWithUserID:(NSUInteger)userID
                   accessToken:(NSString *)token;

/**
 @name Перегруженные методы
 */
/**
 Описание состояния класса VKAccessToken.

 @return Строковое представление текущего класса.
 */
- (NSString *)description;

/** Проверяет токены доступов на равенство
@param token токен доступа с которым необходимо сравнить
@return YES - если токены доступа равны (на результат сравнения влияет только сам
токен доступа, список пользовательских разрешений и идентификатор пользователя, которому
принадлежит данный токен)
*/
- (BOOL)isEqual:(VKAccessToken *)token;

/**
 @name Публичные методы
 */
/**
 Метод проверяет наличие определенного доступа в общем списке доступов данного токена.

 @param permission Наименование доступа.
 @return YES - если такое право присутствует в общем списке, иначе - NO.
 */
- (BOOL)hasPermission:(NSString *)permission;

@end