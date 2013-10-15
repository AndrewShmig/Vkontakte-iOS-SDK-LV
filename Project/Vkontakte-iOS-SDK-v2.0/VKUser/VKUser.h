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


@class VKAccessToken;
@class VKRequest;
@protocol VKRequestDelegate;


/**
 Класс представляет пользователя социальной сети, который может осуществлять ряд
 действий с объектами вроде групп, друзей, музыкой, видео и тд.

 Класс так же позволяет изменить текущего активного пользователя на одного из
 пользователей находящихся в хранилище (ранее авторизованных). Получить список
 пользователей, которые авторизовывались можно используя метод localUsers.

 @warning методы, которые требуют наличия access_token в запросе _перезаписывают_
 токен доступа, если таковой был указан при передаче словаря ключей-значений, на
 значение токена доступа текущего пользователя - self.accessToken.token.

 @warning по умолчанию у каждого запроса из класса VKUser подпись (signature)
 является строкой селектора инициировавшего/создавшего объекта запроса
 */
@interface VKUser : NSObject

/** Пользовательски токен доступа текущего активного пользователя
*/
@property (nonatomic, readonly) VKAccessToken *accessToken;


/**
@name Методы класса
*/
/** Текущий активный пользователь.

Если хранилище не содержит авторизованных пользователей, то возвращено будет значение
nil.

В случае, если активным не был установлен какой-то определенный пользователь, то
при вызове данного метода активируется произвольный пользователь из хранилища (если
в хранилище будет находится лишь один пользователь, то именно он будет активирован
и от его лица будут осуществляться дальнейшие запросы).

_Вопрос:_ Когда может произойти подобная ситуация?

_Ответ:_ Представим, что два и более пользователей подряд авторизовались и, во время
авторизаций не было вызовов метода currentUser.

Рассмотрим на примере:

    // авторизовался пользователь А
    // авторизовался пользователь Б
    // авторизовался пользователь В
    [VKUser currentUser] // будет активирован произвольный пользователь, либо А, либо Б, либо В

Второй пример:

    // авторизовался пользователь А
    [VKUser currentUser] // активным устанавливается пользователь А
    // авторизовался пользователь Б, но А по прежнему активный
    // авторизовался пользователь В, но А по прежнему активный

*/
+ (instancetype)currentUser;

/** Делает активным пользователя с идентификатором userID.

Если пользователя с таким идентификатором нет в хранилище, то метод вернет NO, иначе
YES.

@param userID идентификатор пользователя, которого необходимо активировать

@return булево значение, удалось ли активировать указанного пользователя или нет
*/
+ (BOOL)activateUserWithID:(NSUInteger)userID;

/** Получение списка пользователей находящихся в хранилище

@return массив пользовательских идентификаторов
*/
+ (NSArray *)localUsers;

/**
@name Переопределенные методы
 */
/** Описание текущего пользователя
*/
- (NSString *)description;

@end