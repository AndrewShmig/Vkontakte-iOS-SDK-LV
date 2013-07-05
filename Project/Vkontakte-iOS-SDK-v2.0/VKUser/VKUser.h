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

/**
@name Свойства
*/
/** Делегат

Решение использовать сильную ссылку на объект делегата в классе VKUser возникает
при рассмотрении детально принципа работы запросов VKRequest.
В VKRequest ссылка на делегат является слабой, а значит, если и в VKUser будет
слабой, то вполне может случиться неприятность, когда будут запущено несколько
запросов, а делегат в некоторый момент времени установлен в nil (случайно или
намеренно), тогда получим пустые запросы результаты которых не нужны будут и не
будут использованы.

@warning возможно в будущем изменится обработка момента присвоения делегату
значения nil, как вариант, все запущенные запросы будут отменены.
*/
@property (nonatomic, strong, readwrite) id<VKRequestDelegate> delegate;

/** Пользовательски токен доступа текущего активного пользователя
*/
@property (nonatomic, readonly) VKAccessToken *accessToken;

/** Начинать ли выполнение запросов немедленно или предоставить программисту
самому выбирать момент запуска запроса.
По умолчанию принимает значение YES.

Предположим, что вы хотите осуществить запрос пользовательской информации, но
начало хотите инициировать сами. Вот, как это может выглядеть:

    [VKUser currentUser].startAllRequestsImmediately = NO;
    VKRequest *userInfo = [[VKUser currentUser] info];

    // пользователь нажал какую-то кнопку, после чего вы стартуете запрос
    [userInfo start];

Если нет необходимоти выполнять отложенный запуск, то можно делать следующим образом:

    // запрос стартует немедленно
    [[VKUser currentUser] info];

*/
@property (nonatomic, assign, readwrite) BOOL startAllRequestsImmediately;

/** Оффлайн режим. В данном режиме данные будут запрошены из кэша и возвращены
даже в случае истечения срока их действия (удаления не произойдет).
По умолчанию режим выключен.
*/
@property (nonatomic, assign, readwrite) BOOL offlineMode;

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
@name Пользователи
*/
/** Информация о текущем пользователе.

Следующие поля данных запрашиваются: nickname,screen_name,sex,bdate,has_mobile,online,last_seen,status,photo100

Детальную информацию можно найти по этой ссылке в документации: https://vk.com/dev/users.get

@return экземпляр класса VKRequest, который инкапсулирует в себе все необходимые параметры для
осуществления запроса пользовательской информации. Объект запроса возвращается по причине
возможной необходимости отменить выполнение текущего запроса или отложенное выполнение запроса.
*/
- (VKRequest *)info;

/** Информация о пользователе(ях) с указанными параметрами

Описание параметров и возможные значения можно найти по ссылке: https://vk.com/dev/users.get

@param options ключи-значения, которые будут переданы при запросе методом GET
@return @see info
*/
- (VKRequest *)infoWithCustomOptions:(NSDictionary *)options;

/** Возвращает список пользователей в соответствии с заданным критерием поиска

@param options ключи-значения, с полным списком ключей можно ознакомиться по
ссылке из документации: https://vk.com/dev/users.search
@return @see info
*/
- (VKRequest *)searchWithCustomOptions:(NSDictionary *)options;

/** Возвращает список идентификаторов пользователей и групп, которые входят в список подписок пользователя

@param options ключи-значения, с полным списком ключей можно ознакомиться по
ссылке из документации: https://vk.com/dev/users.getSubscriptions
@return @see info
*/
- (VKRequest *)subscriptionsWithCustomOptions:(NSDictionary *)options;

/** Возвращает список идентификаторов пользователей, которые являются подписчиками пользователя. Идентификаторы пользователей в списке отсортированы в порядке убывания времени их добавления.

@param options ключи-значения, с полным списком ключей можно ознакомиться по
ссылке из документации: https://vk.com/dev/users.getFollowers
@return @see info
*/
- (VKRequest *)followersWithCustomOptions:(NSDictionary *)options;

/**
@name Стена
*/
/** Возвращает список записей со стены пользователя или сообщества

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.get
@return @see info
*/
- (VKRequest *)wallGetWithCustomOptions:(NSDictionary *)options;

/** Возвращает список записей со стен пользователей по их идентификаторам

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.getById
@return @see info
*/
- (VKRequest *)wallGetByIDWithCustomOptions:(NSDictionary *)options;

/** Сохраняет запись на стене пользователя. Запись может содержать фотографию, ранее загруженную на сервер ВКонтакте, или любую доступную фотографию из альбома пользователя.
При запуске со стены приложение открывается в окне размером 607x412 и ему передаются параметры, описанные здесь.

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.savePost
@return @see info
*/
- (VKRequest *)wallSavePostWithCustomOptions:(NSDictionary *)options;

/** Публикует новую запись на своей или чужой стене.
Данный метод позволяет создать новую запись на стене, а также опубликовать предложенную новость или отложенную запись.

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.post
@return @see info
*/
- (VKRequest *)wallPostWithCustomOptions:(NSDictionary *)options;

/** Копирует объект на стену пользователя или сообщества

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.repost
@return @see info
*/
- (VKRequest *)wallRepostWithCustomOptions:(NSDictionary *)options;

/** Позволяет получать список репостов заданной записи

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.getReposts
@return @see info
*/
- (VKRequest *)wallGetRepostsWithCustomOptions:(NSDictionary *)options;

/** Редактирует запись на стене

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.edit
@return @see info
*/
- (VKRequest *)wallEditWithCustomOptions:(NSDictionary *)options;

/** Удаляет запись со стены

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.delete
@return @see info
*/
- (VKRequest *)wallDeleteWithCustomOptions:(NSDictionary *)options;

/** Восстанавливает удаленную запись на стене пользователя

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.restore
@return @see info
*/
- (VKRequest *)wallRestoreWithCustomOptions:(NSDictionary *)options;

/** Возвращает список комментариев к записи на стене пользователя

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.getComments
@return @see info
*/
- (VKRequest *)wallGetCommentsWithCustomOptions:(NSDictionary *)options;

/** Добавляет комментарий к записи на стене пользователя или сообщества

@param options ключи-значения, полный список в документации: http://vk.com/dev/wall.addComment
@return @see info
*/
- (VKRequest *)wallAddCommentWithCustomOptions:(NSDictionary *)options;

/** Удаляет комментарий текущего пользователя к записи на своей или чужой стене

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.deleteComment
@return @see info
*/
- (VKRequest *)wallDeleteCommentWithCustomOptions:(NSDictionary *)options;

/** Восстанавливает комментарий текущего пользователя к записи на своей или чужой стене

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.restoreComment
@return @see info
*/
- (VKRequest *)wallRestoreCommentWithCustomOptions:(NSDictionary *)options;

/**
@name Переопределенные методы
 */
/** Описание текущего пользователя
*/
- (NSString *)description;

@end