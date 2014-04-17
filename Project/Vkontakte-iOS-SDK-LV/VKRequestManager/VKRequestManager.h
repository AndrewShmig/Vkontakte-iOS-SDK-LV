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
#import "VKRequest.h"
#import "VKUser.h"
#import "VKAccessToken.h"


/** Current class gives possibility to perform requests to VK servers.

The most updated information and documentation on methods you can get
from official VK Developers page: https://vk.com/dev/main

Methods which are documented in Russian (in current file) won't be translated
in English, so please refer to VK official English documentation.

Methods covered: 100%.
*/
@interface VKRequestManager : NSObject

/**
@name Properties
*/
/** User from whose face requests are made.

If you need to perform requests without authorizing/specifying any user:

    VKRequestManager *rm = [[VKRequestManager alloc] initWithDelegate:self
                                                                 user:nil];
    [rm info:@{@"user_ids": @"christian.burns"}];

*/
@property (nonatomic, strong, readwrite) VKUser *user;

/** Delegate
*/
@property (nonatomic, weak, readwrite) id <VKRequestDelegate> delegate;


/** Allows developer to initiate immediate request start after its being created.
Defaults to YES.

For instance, you want to request user's information and initiate request when
user taps a button. Here is how it can be implemented:

    VKRequestManager *rm = [[VKRequestManager alloc] init...];
    rm.startAllRequestsImmediately = NO;
    VKRequest *userInfo = [rm info];

User taps a button and this method is called:

    [userInfo start];

If there is no need to perform delayed requests than you should just call needed
method and don't bother about something else. Looks like:

    VKRequestManager *rm = [[VKRequestManager alloc] init...];
    [rm info];
*/
@property (nonatomic, assign, readwrite) BOOL startAllRequestsImmediately;


/** Offline mode, works for all requests. Current mode is used to return cache data even
if its lifetime ended, no deletion occurs (use this mode if no internet connection exists).

Defaults to NO.
*/
@property (nonatomic, assign, readwrite) BOOL offlineMode;

/**
@name Initialization methods
*/
/** Designated initialization method.

@param delegate delegate, should conform to VKRequestDelegate
@param user user from whose face requests are made
*/
- (instancetype)initWithDelegate:(id <VKRequestDelegate>)delegate
                            user:(VKUser *)user;

/** Initialization method.

No access token will be passed to VK during request.

@param delegate delegate, should conform to VKRequestDelegate
*/
- (instancetype)initWithDelegate:(id<VKRequestDelegate>)delegate;

@end

@interface VKRequestManager (User)
/**
@name Users
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
- (VKRequest *)info:(NSDictionary *)options;

/** Возвращает список пользователей в соответствии с заданным критерием поиска

@param options ключи-значения, с полным списком ключей можно ознакомиться по
ссылке из документации: https://vk.com/dev/users.search
@return @see info
*/
- (VKRequest *)search:(NSDictionary *)options;

/** Возвращает список идентификаторов пользователей и групп, которые входят в список подписок пользователя

@param options ключи-значения, с полным списком ключей можно ознакомиться по
ссылке из документации: https://vk.com/dev/users.getSubscriptions
@return @see info
*/
- (VKRequest *)subscriptions:(NSDictionary *)options;

/** Возвращает список идентификаторов пользователей, которые являются подписчиками пользователя. Идентификаторы пользователей в списке отсортированы в порядке убывания времени их добавления.

@param options ключи-значения, с полным списком ключей можно ознакомиться по
ссылке из документации: https://vk.com/dev/users.getFollowers
@return @see info
*/
- (VKRequest *)followers:(NSDictionary *)options;

/** Возвращает информацию о том, установил ли пользователь приложение.

@param options ключи-значения, подробнее https://vk.com/dev/users.isAppUser
@return @see info
*/
- (VKRequest *)isAppUser:(NSDictionary *)options;

@end

@interface VKRequestManager (Wall)

/**
@name Wall
*/
/** Возвращает список записей со стены пользователя или сообщества

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.get
@return @see info
*/
- (VKRequest *)wallGet:(NSDictionary *)options;

/** Возвращает список записей со стен пользователей по их идентификаторам

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.getById
@return @see info
*/
- (VKRequest *)wallGetByID:(NSDictionary *)options;

/** Сохраняет запись на стене пользователя. Запись может содержать фотографию, ранее загруженную на сервер ВКонтакте, или любую доступную фотографию из альбома пользователя.
При запуске со стены приложение открывается в окне размером 607x412 и ему передаются параметры, описанные здесь.

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.savePost
@return @see info
*/
- (VKRequest *)wallSavePost:(NSDictionary *)options;

/** Публикует новую запись на своей или чужой стене.
Данный метод позволяет создать новую запись на стене, а также опубликовать предложенную новость или отложенную запись.

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.post
@return @see info
*/
- (VKRequest *)wallPost:(NSDictionary *)options;

/** Копирует объект на стену пользователя или сообщества

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.repost
@return @see info
*/
- (VKRequest *)wallRepost:(NSDictionary *)options;

/** Позволяет получать список репостов заданной записи

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.getReposts
@return @see info
*/
- (VKRequest *)wallGetReposts:(NSDictionary *)options;

/** Редактирует запись на стене

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.edit
@return @see info
*/
- (VKRequest *)wallEdit:(NSDictionary *)options;

/** Удаляет запись со стены

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.delete
@return @see info
*/
- (VKRequest *)wallDelete:(NSDictionary *)options;

/** Восстанавливает удаленную запись на стене пользователя

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.restore
@return @see info
*/
- (VKRequest *)wallRestore:(NSDictionary *)options;

/** Возвращает список комментариев к записи на стене пользователя

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.getComments
@return @see info
*/
- (VKRequest *)wallGetComments:(NSDictionary *)options;

/** Добавляет комментарий к записи на стене пользователя или сообщества

@param options ключи-значения, полный список в документации: http://vk.com/dev/wall.addComment
@return @see info
*/
- (VKRequest *)wallAddComment:(NSDictionary *)options;

/** Удаляет комментарий текущего пользователя к записи на своей или чужой стене

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.deleteComment
@return @see info
*/
- (VKRequest *)wallDeleteComment:(NSDictionary *)options;

/** Восстанавливает комментарий текущего пользователя к записи на своей или чужой стене

@param options ключи-значения, полный список в документации: https://vk.com/dev/wall.restoreComment
@return @see info
*/
- (VKRequest *)wallRestoreComment:(NSDictionary *)options;

@end

@interface VKRequestManager (Photos)

/**
@name Photos
*/
/** Создает пустой альбом для фотографий

@param options ключи-значения, полный список по ссылке: https://vk.com/dev/photos.createAlbum
@return @see info
*/
- (VKRequest *)photosCreateAlbum:(NSDictionary *)options;

/** Редактирует данные альбома для фотографий пользователя

@param options ключи-значения, полный список по ссылке: https://vk.com/dev/photos.editAlbum
@return @see info
*/
- (VKRequest *)photosEditAlbum:(NSDictionary *)options;

/** Возвращает список альбомов пользователя или сообщества

@param options ключи-значения, полный список по ссылке: https://vk.com/dev/photos.getAlbums
@return @see info
*/
- (VKRequest *)photosGetAlbums:(NSDictionary *)options;

/** Возвращает список фотографий в альбоме

@param options ключи-значения, полный список по ссылке: https://vk.com/dev/photos.get
@return @see info
*/
- (VKRequest *)photosGet:(NSDictionary *)options;

/** Возвращает количество доступных альбомов пользователя

@param options ключи-значения, полный список по ссылке: https://vk.com/dev/photos.getAlbumsCount
@return @see info
*/
- (VKRequest *)photosGetAlbumsCount:(NSDictionary *)options;

/** Возвращает список фотографий со страницы пользователя или сообщества

@param options ключи-значения, полный список по ссылке: https://vk.com/dev/photos.getProfile
@return @see info
*/
- (VKRequest *)photosGetProfile:(NSDictionary *)options;

/** Возвращает информацию о фотографиях по их идентификаторам

@param options ключи-значения, полный список по этой ссылке: https://vk.com/dev/photos.getById
@return @see info
*/
- (VKRequest *)photosGetByID:(NSDictionary *)options;

/** Возвращает адрес сервера для загрузки фотографий

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.getUploadServer
@return @see info
*/
- (VKRequest *)photosGetUploadServer:(NSDictionary *)options;

/** Возвращает адрес сервера для загрузки фотографии на страницу пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.getProfileUploadServer
@return @see info
*/
- (VKRequest *)photosGetProfileUploadServer:(NSDictionary *)options;

/** Позволяет получить адрес для загрузки фотографий мультидиалогов

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.getChatUploadServer
@return @see info
*/
- (VKRequest *)photosGetChatUploadServer:(NSDictionary *)options;

