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
#import "VKUser.h"
#import "VKStorage.h"
#import "VKStorageItem.h"
#import "VKAccessToken.h"
#import "VKRequest.h"
#import "VKMethods.h"


@implementation VKUser
{
    VKStorageItem *_storageItem;
}

#pragma mark Visible VKUser methods
#pragma mark - Init methods

- (instancetype)initWithStorageItem:(VKStorageItem *)storageItem
{
    self = [super init];

    if (self) {
        _storageItem = storageItem;
        _startAllRequestsImmediately = YES;
        _offlineMode = NO;
    }

    return self;
}

#pragma mark - Class methods

static VKUser *_currentUser;

+ (instancetype)currentUser
{
    if (nil == _currentUser) {
//        пользователь еще не был запрошен и не был установлен активным
        if (![[VKStorage sharedStorage] isEmpty]) {

//            хранилище содержит некоторые данные
//            устанавливаем произвольного пользователя активным
            VKStorageItem *storageItem = [[[VKStorage sharedStorage]
                                                      storageItems] lastObject];
            _currentUser = [[VKUser alloc] initWithStorageItem:storageItem];

        }

        return _currentUser;
    }

//    пользователь установлен, но в хранилище его записи нет (возможно была удалена), а этого нельзя так оставлять - сбрасываем
    if (nil == [[VKStorage sharedStorage]
                           storageItemForUserID:_currentUser.accessToken.userID]) {
        _currentUser = nil;
    }

    return _currentUser;
}

+ (BOOL)activateUserWithID:(NSUInteger)userID
{
    VKStorageItem *storageItem = [[VKStorage sharedStorage]
                                             storageItemForUserID:userID];

    if (nil == storageItem)
        return NO;

    _currentUser = [[VKUser alloc] initWithStorageItem:storageItem];

    return YES;
}

+ (NSArray *)localUsers
{
    NSMutableArray *localUsers = [[NSMutableArray alloc] init];

    [[[VKStorage sharedStorage] storageItems]
                 enumerateObjectsUsingBlock:^(id obj,
                                              NSUInteger idx,
                                              BOOL *stop)
                 {
                     [localUsers addObject:@(((VKStorageItem *) obj).accessToken.userID)];
                 }];

    return localUsers;
}

#pragma mark - Users

- (VKRequest *)info
{
    NSDictionary *options = @{
            @"uids"   : @(self.accessToken.userID),
            @"fields" : @"nickname,screen_name,sex,bdate,has_mobile,online,last_seen,status,photo100"
    };

    return [self configureRequestMethod:kVKUsersGet
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)info:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKUsersGet
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)search:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKUsersSearch
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)subscriptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKUsersGetSubscriptions
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)followers:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKUsersGetFollowers
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

#pragma mark - Wall

- (VKRequest *)wallGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallGet
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)wallGetByID:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallGetById
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)wallSavePost:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallSavePost
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallPost:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallPost
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallRepost:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallRepost
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallGetReposts:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallGetReposts
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallEdit:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallEdit
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallDelete:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallDelete
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallRestore:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallRestore
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallGetComments:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallGetComments
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallAddComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallAddComment
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallDeleteComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallDeleteComment
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallRestoreComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallRestoreComment
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

#pragma mark - Groups

- (VKRequest *)groupsIsMember:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsIsMember
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)groupsGetByID:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsGetById
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)groupsGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsGet
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)groupsGetMembers:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsGetMembers
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)groupsJoin:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsJoin
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)groupsLeave:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsLeave
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)groupsSearch:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsSearch
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)groupsGetInvites:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsGetInvites
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)groupsBanUser:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsBanUser
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)groupsUnbanUser:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsUnbanUser
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)groupsGetBanned:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsGetBanned
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

#pragma mark - Friends

- (VKRequest *)friendsGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGet
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)friendsGetOnline:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetOnline
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsGetMutual:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetMutual
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsGetRecent:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetRecent
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsGetRequests:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetRequests
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsAdd:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsAdd
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsEdit:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsEdit
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsDelete:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsDelete
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsGetLists:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetLists
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsAddList:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsAddList
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsEditList:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsEditList
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsDeleteList:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsDeleteList
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsGetAppUsers:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetAppUsers
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsGetByPhones:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetByPhones
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsDeleteAllRequests:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsDeleteAllRequests
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsGetSuggestions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetSuggestions
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsAreFriends:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsAreFriends
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

#pragma mark - Photos

- (VKRequest *)photosCreateAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosCreateAlbum
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosEditAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosEditAlbum
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosGetAlbums:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetAlbums
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)photosGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGet
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)photosGetAlbumsCount:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetAlbumsCount
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosGetProfile:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetProfile
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosGetByID:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetById
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosGetUploadServer:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetUploadServer
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosGetProfileUploadServer:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetProfileUploadServer
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosGetChatUploadServer:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetChatUploadServer
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosSaveProfilePhoto:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosSaveProfilePhoto
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosSaveWallPhoto:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosSaveWallPhoto
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosGetWallUploadServer:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetWallUploadServer
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosGetMessagesUploadServer:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetMessagesUploadServer
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosSaveMessagesPhoto:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosSaveMessagesPhoto
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosSearch:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosSearch
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)photosSave:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosSave
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosEdit:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosEdit
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosMove:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosMove
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosMakeCover:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosMakeCover
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosReorderAlbums:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosReorderAlbums
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosReorderPhotos:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosReorderPhotos
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosGetAll:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetAll
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosGetUserPhotos:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetUserPhotos
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosDeleteAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosDeleteAlbum
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosDelete:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosDelete
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosConfirmTagWithCusomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosConfirmTag
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosGetComments:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetComments
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosGetAllComments:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetAllComments
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosCreateComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosCreateComment
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosDeleteComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosDeleteComment
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosRestoreComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosRestoreComment
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosEditComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosEditComment
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosGetTags:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetTags
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosPutTag:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosPutTag
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosRemoveTag:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosRemoveTag
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)photosGetNewTags:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetNewTags
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