/** Сохраняет фотографию пользователя после успешной загрузки

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.saveProfilePhoto
@return @see info
*/
- (VKRequest *)photosSaveProfilePhoto:(NSDictionary *)options;

/** Сохраняет фотографии после успешной загрузки на URI, полученный методом photos.getWallUploadServer

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.saveWallPhoto
@return @see info
*/
- (VKRequest *)photosSaveWallPhoto:(NSDictionary *)options;

/** Возвращает адрес сервера для загрузки фотографии на стену пользователя.

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.getWallUploadServer
@return @see info
*/
- (VKRequest *)photosGetWallUploadServer:(NSDictionary *)options;

/** Возвращает адрес сервера для загрузки фотографии в личное сообщение пользователю

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.getMessagesUploadServer
@return @see info
*/
- (VKRequest *)photosGetMessagesUploadServer:(NSDictionary *)options;

/** Сохраняет фотографию после успешной загрузки на URI, полученный методом photos.getMessagesUploadServer

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.saveMessagesPhoto
@return @see info
*/
- (VKRequest *)photosSaveMessagesPhoto:(NSDictionary *)options;

/** Осуществляет поиск изображений по местоположению или описанию

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.search
@return @see info
*/
- (VKRequest *)photosSearch:(NSDictionary *)options;

/** Сохраняет фотографии после успешной загрузки

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.save
@return @see info
*/
- (VKRequest *)photosSave:(NSDictionary *)options;

/** Изменяет описание у выбранной фотографии

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.edit
@return @see info
*/
- (VKRequest *)photosEdit:(NSDictionary *)options;

/** Переносит фотографию из одного альбома в другой

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.move
@return @see info
*/
- (VKRequest *)photosMove:(NSDictionary *)options;

/** Делает фотографию обложкой альбома

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.makeCover
@return @see info
*/
- (VKRequest *)photosMakeCover:(NSDictionary *)options;

/** Меняет порядок альбома в списке альбомов пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.reorderAlbums
@return @see info
*/
- (VKRequest *)photosReorderAlbums:(NSDictionary *)options;

/** Меняет порядок фотографии в списке фотографий альбома пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.reorderPhotos
@return @see info
*/
- (VKRequest *)photosReorderPhotos:(NSDictionary *)options;

/** Возвращает все фотографии пользователя или сообщества в антихронологическом порядке

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.getAll
@return @see info
*/
- (VKRequest *)photosGetAll:(NSDictionary *)options;

/** Возвращает список фотографий, на которых отмечен пользователь

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.getUserPhotos
@return @see info
*/
- (VKRequest *)photosGetUserPhotos:(NSDictionary *)options;

/** Удаляет указанный альбом для фотографий у текущего пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.deleteAlbum
@return @see info
*/
- (VKRequest *)photosDeleteAlbum:(NSDictionary *)options;

/** Удаление фотографии на сайте

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.delete
@return @see info
*/
- (VKRequest *)photosDelete:(NSDictionary *)options;

/** Подтверждает отметку на фотографии

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.confirmTag
@return @see info
*/
- (VKRequest *)photosConfirmTagWithCustomOptions:(NSDictionary *)options;

/** Возвращает список комментариев к фотографии

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.getComments
@return @see info
*/
- (VKRequest *)photosGetComments:(NSDictionary *)options;

/** Возвращает отсортированный в антихронологическом порядке список всех комментариев к конкретному альбому или ко всем альбомам пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.getAllComments
@return @see info
*/
- (VKRequest *)photosGetAllComments:(NSDictionary *)options;

/** Создает новый комментарий к фотографии

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.createComment
@return @see info
*/
- (VKRequest *)photosCreateComment:(NSDictionary *)options;

/** Удаляет комментарий к фотографии

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.deleteComment
@return @see info
*/
- (VKRequest *)photosDeleteComment:(NSDictionary *)options;

/** Восстанавливает удаленный комментарий к фотографии

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.restoreComment
@return @see info
*/
- (VKRequest *)photosRestoreComment:(NSDictionary *)options;

/** Изменяет текст комментария к фотографии

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.editComment
@return @see info
*/
- (VKRequest *)photosEditComment:(NSDictionary *)options;

/** Возвращает список отметок на фотографии

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.getTags
@return @see info
*/
- (VKRequest *)photosGetTags:(NSDictionary *)options;

/** Добавляет отметку на фотографию

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.putTag
@return @see info
*/
- (VKRequest *)photosPutTag:(NSDictionary *)options;

/** Удаляет отметку с фотографии

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.removeTag
@return @see info
*/
- (VKRequest *)photosRemoveTag:(NSDictionary *)options;

/** Возвращает список фотографий, на которых есть непросмотренные отметки

@param options ключи-значения, полный список здесь: https://vk.com/dev/photos.getNewTags
@return @see info
*/
- (VKRequest *)photosGetNewTags:(NSDictionary *)options;

@end

@interface VKRequestManager (Friends)

/**
@name Friends
*/
/** Возвращает список идентификаторов друзей пользователя или расширенную информацию о друзьях пользователя (при использовании параметра fields)

@param options ключи-значения, полный список по этой ссылке: https://vk.com/dev/friends.get
@return @see info
*/
- (VKRequest *)friendsGet:(NSDictionary *)options;

/** Возвращает список идентификаторов друзей пользователя, находящихся на сайте

@param options ключи-значения, полный список по этой ссылке: https://vk.com/dev/friends.getOnline
@return @see info
*/
- (VKRequest *)friendsGetOnline:(NSDictionary *)options;

/** Возвращает список идентификаторов общих друзей между парой пользователей

@param options ключи-значения, полный список по этой ссылке: https://vk.com/dev/friends.getMutual
@return @see info
*/
- (VKRequest *)friendsGetMutual:(NSDictionary *)options;

/** Возвращает список идентификаторов недавно добавленных друзей текущего пользователя

@param options ключи-значения, полный список по этой ссылке: https://vk.com/dev/friends.getRecent
@return @see info
*/
- (VKRequest *)friendsGetRecent:(NSDictionary *)options;

/** Возвращает информацию о полученных или отправленных заявках на добавление в друзья для текущего пользователя

@param options ключи-значения, полный список по этой ссылке: https://vk.com/dev/friends.getRequests
@return @see info
*/
- (VKRequest *)friendsGetRequests:(NSDictionary *)options;

/** Одобряет или создает заявку на добавление в друзья.

Если идентификатор выбранного пользователя присутствует в списке заявок на добавление в друзья, полученном методом friends.getRequests, то одобряет заявку на добавление и добавляет выбранного пользователя в друзья к текущему пользователю. В противном случае создает заявку на добавление в друзья текущего пользователя к выбранному пользователю.

@param options ключи-значения, полный список по этой ссылке: https://vk.com/dev/friends.add
@return @see info
*/
- (VKRequest *)friendsAdd:(NSDictionary *)options;

/** Редактирует списки друзей для выбранного друга

@param options ключи-значения, полный список по этой ссылке: https://vk.com/dev/friends.edit
@return @see info
*/
- (VKRequest *)friendsEdit:(NSDictionary *)options;

/** Удаляет пользователя из списка друзей или отклоняет заявку в друзья

Если идентификатор выбранного пользователя присутствует в списке заявок на добавление в друзья, полученном методом friends.getRequests, то отклоняет заявку на добавление в друзья к текущему пользователю. В противном случае удаляет выбранного пользователя из списка друзей текущего пользователя, который может быть получен методом friends.get

@param options ключи-значения, полный список по этой ссылке: https://vk.com/dev/friends.delete
@return @see info
*/
- (VKRequest *)friendsDelete:(NSDictionary *)options;

/** Возвращает список меток друзей текущего пользователя

@param options ключи-значения, полный список по этой ссылке: https://vk.com/dev/friends.getLists
@return @see info
*/
- (VKRequest *)friendsGetLists:(NSDictionary *)options;

/** Создает новый список друзей у текущего пользователя

@param options ключи-значения, полный список по этой ссылке: https://vk.com/dev/friends.addList
@return @see info
*/
- (VKRequest *)friendsAddList:(NSDictionary *)options;

/** Редактирует существующий список друзей текущего пользователя

@param options ключи-значения, полный список по этой ссылке: https://vk.com/dev/friends.editList
@return @see info
*/
- (VKRequest *)friendsEditList:(NSDictionary *)options;

/** Удаляет существующий список друзей текущего пользователя

@param options ключи-значения, полный список по этой ссылке: https://vk.com/dev/friends.deleteList
@return @see info
*/
- (VKRequest *)friendsDeleteList:(NSDictionary *)options;

/** Возвращает список идентификаторов друзей текущего пользователя, которые установили данное приложение

@param options ключи-значения, полный список по этой ссылке: https://vk.com/dev/friends.getAppUsers
@return @see info
*/
- (VKRequest *)friendsGetAppUsers:(NSDictionary *)options;

/** Возвращает список друзей пользователя, у которых завалидированные или указанные в профиле телефонные номера входят в заданный список.

Использование данного метода возможно только если у текущего пользователя завалидирован номер мобильного телефона. Для проверки этого условия можно использовать метод users.get c параметрами uids=API_USER и fields=has_mobile, где API_USER равен идентификатору текущего пользователя.

@param options ключи-значения, полный список по этой ссылке: https://vk.com/dev/friends.getByPhones
@return @see info
*/
- (VKRequest *)friendsGetByPhones:(NSDictionary *)options;

/** Отмечает все входящие заявки на добавление в друзья как просмотренные

@param options ключи-значения, полный список по этой ссылке: https://vk.com/dev/friends.deleteAllRequests
@return @see info
*/
- (VKRequest *)friendsDeleteAllRequests:(NSDictionary *)options;

/** Возвращает список профилей пользователей, которые могут быть друзьями текущего пользователя.

@param options ключи-значения, полный список по этой ссылке: https://vk.com/dev/friends.getSuggestions
@return @see info
*/
- (VKRequest *)friendsGetSuggestions:(NSDictionary *)options;

/** Возвращает информацию о том, добавлен ли текущий пользователь в друзья у указанных пользователей.

@param options ключи-значения, полный список по ссылке: https://vk.com/dev/friends.areFriends
@return @see info
*/
- (VKRequest *)friendsAreFriends:(NSDictionary *)options;

@end

@interface VKRequestManager (Groups)

/**
@name Groups
*/
/** Возвращает информацию о том, является ли пользователь участником сообщества

@param options ключи-значения, полный список в документации: https://vk.com/dev/groups.isMember
@return @see info
*/
- (VKRequest *)groupsIsMember:(NSDictionary *)options;

/** Возвращает информацию о заданном сообществе или о нескольких сообществах

@param options ключи-значения, полный список в документации: https://vk.com/dev/groups.getById
@return @see info
*/
- (VKRequest *)groupsGetByID:(NSDictionary *)options;

/** Возвращает список сообществ указанного пользователя

@param options ключи-значения, полный список в документации: https://vk.com/dev/groups.get
@return @see info
*/
- (VKRequest *)groupsGet:(NSDictionary *)options;

/** Возвращает список участников сообщества

@param options ключи-значения, полный список в документации: https://vk.com/dev/groups.getMembers
@return @see info
*/
- (VKRequest *)groupsGetMembers:(NSDictionary *)options;

/** Данный метод позволяет вступить в группу, публичную страницу, а также подтвердить участие во встрече.

@param options ключи-значения, полный список в документации: https://vk.com/dev/groups.join
@return @see info
*/
- (VKRequest *)groupsJoin:(NSDictionary *)options;

/** Данный метод позволяет выходить из группы, публичной страницы, или встречи

@param options ключи-значения, полный список в документации: https://vk.com/dev/groups.leave
@return @see info
*/
- (VKRequest *)groupsLeave:(NSDictionary *)options;

/** Осуществляет поиск сообществ по заданной подстроке

@param options ключи-значения, полный список в документации: https://vk.com/dev/groups.search
@return @see info
*/
- (VKRequest *)groupsSearch:(NSDictionary *)options;

/** Данный метод возвращает список приглашений в сообщества и встречи

@param options ключи-значения, полный список в документации: https://vk.com/dev/groups.getInvites
@return @see info
*/
- (VKRequest *)groupsGetInvites:(NSDictionary *)options;

/** Добавляет пользователя в черный список группы

@param options ключи-значения, полный список в документации: https://vk.com/dev/groups.banUser
@return @see info
*/
- (VKRequest *)groupsBanUser:(NSDictionary *)options;

/** Убирает пользователя из черного списка группы

@param options ключи-значения, полный список в документации: https://vk.com/dev/groups.unbanUser
@return @see info
*/
- (VKRequest *)groupsUnbanUser:(NSDictionary *)options;

/** Возвращает список забаненных пользователей

@param options ключи-значения, полный список в документации: https://vk.com/dev/groups.getBanned
@return @see info
*/
- (VKRequest *)groupsGetBanned:(NSDictionary *)options;

@end

@interface VKRequestManager (Video)

/**
@name Video
*/
/** Возвращает информацию о видеозаписях

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.get
@return @see info
*/
- (VKRequest *)videoGet:(NSDictionary *)options;

/** Редактирует данные видеозаписи на странице пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.edit
@return @see info
*/
- (VKRequest *)videoEdit:(NSDictionary *)options;

/** Добавляет видеозапись в список пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.add
@return @see info
*/
- (VKRequest *)videoAdd:(NSDictionary *)options;

/** Возвращает адрес сервера (необходимый для загрузки) и данные видеозаписи.

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.save
@return @see info
*/
- (VKRequest *)videoSave:(NSDictionary *)options;

/** Удаляет видеозапись со страницы пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.delete
@return @see info
*/
- (VKRequest *)videoDelete:(NSDictionary *)options;

/** Восстанавливает удаленную видеозапись

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.restore
@return @see info
*/
- (VKRequest *)videoRestore:(NSDictionary *)options;

/** Возвращает список видеозаписей в соответствии с заданным критерием поиска

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.search
@return @see info
*/
- (VKRequest *)videoSearch:(NSDictionary *)options;

/** Возвращает список видеозаписей, на которых отмечен пользователь

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.getUserVideos
@return @see info
*/
- (VKRequest *)videoGetUserVideos:(NSDictionary *)options;

/** Возвращает список альбомов видеозаписей пользователя или сообщества

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.getAlbums
@return @see info
*/
- (VKRequest *)videoGetAlbums:(NSDictionary *)options;

/** Создает пустой альбом видеозаписей

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.addAlbum
@return @see info
*/
- (VKRequest *)videoAddAlbum:(NSDictionary *)options;

/** Редактирует название альбома видеозаписей

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.editAlbum
@return @see info
*/
- (VKRequest *)videoEditAlbum:(NSDictionary *)options;

/** Удаляет альбом видеозаписей

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.deleteAlbum
@return @see info
*/
- (VKRequest *)videoDeleteAlbum:(NSDictionary *)options;

/** Перемещает видеозаписи в альбом

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.moveToAlbum
@return @see info
*/
- (VKRequest *)videoMoveToAlbum:(NSDictionary *)options;

/** Возвращает список комментариев к видеозаписи

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.getComments
@return @see info
*/
- (VKRequest *)videoGetComments:(NSDictionary *)options;

/** Cоздает новый комментарий к видеозаписи

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.createComment
@return @see info
*/
- (VKRequest *)videoCreateComment:(NSDictionary *)options;

/** Удаляет комментарий к видеозаписи.

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.deleteComment
@return @see info
*/
- (VKRequest *)videoDeleteComment:(NSDictionary *)options;

/** Восстанавливает удаленный комментарий к видеозаписи

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.restoreComment
@return @see info
*/
- (VKRequest *)videoRestoreComment:(NSDictionary *)options;

/** Изменяет текст комментария к видеозаписи

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.editComment
@return @see info
*/
- (VKRequest *)videoEditComment:(NSDictionary *)options;

/** Возвращает список отметок на видеозаписи

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.getTags
@return @see info
*/
- (VKRequest *)videoGetTags:(NSDictionary *)options;

/** Добавляет отметку на видеозапись

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.putTag
@return @see info
*/
- (VKRequest *)videoPutTag:(NSDictionary *)options;

/** Удаляет отметку с видеозаписи

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.removeTag
@return @see info
*/
- (VKRequest *)videoRemoveTag:(NSDictionary *)options;

/** Возвращает список видеозаписей, на которых есть непросмотренные отметки

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.getNewTags
@return @see info
*/
- (VKRequest *)videoGetNewTags:(NSDictionary *)options;

/** Позволяет пожаловаться на видеозапись

@param options ключи-значения, полный список здесь: https://vk.com/dev/video.report
@return @see info
*/
- (VKRequest *)videoReport:(NSDictionary *)options;

@end

@interface VKRequestManager (Audio)

/**
@name Audio
*/
/** Возвращает список аудиозаписей пользователя или сообщества

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.get
@return @see info
*/
- (VKRequest *)audioGet:(NSDictionary *)options;

/** Возвращает информацию об аудиозаписях

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.getById
@return @see info
*/
- (VKRequest *)audioGetByID:(NSDictionary *)options;

/** Возвращает текст аудиозаписи

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.getLyrics
@return @see info
*/
- (VKRequest *)audioGetLyrics:(NSDictionary *)options;

/** Возвращает список аудиозаписей в соответствии с заданным критерием поиска

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.search
@return @see info
*/
- (VKRequest *)audioSearch:(NSDictionary *)options;