#pragma mark - Video

- (VKRequest *)videoGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoGet
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoEdit:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoEdit
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoAdd:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoAdd
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoSave:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoSave
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoDelete:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoDelete
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoRestore:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoRestore
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoSearch:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoSearch
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoGetUserVideos:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoGetUserVideos
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoGetAlbums:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoGetAlbums
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoAddAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoAddAlbum
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoEditAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoEditAlbum
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoDeleteAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoDeleteAlbum
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoMoveToAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoMoveToAlbum
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoGetComments:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoGetComments
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoCreateComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoCreateComment
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoDeleteComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoDeleteComment
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoRestoreComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoRestoreComment
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoEditComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoEditComment
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoGetTags:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoGetTags
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoPutTag:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoPutTag
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoRemoveTag:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoRemoveTag
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoGetNewTags:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoGetNewTags
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)videoReport:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoReport
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

#pragma mark - Audio

- (VKRequest *)audioGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioGet
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioGetByID:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioGetById
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioGetLyrics:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioGetLyrics
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioSearch:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioSearch
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioGetUploadServer:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioGetUploadServer
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioSave:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioSave
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioAdd:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioAdd
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioDelete:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioDelete
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioEdit:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioEdit
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioReorder:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioReorder
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioRestore:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioRestore
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioGetAlbums:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioGetAlbums
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioAddAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioAddAlbum
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioEditAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioEditAlbum
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioDeleteAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioDeleteAlbum
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioMoveToAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioMoveToAlbum
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioSetBroadcast:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioSetBroadcast
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioGetBroadcastList:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioGetBroadcast
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioGetRecommendations:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioGetRecommendations
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioGetPopular:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioGetPopular
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)audioGetCount:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioGetCount
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

#pragma mark - Messages

- (VKRequest *)messagesGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGet
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesGetDialogs:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGetDialogs
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesGetByID:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGetById
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesSearch:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesSearch
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesGetHistory:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGetHistory
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesSend:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesSend
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesDelete:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesDelete
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesDeleteDialog:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesDeleteDialog
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesRestore:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesRestore
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesMarkAsNew:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesMarkAsNew
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesMarkAsRead:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesMarkAsRead
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesMarkAsImportant:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesMarkAsImportant
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesGetLongPollServer:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGetLongPollServer
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesGetLongPollHistory:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGetLongPollHistory
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesGetChat:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGetChat
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesCreateChat:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesCreateChat
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesEditChat:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesEditChat
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesGetChatUsers:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGetChatUsers
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesSetActivity:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesSetActivity
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesSearchDialogs:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesSearchDialogs
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesAddChatUser:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesAddChatUser
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesRemoveChatUser:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesRemoveChatUser
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesGetLastActivity:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGetLastActivity
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesSetChatPhoto:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesSetChatPhoto
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)messagesDeleteChatPhoto:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesDeleteChatPhoto
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

#pragma mark - Newsfeed

- (VKRequest *)newsfeedGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedGet
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)newsfeedGetRecommended:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedGetRecommended
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)newsfeedGetComments:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedGetComments
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)newsfeedGetMentions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedGetMentions
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)newsfeedGetBanned:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedGetBanned
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)newsfeedAddBan:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedAddBan
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)newsfeedDeleteBan:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedDeleteBan
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)newsfeedSearch:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedSearch
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)newsfeedGetLists:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedGetLists
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)newsfeedUnsubscribe:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedUnsibscribe
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

#pragma mark - Likes

- (VKRequest *)likesGetList:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKLikesGetList
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)likesAdd:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKLikesAdd
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)likesDelete:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKLikesDelete
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)likesIsLiked:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKLikesIsLiked
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

#pragma mark - Setters & Getters

- (VKAccessToken *)accessToken
{
    return _storageItem.accessToken;
}

#pragma mark - Overridden methods

- (NSString *)description
{
    return [_storageItem.accessToken description];
}

#pragma mark - Private methods

- (NSDictionary *)addAccessTokenKey:(NSDictionary *)options
{
    NSMutableDictionary *ops = [options mutableCopy];
    ops[@"access_token"] = self.accessToken.token;

    return ops;
}

- (VKRequest *)configureRequestMethod:(NSString *)methodName
                              options:(NSDictionary *)options
                             selector:(SEL)selector
                       addAccessToken:(BOOL)addToken
{
    if (addToken)
        options = [self addAccessTokenKey:options];

    VKRequest *req = [[VKRequest alloc]
                                 initWithMethod:methodName
                                        options:options];

    req.signature = NSStringFromSelector(selector);
    req.offlineMode = self.offlineMode;
    req.delegate = self.delegate;

    if (self.startAllRequestsImmediately)
        [req start];

    return req;
}

@end