/** Возвращает адрес сервера для загрузки аудиозаписей

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.getUploadServer
@return @see info
*/
- (VKRequest *)audioGetUploadServer:(NSDictionary *)options;

/** Сохраняет аудиозаписи после успешной загрузки

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.save
@return @see info
*/
- (VKRequest *)audioSave:(NSDictionary *)options;

/** Копирует аудиозапись на страницу пользователя или группы

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.add
@return @see info
*/
- (VKRequest *)audioAdd:(NSDictionary *)options;

/** Удаляет аудиозапись со страницы пользователя или сообщества

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.delete
@return @see info
*/
- (VKRequest *)audioDelete:(NSDictionary *)options;

/** Редактирует данные аудиозаписи на странице пользователя или сообщества

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.edit
@return @see info
*/
- (VKRequest *)audioEdit:(NSDictionary *)options;

/** Изменяет порядок аудиозаписи, перенося ее между аудиозаписями, идентификаторы которых переданы параметрами after и before

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.reorder
@return @see info
*/
- (VKRequest *)audioReorder:(NSDictionary *)options;

/** Восстанавливает аудиозапись после удаления

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.restore
@return @see info
*/
- (VKRequest *)audioRestore:(NSDictionary *)options;

/** Возвращает список альбомов аудиозаписей пользователя или группы

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.getAlbums
@return @see info
*/
- (VKRequest *)audioGetAlbums:(NSDictionary *)options;

/** Создает пустой альбом аудиозаписей

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.addAlbum
@return @see info
*/
- (VKRequest *)audioAddAlbum:(NSDictionary *)options;

/** Редактирует название альбома аудиозаписей

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.editAlbum
@return @see info
*/
- (VKRequest *)audioEditAlbum:(NSDictionary *)options;

/** Удаляет альбом аудиозаписей

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.deleteAlbum
@return @see info
*/
- (VKRequest *)audioDeleteAlbum:(NSDictionary *)options;

/** Перемещает аудиозаписи в альбом

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.moveToAlbum
@return @see info
*/
- (VKRequest *)audioMoveToAlbum:(NSDictionary *)options;

/** Транслирует аудиозапись в статус пользователю или сообществу

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.setBroadcast
@return @see info
*/
- (VKRequest *)audioSetBroadcast:(NSDictionary *)options;

/** Возвращает список друзей и сообществ пользователя, которые транслируют музыку в статус

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.getBroadcastList
@return @see info
*/
- (VKRequest *)audioGetBroadcastList:(NSDictionary *)options;

/** Возвращает список рекомендуемых аудиозаписей на основе списка воспроизведения заданного пользователя или на основе одной выбранной аудиозаписи

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.getRecommendations
@return @see info
*/
- (VKRequest *)audioGetRecommendations:(NSDictionary *)options;

/** Возвращает список аудиозаписей из раздела "Популярное"

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.getPopular
@return @see info
*/
- (VKRequest *)audioGetPopular:(NSDictionary *)options;

/** Возвращает количество аудиозаписей пользователя или сообщества

@param options ключи-значения, полный список здесь: https://vk.com/dev/audio.getCount
@return @see info
*/
- (VKRequest *)audioGetCount:(NSDictionary *)options;

@end

@interface VKRequestManager (Messages)

/**
@name Messages
*/
/** Возвращает список входящих либо исходящих личных сообщений текущего пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.get
@return @see info
*/
- (VKRequest *)messagesGet:(NSDictionary *)options;

/** Возвращает список диалогов текущего пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.getDialogs
@return @see info
*/
- (VKRequest *)messagesGetDialogs:(NSDictionary *)options;

/** Возвращает сообщения по их id

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.getById
@return @see info
*/
- (VKRequest *)messagesGetByID:(NSDictionary *)options;

/** Возвращает список найденных личных сообщений текущего пользователя по введенной строке поиска

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.search
@return @see info
*/
- (VKRequest *)messagesSearch:(NSDictionary *)options;

/** Возвращает историю сообщений для указанного пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.getHistory
@return @see info
*/
- (VKRequest *)messagesGetHistory:(NSDictionary *)options;

/** Отправляет сообщение

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.send
@return @see info
*/
- (VKRequest *)messagesSend:(NSDictionary *)options;

/** Удаляет сообщение

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.delete
@return @see info
*/
- (VKRequest *)messagesDelete:(NSDictionary *)options;

/** Удаляет все личные сообщения в диалоге

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.deleteDialog
@return @see info
*/
- (VKRequest *)messagesDeleteDialog:(NSDictionary *)options;

/** Восстанавливает удаленное сообщение

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.restore
@return @see info
*/
- (VKRequest *)messagesRestore:(NSDictionary *)options;

/** Помечает сообщения как непрочитанные

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.markAsNew
@return @see info
*/
- (VKRequest *)messagesMarkAsNew:(NSDictionary *)options;

/** Помечает сообщения как прочитанные

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.markAsRead
@return @see info
*/
- (VKRequest *)messagesMarkAsRead:(NSDictionary *)options;

/** Помечает сообщения как важные либо снимает отметку

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.markAsImportant
@return @see info
*/
- (VKRequest *)messagesMarkAsImportant:(NSDictionary *)options;

/** Возвращает данные, необходимые для подключения к Long Poll серверу

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.getLongPollServer
*/
- (VKRequest *)messagesGetLongPollServer:(NSDictionary *)options;

/** Возвращает обновления в личных сообщениях пользователя

Для ускорения работы с личными сообщениями может быть полезно кешировать уже загруженные ранее сообщения на мобильном устройстве / ПК пользователя, чтобы не получать их повторно при каждом обращении. Этот метод помогает осуществить синхронизацию локальной копии списка сообщений с актуальной версией.

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.getLongPollHistory
@return @see info
*/
- (VKRequest *)messagesGetLongPollHistory:(NSDictionary *)options;

/** Возвращает информацию о беседе

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.getChat
@return @see info
*/
- (VKRequest *)messagesGetChat:(NSDictionary *)options;

/** Создаёт беседу с несколькими участниками

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.createChat
@return @see info
*/
- (VKRequest *)messagesCreateChat:(NSDictionary *)options;

/** Изменяет название беседы

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.editChat
@return @see info
*/
- (VKRequest *)messagesEditChat:(NSDictionary *)options;

/** Позволяет получить список пользователей мультидиалога по его id

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.getChatUsers
@return @see info
*/
- (VKRequest *)messagesGetChatUsers:(NSDictionary *)options;

/** Изменяет статус набора текста пользователем в диалоге

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.setActivity
@return @see info
*/
- (VKRequest *)messagesSetActivity:(NSDictionary *)options;

/** Возвращает список найденных диалогов текущего пользователя по введенной строке поиска

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.searchDialogs
@return @see info
*/
- (VKRequest *)messagesSearchDialogs:(NSDictionary *)options;

/** Добавляет в мультидиалог нового пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.addChatUser
*/
- (VKRequest *)messagesAddChatUser:(NSDictionary *)options;

/** Исключает из мультидиалога пользователя, если текущий пользователь был создателем беседы либо пригласил исключаемого пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.removeChatUser
*/
- (VKRequest *)messagesRemoveChatUser:(NSDictionary *)options;

/** Возвращает текущий статус и дату последней активности указанного пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.getLastActivity
@return @see info
*/
- (VKRequest *)messagesGetLastActivity:(NSDictionary *)options;

/** Позволяет установить фотографию мультидиалога, загруженную с помощью метода photos.getChatUploadServer

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.setChatPhoto
@return @see info
*/
- (VKRequest *)messagesSetChatPhoto:(NSDictionary *)options;

/** Позволяет удалить фотографию мультидиалога

@param options ключи-значения, полный список здесь: https://vk.com/dev/messages.deleteChatPhoto
@return @see info
*/
- (VKRequest *)messagesDeleteChatPhoto:(NSDictionary *)options;

@end

@interface VKRequestManager (Newsfeed)

/**
@name Newsfeed
*/
/** Возвращает данные, необходимые для показа списка новостей для текущего пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/newsfeed.get
@return @see info
*/
- (VKRequest *)newsfeedGet:(NSDictionary *)options;

/** Получает список новостей, рекомендованных пользователю

@param options ключи-значения, полный список здесь: https://vk.com/dev/newsfeed.getRecommended
@return @see info
*/
- (VKRequest *)newsfeedGetRecommended:(NSDictionary *)options;

/** Возвращает данные, необходимые для показа раздела комментариев в новостях пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/newsfeed.getComments
@return @see info
*/
- (VKRequest *)newsfeedGetComments:(NSDictionary *)options;

/** Возвращает список записей пользователей на своих стенах, в которых упоминается указанный пользователь

@param options ключи-значения, полный список здесь: https://vk.com/dev/newsfeed.getMentions
@return @see info
*/
- (VKRequest *)newsfeedGetMentions:(NSDictionary *)options;

/** Возвращает список пользователей и групп, которые текущий пользователь скрыл из ленты новостей

@param options ключи-значения, полный список здесь: https://vk.com/dev/newsfeed.getBanned
@return @see info
*/
- (VKRequest *)newsfeedGetBanned:(NSDictionary *)options;

/** Запрещает показывать новости от заданных пользователей и групп в ленте новостей текущего пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/newsfeed.addBan
@return @see info
*/
- (VKRequest *)newsfeedAddBan:(NSDictionary *)options;

/** Разрешает показывать новости от заданных пользователей и групп в ленте новостей текущего пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/newsfeed.deleteBan
@return @see info
*/
- (VKRequest *)newsfeedDeleteBan:(NSDictionary *)options;

/** Возвращает результаты поиска по статусам

@param options ключи-значения, полный список здесь: https://vk.com/dev/newsfeed.search
@return @see info
*/
- (VKRequest *)newsfeedSearch:(NSDictionary *)options;

/** Возвращает пользовательские списки новостей

@param options ключи-значения, полный список здесь: https://vk.com/dev/newsfeed.getLists
*/
- (VKRequest *)newsfeedGetLists:(NSDictionary *)options;

/** Отписывает текущего пользователя от комментариев к заданному объекту

@param options ключи-значения, полный список здесь: https://vk.com/dev/newsfeed.unsubscribe
@return @see info
*/
- (VKRequest *)newsfeedUnsubscribe:(NSDictionary *)options;

@end

@interface VKRequestManager (Likes)

/**
@name Likes
*/
/** Получает список идентификаторов пользователей, которые добавили заданный объект в свой список Мне нравится.

@param options ключи-значения, полный список здесь: https://vk.com/dev/likes.getList
@return @see info
*/
- (VKRequest *)likesGetList:(NSDictionary *)options;

/** Добавляет указанный объект в список Мне нравится текущего пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/likes.add
@return @see info
*/
- (VKRequest *)likesAdd:(NSDictionary *)options;

/** Удаляет указанный объект из списка Мне нравится текущего пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/likes.delete
@return @see info
*/
- (VKRequest *)likesDelete:(NSDictionary *)options;

/** Проверяет, находится ли объект в списке Мне нравится заданного пользователя.

@param options ключи-значения, полный список здесь: https://vk.com/dev/likes.isLiked
@return @see info
*/
- (VKRequest *)likesIsLiked:(NSDictionary *)options;

@end

@interface VKRequestManager (Account)

/**
@name Account
*/
/** Возвращает ненулевые значения счетчиков пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/account.getCounters
@return @see info
*/
- (VKRequest *)accountGetCounters:(NSDictionary *)options;

/** Устанавливает короткое название приложения (до 17 символов), которое выводится пользователю в левом меню.

@param options ключи-значения, полный список здесь: https://vk.com/dev/account.setNameInMenu
@return @see info
*/
- (VKRequest *)accountSetNameInMenu:(NSDictionary *)options;

/** Помечает текущего пользователя как online на 15 минут.

@param options ключи-значения, полный список здесь: https://vk.com/dev/account.setOnline
@return @see info
*/
- (VKRequest *)accountSetOnline:(NSDictionary *)options;

/** Принимает список контактов пользователя для поиска зарегистрированных во ВКонтакте пользователей методом friends.getSuggestions.

@param options ключи-значения, полный список здесь: https://vk.com/dev/account.importContacts
@return @see info
*/
- (VKRequest *)accountImportContacts:(NSDictionary *)options;

/** Подписывает устройство на базе iOS, Android иди Windows Phone на получение Push-уведомлений.

@param options ключи-значения, полный список здесь: https://vk.com/dev/account.registerDevice
@return @see info
*/
- (VKRequest *)accountRegisterDevice:(NSDictionary *)options;

/** Отписывает устройство от Push уведомлений.

@param options ключи-значения, полный список здесь: https://vk.com/dev/account.unregisterDevice
@return @see info
*/
- (VKRequest *)accountUnregisterDevice:(NSDictionary *)options;

/** Отключает push-уведомления на заданный промежуток времени.

@param options ключи-значения, полный список здесь: https://vk.com/dev/account.setSilenceMode
@return @see info
*/
- (VKRequest *)accountSetSilenceMode:(NSDictionary *)options;

/** Позволяет получать настройки Push уведомлений.

@param options ключи-значения, полный список здесь: https://vk.com/dev/account.getPushSettings
@return @see info
*/
- (VKRequest *)accountGetPushSettings:(NSDictionary *)options;

/** Получает настройки текущего пользователя в данном приложении.

@param options ключи-значения, полный список здесь: https://vk.com/dev/account.getAppPermissions
@return @see info
*/
- (VKRequest *)accountGetAppPermissions:(NSDictionary *)options;

/** Возвращает список активных рекламных предложений (офферов), выполнив которые пользователь сможет получить соответствующее количество голосов на свой счёт внутри приложения.

@param options ключи-значения, полный список здесь: https://vk.com/dev/account.getActiveOffers
@return @see info
*/
- (VKRequest *)accountGetActiveOffers:(NSDictionary *)options;

/** Добавляет пользователя в черный список.

@param options ключи-значения, полный список здесь: https://vk.com/dev/account.banUser
@return @see info
*/
- (VKRequest *)accountBanUser:(NSDictionary *)options;

/** Убирает пользователя из черного списка.

@param options ключи-значения, полный список здесь: https://vk.com/dev/account.unbanUser
@return @see info
*/
- (VKRequest *)accountUnbanUser:(NSDictionary *)options;

/** Возвращает список пользователей, находящихся в черном списке.

@param options ключи-значения, полный список здесь: https://vk.com/dev/account.getBanned
@return @see info
*/
- (VKRequest *)accountGetBanned:(NSDictionary *)options;

/** Метод для валидации пользователя (страница security check, документация: https://vk.com/dev/need_validation )

@param options ключи-значения, метод отсутствует в документации (спец.метод)
*/
- (VKRequest *)accountTestValidation:(NSDictionary *)options;

@end

@interface VKRequestManager (Status)

/**
@name Status
*/
/** Получает текст статуса пользователя или сообщества.

@param options ключи-значения, полный список здесь: https://vk.com/dev/status.get
@return @see info
*/
- (VKRequest *)statusGet:(NSDictionary *)options;

/** Устанавливает новый статус текущему пользователю.

@param options ключи-значения, полный список здесь: https://vk.com/dev/status.set
@return @see info
*/
- (VKRequest *)statusSet:(NSDictionary *)options;

@end

@interface VKRequestManager (Pages)

/**
@name Pages
*/
/** Возвращает информацию о вики-странице.

@param options ключи-значения, полный список здесь: https://vk.com/dev/pages.get
@return @see info
*/
- (VKRequest *)pagesGet:(NSDictionary *)options;

/** Сохраняет текст вики-страницы.

@param options ключи-значения, полный список здесь: https://vk.com/dev/pages.save
@return @see info
*/
- (VKRequest *)pagesSave:(NSDictionary *)options;

/** Сохраняет новые настройки доступа на чтение и редактирование вики-страницы.

@param options ключи-значения, полный список здесь: https://vk.com/dev/pages.saveAccess
@return @see info
*/
- (VKRequest *)pagesSaveAccess:(NSDictionary *)options;

/** Возвращает список всех старых версий вики-страницы.

@param options ключи-значения, полный список здесь: https://vk.com/dev/pages.getHistory
@return @see info
*/
- (VKRequest *)pagesGetHistory:(NSDictionary *)options;

/** Возвращает список вики-страниц в группе.

@param options ключи-значения, полный список здесь: https://vk.com/dev/pages.getTitles
@return @see info
*/
- (VKRequest *)pagesGetTitles:(NSDictionary *)options;

/** Возвращает текст одной из старых версий страницы.

@param options ключи-значения, полный список здесь: https://vk.com/dev/pages.getVersion
@return @see info
*/
- (VKRequest *)pagesGetVersion:(NSDictionary *)options;

/** Возвращает html-представление вики-разметки

@param options ключи-значения, полный список здесь: https://vk.com/dev/pages.parseWiki
@return @see info
*/
- (VKRequest *)pagesParseWiki:(NSDictionary *)options;

@end

@interface VKRequestManager (Board)

/**
@name Board
*/
/** Возвращает список тем в обсуждениях указанной группы.

@param options ключи-значения, полный список здесь: https://vk.com/dev/board.getTopics
@return @see info
*/
- (VKRequest *)boardGetTopics:(NSDictionary *)options;

/** Возвращает список сообщений в указанной теме.

@param options ключи-значения, полный список здесь: https://vk.com/dev/board.getComments
@return @see info
*/
- (VKRequest *)boardGetComments:(NSDictionary *)options;

/** Создает новую тему в списке обсуждений группы.

@param options ключи-значения, полный список здесь: https://vk.com/dev/board.addTopic
@return @see info
*/
- (VKRequest *)boardAddTopic:(NSDictionary *)options;

/** Добавляет новое сообщение в теме сообщества.

@param options ключи-значения, полный список здесь: https://vk.com/dev/board.addComment
@return @see info
*/
- (VKRequest *)boardAddComment:(NSDictionary *)options;

/** Удаляет тему в обсуждениях группы

@param options ключи-значения, полный список здесь: https://vk.com/dev/board.deleteTopic
@return @see info
*/
- (VKRequest *)boardDeleteTopic:(NSDictionary *)options;

/** Изменяет заголовок темы в списке обсуждений группы

@param options ключи-значения, полный список здесь: https://vk.com/dev/board.editTopic
@return @see info
*/
- (VKRequest *)boardEditTopic:(NSDictionary *)options;

/** Редактирует одно из сообщений в теме группы

@param options ключи-значения, полный список здесь: https://vk.com/dev/board.editComment
@return @see info
*/
- (VKRequest *)boardEditComment:(NSDictionary *)options;

/** Восстанавливает удаленное сообщение темы в обсуждениях группы

@param options ключи-значения, полный список здесь: https://vk.com/dev/board.restoreComment
@return @see info
*/
- (VKRequest *)boardRestoreComment:(NSDictionary *)options;

/** Удаляет сообщение темы в обсуждениях сообщества

@param options ключи-значения, полный список здесь: https://vk.com/dev/board.deleteComment
@return @see info
*/
- (VKRequest *)boardDeleteComment:(NSDictionary *)options;

/** Открывает ранее закрытую тему (в ней станет возможно оставлять новые сообщения).

@param options ключи-значения, полный список здесь: https://vk.com/dev/board.openTopic
@return @see info
*/
- (VKRequest *)boardOpenTopic:(NSDictionary *)options;

/** Закрывает тему в списке обсуждений группы (в такой теме невозможно оставлять новые сообщения)

@param options ключи-значения, полный список здесь: https://vk.com/dev/board.closeTopic
@return @see info
*/
- (VKRequest *)boardCloseTopic:(NSDictionary *)options;

/** Закрепляет тему в списке обсуждений группы (такая тема при любой сортировке выводится выше остальных)

@param options ключи-значения, полный список здесь: https://vk.com/dev/board.fixTopic
@return @see info
*/
- (VKRequest *)boardFixTopic:(NSDictionary *)options;

/** Отменяет прикрепление темы в списке обсуждений группы (тема будет выводиться согласно выбранной сортировке)

@param options ключи-значения, полный список здесь: https://vk.com/dev/board.unfixTopic
@return @see info
*/
- (VKRequest *)boardUnfixTopic:(NSDictionary *)options;

@end

@interface VKRequestManager (Notes)

/**
@name Notes
*/
/** Возвращает список заметок, созданных пользователем.

@param options ключи-значения, полный список здесь: https://vk.com/dev/notes.get
@return @see info
*/
- (VKRequest *)notesGet:(NSDictionary *)options;

/** Возвращает заметку по её id

@param options ключи-значения, полный список здесь: https://vk.com/dev/notes.getById
@return @see info
*/
- (VKRequest *)notesGetByID:(NSDictionary *)options;

/** Возвращает список заметок друзей пользователя.

@param options ключи-значения, полный список здесь: https://vk.com/dev/notes.getFriendsNotes
@return @see info
*/
- (VKRequest *)notesGetFriendsNotes:(NSDictionary *)options;

/** Создает новую заметку у текущего пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/notes.add
@return @see info
*/
- (VKRequest *)notesAdd:(NSDictionary *)options;

/** Редактирует заметку текущего пользователя.

@param options ключи-значения, полный список здесь: https://vk.com/dev/notes.edit
@return @see info
*/
- (VKRequest *)notesEdit:(NSDictionary *)options;

/** Удаляет заметку текущего пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/notes.delete
@return @see info
*/
- (VKRequest *)notesDelete:(NSDictionary *)options;

/** Возвращает список комментариев к заметке

@param options ключи-значения, полный список здесь: https://vk.com/dev/notes.getComments
@return @see info
*/
- (VKRequest *)notesGetComments:(NSDictionary *)options;

/** Добавляет новый комментарий к заметке

@param options ключи-значения, полный список здесь: https://vk.com/dev/notes.createComment
@return @see info
*/
- (VKRequest *)notesCreateComment:(NSDictionary *)options;

/** Редактирует указанный комментарий у заметки

@param options ключи-значения, полный список здесь: https://vk.com/dev/notes.editComment
@return @see info
*/
- (VKRequest *)notesEditComment:(NSDictionary *)options;

/** Удаляет комментарий к заметке

@param options ключи-значения, полный список здесь: https://vk.com/dev/notes.deleteComment
@return @see info
*/
- (VKRequest *)notesDeleteComment:(NSDictionary *)options;

/** Восстанавливает удалённый комментарий

@param options ключи-значения, полный список здесь: https://vk.com/dev/notes.restoreComment
@return @see info
*/
- (VKRequest *)notesRestoreComment:(NSDictionary *)options;

@end

@interface VKRequestManager (Places)

/**
@name Places
*/
/** Добавляет новое место в базу географических мест.

@param options ключи-значения, полный список здесь: https://vk.com/dev/places.add
@return @see info
*/
- (VKRequest *)placesAdd:(NSDictionary *)options;

/** Возвращает информацию о местах по их идентификаторам.

@param options ключи-значения, полный список здесь: https://vk.com/dev/places.getById
@return @see info
*/
- (VKRequest *)placesGetByID:(NSDictionary *)options;

/** Возвращает список мест, найденных по заданным условиям поиска.

@param options ключи-значения, полный список здесь: https://vk.com/dev/places.search
@return @see info
*/
- (VKRequest *)placesSearch:(NSDictionary *)options;

/** Отмечает пользователя в указанном месте.

@param options ключи-значения, полный список здесь: https://vk.com/dev/places.checkin
@return @see info
*/
- (VKRequest *)placesCheckIn:(NSDictionary *)options;

/** Возвращает список отметок пользователей в местах согласно заданным параметрам.

@param options ключи-значения, полный список здесь: https://vk.com/dev/places.getCheckins
@return @see info
*/
- (VKRequest *)placesGetCheckins:(NSDictionary *)options;

/** Возвращает список всех возможных типов мест.

@param options ключи-значения, полный список здесь: https://vk.com/dev/places.getTypes
@return @see info
*/
- (VKRequest *)placesGetTypes:(NSDictionary *)options;

/** Возвращает список стран.

@param options ключи-значения, полный список здесь: https://vk.com/dev/places.getCountries
@return @see info
*/
- (VKRequest *)placesGetContries:(NSDictionary *)options;

/** Возвращает список регионов.

@param options ключи-значения, полный список здесь: https://vk.com/dev/places.getRegions
@return @see info
*/
- (VKRequest *)placesGetRegions:(NSDictionary *)options;

/** Возвращает информацию об улицах по их идентификаторам (id).

@param options ключи-значения, полный список здесь: https://vk.com/dev/places.getStreetById
@return @see info
*/
- (VKRequest *)placesGetStreetByID:(NSDictionary *)options;

/** Возвращает информацию о странах по их идентификаторам

@param options ключи-значения, полный список здесь: https://vk.com/dev/places.getCountryById
@return @see info
*/
- (VKRequest *)placesGetCountryByID:(NSDictionary *)options;

/** Возвращает список городов.

@param options ключи-значения, полный список здесь: https://vk.com/dev/places.getCities
@return @see info
*/
- (VKRequest *)placesGetCities:(NSDictionary *)options;

/** Возвращает информацию о городах по их идентификаторам.

@param options ключи-значения, полный список здесь: https://vk.com/dev/places.getCityById
@return @see info
*/
- (VKRequest *)placesGetCityByID:(NSDictionary *)options;

@end

@interface VKRequestManager (Polls)

/**
@name Polls
*/
/** Возвращает детальную информацию об опросе по его идентификатору.

@param options ключи-значения, полный список здесь: https://vk.com/dev/polls.getById
@return @see info
*/
- (VKRequest *)pollsGetByID:(NSDictionary *)options;

/** Отдает голос текущего пользователя за выбранный вариант ответа в указанном опросе.

@param options ключи-значения, полный список здесь: https://vk.com/dev/polls.addVote
@return @see info
*/
- (VKRequest *)pollsAddVote:(NSDictionary *)options;

/** Снимает голос текущего пользователя с выбранного варианта ответа в указанном опросе.

@param options ключи-значения, полный список здесь: https://vk.com/dev/polls.deleteVote
@return @see info
*/
- (VKRequest *)pollsDeleteVote:(NSDictionary *)options;

/** Получает список идентификаторов пользователей, которые выбрали определенные варианты ответа в опросе.

@param options ключи-значения, полный список здесь: https://vk.com/dev/polls.getVoters
@return @see info
*/
- (VKRequest *)pollsGetVoters:(NSDictionary *)options;

@end

@interface VKRequestManager (Docs)

/**
@name Docs
*/
/** Возвращает расширенную информацию о документах пользователя или сообщества.

@param options ключи-значения, полный список здесь: https://vk.com/dev/docs.get
@return @see info
*/
- (VKRequest *)docsGet:(NSDictionary *)options;

/** Возвращает информацию о документах по их идентификаторам.

@param options ключи-значения, полный список здесь: https://vk.com/dev/docs.getById
@return @see info
*/
- (VKRequest *)docsGetByID:(NSDictionary *)options;

/** Возвращает адрес сервера для загрузки документов.

@param options ключи-значения, полный список здесь: https://vk.com/dev/docs.getUploadServer
@return @see info
*/
- (VKRequest *)docsGetUploadServer:(NSDictionary *)options;

/** Возвращает адрес сервера для загрузки документов в папку Отправленные, для последующей отправки документа на стену или личным сообщением.

@param options ключи-значения, полный список здесь: https://vk.com/dev/docs.getWallUploadServer
@return @see info
*/
- (VKRequest *)docsGetWallUploadServer:(NSDictionary *)options;

/** Сохраняет документ после его успешной загрузки на сервер.

@param options ключи-значения, полный список здесь: https://vk.com/dev/docs.save
@return @see info
*/
- (VKRequest *)docsSave:(NSDictionary *)options;

/** Удаляет документ пользователя или группы

@param options ключи-значения, полный список здесь: https://vk.com/dev/docs.delete
@return @see info
*/
- (VKRequest *)docsDelete:(NSDictionary *)options;

/** Копирует документ в документы текущего пользователя

@param options ключи-значения, полный список здесь: https://vk.com/dev/docs.add
@return @see info
*/
- (VKRequest *)docsAdd:(NSDictionary *)options;

@end

@interface VKRequestManager (Fave)

/**
@name Fave
*/
/** Возвращает список пользователей, добавленных текущим пользователем в закладки.

@param options ключи-значения, полный список здесь: https://vk.com/dev/fave.getUsers
@return @see info
*/
- (VKRequest *)faveGetUsers:(NSDictionary *)options;

/** Возвращает фотографии, на которых текущий пользователь поставил отметку "Мне нравится"

@param options ключи-значения, полный список здесь: https://vk.com/dev/fave.getPhotos
@return @see info
*/
- (VKRequest *)faveGetPhotos:(NSDictionary *)options;

/** Возвращает записи, на которых текущий пользователь поставил отметку «Мне нравится»

@param options ключи-значения, полный список здесь: https://vk.com/dev/fave.getPosts
@return @see info
*/
- (VKRequest *)faveGetPosts:(NSDictionary *)options;

/** Возвращает список видеозаписей, на которых текущий пользователь поставил отметку «Мне нравится»

@param options ключи-значения, полный список здесь: https://vk.com/dev/fave.getVideos
@return @see info
*/
- (VKRequest *)faveGetVideos:(NSDictionary *)options;

/** Возвращает ссылки, добавленные в закладки текущим пользователем.

@param options ключи-значения, полный список здесь: https://vk.com/dev/fave.getLinks
@return @see info
*/
- (VKRequest *)faveGetLinks:(NSDictionary *)options;

@end

@interface VKRequestManager (Notifications)

/**
@name Notifications
*/
/** Возвращает список оповещений об ответах других пользователей на записи текущего пользователя.

@param options ключи-значения, полный список здесь: https://vk.com/dev/notifications.get
@return @see info
*/
- (VKRequest *)notificationsGet:(NSDictionary *)options;

/** Сбрасывает счетчик непросмотренных оповещений об ответах других пользователей на записи текущего пользователя.

@param options ключи-значения, полный список здесь: https://vk.com/dev/notifications.markAsViewed
@return @see info
*/
- (VKRequest *)notificationsMarkeAsViewed:(NSDictionary *)options;

@end

@interface VKRequestManager (Stats)

/**
@name Stats
*/
/** Возвращает статистику сообщества или приложения.

@param options ключи-значения, полный список здесь: https://vk.com/dev/stats.get
@return @see info
*/
- (VKRequest *)statsGet:(NSDictionary *)options;

@end

@interface VKRequestManager (Search)

/**
@name Search
*/
/** Метод позволяет получить результаты быстрого поиска по произвольной подстроке

@param options ключи-значения, полный список здесь: https://vk.com/dev/search.getHints
@return @see info
*/
- (VKRequest *)searchGetHints:(NSDictionary *)options;

@end

@interface VKRequestManager (Ads)

/**
@name Ads
*/
/** Возвращает список рекламных кабинетов.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getAccounts
@return @see info
*/
- (VKRequest *)adsGetAccounts:(NSDictionary *)options;

/** Возвращает список клиентов рекламного агентства.

Доступно только для рекламных агентств.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getClients
@return @see info
*/
- (VKRequest *)adsGetClients:(NSDictionary *)options;

/** Создает клиентов рекламного агентства.

Доступно только для рекламных агентств.

Внимание! Допустимое количество создаваемых клиентов с помощью одного запроса — 50.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.createClients
@return @see info
*/
- (VKRequest *)adsCreateClients:(NSDictionary *)options;

/** Редактирует клиентов рекламного агентства.
Доступно только для рекламных агентств.

Внимание!Максимальное допустимое количество клиентов, редактируемых с помощью одного запроса — 50.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.updateClients
@return @see info
*/
- (VKRequest *)adsUpdateClients:(NSDictionary *)options;

/** Архивирует клиентов рекламного агентства.

Доступно только для рекламных агентств.

Внимание! Максимальное допустимое количество клиентов, редактируемых с помощью одного запроса — 10.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.deleteClients
@return @see info
*/
- (VKRequest *)adsDeleteClients:(NSDictionary *)options;

/** Возвращает список кампаний рекламного кабинета.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getCampaigns
@return @see info
*/
- (VKRequest *)adsGetCampaigns:(NSDictionary *)options;

/** Создает рекламные кампании.
Внимание! Допустимое количество кампаний, создаваемых с помощью одного запроса — 50.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.createCampaigns
@return @see info
*/
- (VKRequest *)adsCreateCampaigns:(NSDictionary *)options;

/** Редактирует рекламные кампании.

Внимание!Максимальное допустимое количество кампаний, редактируемых с помощью одного запроса — 50.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.updateCampaigns
@return @see info
*/
- (VKRequest *)adsUpdateCampaings:(NSDictionary *)options;

/** Архивирует рекламные кампании.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.deleteCampaigns
@return @see info
*/
- (VKRequest *)adsDeleteCampaings:(NSDictionary *)options;

/** Возвращает список рекламных объявлений.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getAds
@return @see info
*/
- (VKRequest *)adsGet:(NSDictionary *)options;

/** Возвращает описания внешнего вида рекламных объявлений.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getAdsLayout
@return @see info
*/
- (VKRequest *)adsGetLayout:(NSDictionary *)options;

/** Возвращает параметры таргетинга рекламных объявлений

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getAdsTargeting
@return @see info
*/
- (VKRequest *)adsGetTargeting:(NSDictionary *)options;

/** Создает рекламные объявления.

Внимание! Максимальное допустимое количество объявлений, создаваемых с помощью
одного запроса — 20. Минимальный размер аудитории объявления — 50 человек.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.createAds
@return @see info
*/
- (VKRequest *)adsCreate:(NSDictionary *)options;

/** Редактирует рекламные объявления.

Внимание!Максимальное допустимое количество объявлений, редактируемых с помощью
одного запроса — 20. Минимальный размер аудитории объявления — 50 человек.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.updateAds
@return @see info
*/
- (VKRequest *)adsUpdate:(NSDictionary *)options;

/** Архивирует рекламные объявления.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.deleteAds
@return @see info
*/
- (VKRequest *)adsDelete:(NSDictionary *)options;

/** Возвращает статистику показателей эффективности по рекламным объявлениям,
кампаниям, клиентам или всему кабинету.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getStatistics
@return @see info
*/
- (VKRequest *)adsGetStatistics:(NSDictionary *)options;

/** Возвращает демографическую статистику по рекламным объявлениям или кампаниям.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getDemographics
@return @see info
*/
- (VKRequest *)adsGetDemographics:(NSDictionary *)options;

/** Возвращает текущий бюджет рекламного кабинета.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getBudget
@return @see info
*/
- (VKRequest *)adsGetBudget:(NSDictionary *)options;

/** Возвращает список администраторов и наблюдателей рекламного кабинета.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getOfficeUsers
@return @see info
*/
- (VKRequest *)adsGetOfficeUsers:(NSDictionary *)options;

/** Добавляет администраторов и/или наблюдателей в рекламный кабинет.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.addOfficeUsers
@return @see info
*/
- (VKRequest *)adsAddOfficeUsers:(NSDictionary *)options;

/** Удаляет администраторов и/или наблюдателей из рекламного кабинета.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.removeOfficeUsers
@return @see info
*/
- (VKRequest *)adsRemoveOfficeUsers:(NSDictionary *)options;

/** Возвращает размер целевой аудитории таргетинга, а также рекомендованные
значения CPC и CPM.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getTargetingStats
@return @see info
*/
- (VKRequest *)adsGetTargetingStats:(NSDictionary *)options;

/** Возвращает набор подсказок автодополнения для различных параметров таргетинга.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getSuggestions
@return @see info
*/
- (VKRequest *)adsGetSuggestions:(NSDictionary *)options;

/** Получение тематик объявлений.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getCategories
@return @see info
*/
- (VKRequest *)adsGetCategories:(NSDictionary *)options;

/** Возвращает URL-адрес для загрузки фотографии рекламного объявления.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getUploadURL
@return @see info
*/
- (VKRequest *)adsGetUploadURL:(NSDictionary *)options;

/** Возвращает URL-адрес для загрузки видеозаписи рекламного объявления.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getVideoUploadURL
@return @see info
*/
- (VKRequest *)adsGetVideoUploadURL:(NSDictionary *)options;

/** Возвращает информацию о текущем состоянии счетчика — количество оставшихся
запусков методов и время до следующего обнуления счетчика в секундах.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getFloodStats
@return @see info
*/
- (VKRequest *)adsGetFloodStats:(NSDictionary *)options;

/** Возвращает причину, по которой указанному объявлению было отказано в
прохождении премодерации.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getRejectionReason
@return @see info
*/
- (VKRequest *)adsGetRejectionReason:(NSDictionary *)options;

/** Создает группу для ретаргетинга рекламных объявлений на пользователей,
которые посетили сайт рекламодателя (просмотрели информации о товаре, зарегистрировались и т.д.).

В результате выполнения метода возвращается код для учета пользователей на сайте
рекламодателя. Код необходимо разместить на странице сайта, при посещении которой
пользователи, авторизованные во ВКонтакте, будут добавлены в создаваемую группу
таргетирования.

Для импорта в группу уже имеющихся контактов пользователей необходимо
воспользоваться методом ads.importTargetContacts.

Внимание! Максимально допустимое количество групп на рекламный кабинет — 10.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.createTargetGroup
@return @see info
*/
- (VKRequest *)adsCreateTargetGroup:(NSDictionary *)options;

/** Редактирует группу ретаргетинга.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.updateTargetGroup
@return @see info
*/
- (VKRequest *)adsUpdateTargetGroup:(NSDictionary *)options;

/** Удаляет группу ретаргетинга.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.deleteTargetGroup
@return @see info
*/
- (VKRequest *)adsDeleteTargetGroup:(NSDictionary *)options;

/** Возвращает список групп таргетирования.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.getTargetGroups
@return @see info
*/
- (VKRequest *)adsGetTargetGroups:(NSDictionary *)options;

/** Импортирует список контактов рекламодателя для учета зарегистрированных во
ВКонтакте пользователей в срезе группы таргетирования.

Внимание! Максимально допустимое количество контактов, импортируемых с помощью
одного запроса — 1000.

@param options ключи-значения, полный список здесь: https://vk.com/dev/ads.importTargetContacts
@return @see info
*/
- (VKRequest *)adsImportTargetContacts:(NSDictionary *)options;

@end

@interface VKRequestManager (Execute)

/**
@name Execute
*/
/** Универсальный метод, который позволяет запускать последовательность других
методов, сохраняя и фильтруя промежуточные результаты.

@param code код алгоритма в VKScript - формате, похожем на JavaSсript или
ActionScript (предполагается совместимость с ECMAScript). Алгоритм должен
завершаться командой return %выражение%. Операторы должны быть разделены точкой
с запятой.
@return @see info
*/
- (VKRequest *)execute:(NSString *)code;

/** Хранимые процедуры позволяют исполнять код на стороне сервера API аналогично
методу execute, но без передачи кода процедуры по сети.

Использование хранимых процедур рекомендовано для мобильных приложений с целью
экономии трафика.
Вы можете вызвать созданные в интерфейсе хранимые процедуры, используя
следующую конструкцию:

https://api.vk.com/method/execute.ИМЯ_ПРОЦЕДУРЫ?СПИСОК_ПАРАМЕТРОВ

Переданные параметры будут доступны внутри кода процедуры в виде полей объекта
Args, например, если Вы передали ?user=123, то значение этой переменной будет
доступно в Args.user.

@param procedureName наименование хранимой процедуры
@param options словарь передаваемых параметров хранимой процедуре
*/
- (VKRequest *)executePredefinedProcedureWithName:(NSString *)procedureName
                                          options:(NSDictionary *)options;

@end

@interface VKRequestManager (Apps)

/**
@name Apps
*/
/** Возвращает список приложений, доступных для пользователей сайта через каталог приложений.

@param options ключь-значение, подробнее по этой ссылке https://vk.com/dev/apps.getCatalog
@return @see info
*/
- (VKRequest *)appsGetCatalog:(NSDictionary *)options;

@end

@interface VKRequestManager (Utils)

/**
@name Utils
*/
/** Возвращает информацию о том, является ли ссылка заблокированной на сайте ВКонтакте.

@param options ключи-значения, подробнее https://vk.com/dev/utils.checkLink
@return @see info
*/
- (VKRequest *)utilsCheckLink:(NSDictionary *)options;

/** Определяет тип объекта (пользователь, сообщество, приложение) и его
идентификатор по короткому имени screen_name.

@param options ключи-значения, подробнее https://vk.com/dev/utils.resolveScreenName
@return @see info
*/
- (VKRequest *)utilsResolveScreenName:(NSDictionary *)options;

/** Возвращает текущее время на сервере ВКонтакте в unixtime.

@param options ключи-значения, подробнее https://vk.com/dev/utils.getServerTime
@return @see info
*/
- (VKRequest *)utilsGetServerTime:(NSDictionary *)options;

@end

@interface VKRequestManager (Database)

/**
@name Database
*/
/** Возвращает список стран.

@param options ключи-значения, подробнее https://vk.com/dev/database.getCountries
@return @see info
*/
- (VKRequest *)databaseGetCountries:(NSDictionary *)options;

/** Возвращает список регионов.

@param options ключи-значения, подробнее https://vk.com/dev/database.getRegions
@return @see info
*/
- (VKRequest *)databaseGetRegions:(NSDictionary *)options;

/** Возвращает информацию об улицах по их идентификаторам (id).

@param options ключи-значения, подробнее https://vk.com/dev/database.getStreetsById
@return @see info
*/
- (VKRequest *)databaseGetStreetsById:(NSDictionary *)options;

/** Возвращает информацию о странах по их идентификаторам

Идентификаторы (id) могут быть получены с помощью методов users.get,
places.getById, places.search, places.getCheckins.

@param options ключи-значения, подробнее https://vk.com/dev/database.getCountriesById
@return @see info
*/
- (VKRequest *)databaseGetCountriesById:(NSDictionary *)options;

/** Возвращает список городов.

@param options ключи-значения, подробнее https://vk.com/dev/database.getCities
@return @see info
*/
- (VKRequest *)databaseGetCities:(NSDictionary *)options;

/** Возвращает информацию о городах по их идентификаторам.

Идентификаторы (id) могут быть получены с помощью методов users.get,
places.getById, places.search, places.getCheckins.

@param options ключи-значения, подробнее https://vk.com/dev/database.getCitiesById
@return @see info
*/
- (VKRequest *)databaseGetCitiesById:(NSDictionary *)options;

/** Возвращает список высших учебных заведений.

@param options ключи-значения, подробнее https://vk.com/dev/database.getUniversities
@return @see info
*/
- (VKRequest *)databaseGetUniversities:(NSDictionary *)options;

/** Возвращает список школ.

@param options ключи-значения, подробнее https://vk.com/dev/database.getSchools
@return @see info
*/
- (VKRequest *)databaseGetSchools:(NSDictionary *)options;

/** Возвращает список факультетов.

@param options ключи-значения, подробнее https://vk.com/dev/database.getFaculties
@return @see info
*/
- (VKRequest *)databaseGetFaculties:(NSDictionary *)options;

@end