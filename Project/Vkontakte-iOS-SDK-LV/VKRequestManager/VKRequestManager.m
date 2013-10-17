//
//  VKRequestManager.m
//  Project
//
//  Created by SD on 10/7/13.
//  Copyright (c) 2013 AndrewShmig. All rights reserved.
//

#import "VKUser.h"
#import "VKRequest.h"
#import "VKMethods.h"
#import "VKAccessToken.h"
#import "VKRequestManager.h"


@implementation VKRequestManager

#pragma mark - Init

- (instancetype)initWithDelegate:(id <VKRequestDelegate>)delegate
                            user:(VKUser *)user
{
    self = [super init];

    if (self) {
        _delegate = delegate;
        _user = user;
        _startAllRequestsImmediately = YES;
    }

    return self;
}

#pragma mark - Users

- (VKRequest *)info
{
    if (!self.user) return nil;

    NSDictionary *options = @{
            @"uids"   : @(self.user.accessToken.userID),
            @"fields" : @"nickname,screen_name,sex,bdate,has_mobile,online,last_seen,status,photo_100"
    };

    return [self info:options];
}

- (VKRequest *)info:(NSDictionary *)options
{

    return [self configureRequestMethod:kVKUsersGet
                                options:options
                               selector:_cmd];
}

- (VKRequest *)search:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKUsersSearch
                                options:options
                               selector:_cmd];
}

- (VKRequest *)subscriptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKUsersGetSubscriptions
                                options:options
                               selector:_cmd];
}

- (VKRequest *)followers:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKUsersGetFollowers
                                options:options
                               selector:_cmd];
}

#pragma mark - Wall

- (VKRequest *)wallGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallGet
                                options:options
                               selector:_cmd];
}

- (VKRequest *)wallGetByID:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallGetById
                                options:options
                               selector:_cmd];
}

- (VKRequest *)wallSavePost:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallSavePost
                                options:options
                               selector:_cmd];
}

- (VKRequest *)wallPost:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallPost
                                options:options
                               selector:_cmd];
}

- (VKRequest *)wallRepost:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallRepost
                                options:options
                               selector:_cmd];
}

- (VKRequest *)wallGetReposts:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallGetReposts
                                options:options
                               selector:_cmd];
}

- (VKRequest *)wallEdit:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallEdit
                                options:options
                               selector:_cmd];
}

- (VKRequest *)wallDelete:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallDelete
                                options:options
                               selector:_cmd];
}

- (VKRequest *)wallRestore:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallRestore
                                options:options
                               selector:_cmd];
}

- (VKRequest *)wallGetComments:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallGetComments
                                options:options
                               selector:_cmd];
}

- (VKRequest *)wallAddComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallAddComment
                                options:options
                               selector:_cmd];
}

- (VKRequest *)wallDeleteComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallDeleteComment
                                options:options
                               selector:_cmd];
}

- (VKRequest *)wallRestoreComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallRestoreComment
                                options:options
                               selector:_cmd];
}

#pragma mark - Groups

- (VKRequest *)groupsIsMember:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsIsMember
                                options:options
                               selector:_cmd];
}

- (VKRequest *)groupsGetByID:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsGetById
                                options:options
                               selector:_cmd];
}

- (VKRequest *)groupsGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsGet
                                options:options
                               selector:_cmd];
}

- (VKRequest *)groupsGetMembers:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsGetMembers
                                options:options
                               selector:_cmd];
}

- (VKRequest *)groupsJoin:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsJoin
                                options:options
                               selector:_cmd];
}

- (VKRequest *)groupsLeave:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsLeave
                                options:options
                               selector:_cmd];
}

- (VKRequest *)groupsSearch:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsSearch
                                options:options
                               selector:_cmd];
}

- (VKRequest *)groupsGetInvites:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsGetInvites
                                options:options
                               selector:_cmd];
}

- (VKRequest *)groupsBanUser:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsBanUser
                                options:options
                               selector:_cmd];
}

- (VKRequest *)groupsUnbanUser:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsUnbanUser
                                options:options
                               selector:_cmd];
}

- (VKRequest *)groupsGetBanned:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsGetBanned
                                options:options
                               selector:_cmd];
}

#pragma mark - Friends

- (VKRequest *)friendsGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGet
                                options:options
                               selector:_cmd];
}

- (VKRequest *)friendsGetOnline:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetOnline
                                options:options
                               selector:_cmd];
}

- (VKRequest *)friendsGetMutual:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetMutual
                                options:options
                               selector:_cmd];
}

- (VKRequest *)friendsGetRecent:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetRecent
                                options:options
                               selector:_cmd];
}

- (VKRequest *)friendsGetRequests:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetRequests
                                options:options
                               selector:_cmd];
}

- (VKRequest *)friendsAdd:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsAdd
                                options:options
                               selector:_cmd];
}

- (VKRequest *)friendsEdit:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsEdit
                                options:options
                               selector:_cmd];
}

- (VKRequest *)friendsDelete:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsDelete
                                options:options
                               selector:_cmd];
}

- (VKRequest *)friendsGetLists:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetLists
                                options:options
                               selector:_cmd];
}

- (VKRequest *)friendsAddList:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsAddList
                                options:options
                               selector:_cmd];
}

- (VKRequest *)friendsEditList:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsEditList
                                options:options
                               selector:_cmd];
}

- (VKRequest *)friendsDeleteList:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsDeleteList
                                options:options
                               selector:_cmd];
}

- (VKRequest *)friendsGetAppUsers:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetAppUsers
                                options:options
                               selector:_cmd];
}

- (VKRequest *)friendsGetByPhones:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetByPhones
                                options:options
                               selector:_cmd];
}

- (VKRequest *)friendsDeleteAllRequests:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsDeleteAllRequests
                                options:options
                               selector:_cmd];
}


- (VKRequest *)friendsAreFriends:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsAreFriends
                                options:options
                               selector:_cmd];
}

#pragma mark - Photos

- (VKRequest *)photosCreateAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosCreateAlbum
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosEditAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosEditAlbum
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosGetAlbums:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetAlbums
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGet
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosGetAlbumsCount:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetAlbumsCount
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosGetProfile:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetProfile
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosGetByID:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetById
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosGetUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestMethod:kVKPhotosGetUploadServer
                                              options:options
                                             selector:_cmd];
    request.cacheLiveTime = VKCachedDataLiveTimeNever;

    return request;
}

- (VKRequest *)photosGetProfileUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestMethod:kVKPhotosGetProfileUploadServer
                                              options:options
                                             selector:_cmd];
    request.cacheLiveTime = VKCachedDataLiveTimeNever;

    return request;
}

- (VKRequest *)photosGetChatUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestMethod:kVKPhotosGetChatUploadServer
                                              options:options
                                             selector:_cmd];
    request.cacheLiveTime = VKCachedDataLiveTimeNever;

    return request;
}

- (VKRequest *)photosSaveProfilePhoto:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosSaveProfilePhoto
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosSaveWallPhoto:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosSaveWallPhoto
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosGetWallUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestMethod:kVKPhotosGetWallUploadServer
                                              options:options
                                             selector:_cmd];
    request.cacheLiveTime = VKCachedDataLiveTimeNever;

    return request;
}

- (VKRequest *)photosGetMessagesUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestMethod:kVKPhotosGetMessagesUploadServer
                                              options:options
                                             selector:_cmd];
    request.cacheLiveTime = VKCachedDataLiveTimeNever;

    return request;
}

- (VKRequest *)photosSaveMessagesPhoto:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosSaveMessagesPhoto
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosSearch:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosSearch
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosSave:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosSave
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosEdit:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosEdit
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosMove:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosMove
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosMakeCover:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosMakeCover
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosReorderAlbums:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosReorderAlbums
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosReorderPhotos:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosReorderPhotos
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosGetAll:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetAll
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosGetUserPhotos:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetUserPhotos
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosDeleteAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosDeleteAlbum
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosDelete:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosDelete
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosConfirmTagWithCusomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosConfirmTag
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosGetComments:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetComments
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosGetAllComments:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetAllComments
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosCreateComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosCreateComment
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosDeleteComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosDeleteComment
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosRestoreComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosRestoreComment
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosEditComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosEditComment
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosGetTags:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetTags
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosPutTag:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosPutTag
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosRemoveTag:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosRemoveTag
                                options:options
                               selector:_cmd];
}

- (VKRequest *)photosGetNewTags:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPhotosGetNewTags
                                options:options
                               selector:_cmd];
}

#pragma mark - Video

- (VKRequest *)videoGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoGet
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoEdit:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoEdit
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoAdd:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoAdd
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoSave:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoSave
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoDelete:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoDelete
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoRestore:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoRestore
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoSearch:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoSearch
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoGetUserVideos:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoGetUserVideos
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoGetAlbums:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoGetAlbums
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoAddAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoAddAlbum
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoEditAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoEditAlbum
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoDeleteAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoDeleteAlbum
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoMoveToAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoMoveToAlbum
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoGetComments:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoGetComments
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoCreateComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoCreateComment
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoDeleteComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoDeleteComment
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoRestoreComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoRestoreComment
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoEditComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoEditComment
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoGetTags:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoGetTags
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoPutTag:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoPutTag
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoRemoveTag:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoRemoveTag
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoGetNewTags:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoGetNewTags
                                options:options
                               selector:_cmd];
}

- (VKRequest *)videoReport:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKVideoReport
                                options:options
                               selector:_cmd];
}

#pragma mark - Audio

- (VKRequest *)audioGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioGet
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioGetByID:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioGetById
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioGetLyrics:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioGetLyrics
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioSearch:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioSearch
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioGetUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestMethod:kVKAudioGetUploadServer
                                              options:options
                                             selector:_cmd];
    request.cacheLiveTime = VKCachedDataLiveTimeNever;

    return request;
}

- (VKRequest *)audioSave:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioSave
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioAdd:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioAdd
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioDelete:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioDelete
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioEdit:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioEdit
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioReorder:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioReorder
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioRestore:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioRestore
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioGetAlbums:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioGetAlbums
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioAddAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioAddAlbum
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioEditAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioEditAlbum
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioDeleteAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioDeleteAlbum
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioMoveToAlbum:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioMoveToAlbum
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioSetBroadcast:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioSetBroadcast
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioGetBroadcastList:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioGetBroadcast
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioGetRecommendations:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioGetRecommendations
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioGetPopular:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioGetPopular
                                options:options
                               selector:_cmd];
}

- (VKRequest *)audioGetCount:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAudioGetCount
                                options:options
                               selector:_cmd];
}

#pragma mark - Messages

- (VKRequest *)messagesGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGet
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesGetDialogs:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGetDialogs
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesGetByID:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGetById
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesSearch:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesSearch
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesGetHistory:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGetHistory
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesSend:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesSend
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesDelete:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesDelete
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesDeleteDialog:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesDeleteDialog
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesRestore:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesRestore
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesMarkAsNew:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesMarkAsNew
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesMarkAsRead:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesMarkAsRead
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesMarkAsImportant:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesMarkAsImportant
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesGetLongPollServer:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGetLongPollServer
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesGetLongPollHistory:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGetLongPollHistory
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesGetChat:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGetChat
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesCreateChat:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesCreateChat
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesEditChat:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesEditChat
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesGetChatUsers:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGetChatUsers
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesSetActivity:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesSetActivity
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesSearchDialogs:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesSearchDialogs
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesAddChatUser:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesAddChatUser
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesRemoveChatUser:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesRemoveChatUser
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesGetLastActivity:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesGetLastActivity
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesSetChatPhoto:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesSetChatPhoto
                                options:options
                               selector:_cmd];
}

- (VKRequest *)messagesDeleteChatPhoto:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKMessagesDeleteChatPhoto
                                options:options
                               selector:_cmd];
}

#pragma mark - Newsfeed

- (VKRequest *)newsfeedGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedGet
                                options:options
                               selector:_cmd];
}

- (VKRequest *)newsfeedGetRecommended:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedGetRecommended
                                options:options
                               selector:_cmd];
}

- (VKRequest *)newsfeedGetComments:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedGetComments
                                options:options
                               selector:_cmd];
}

- (VKRequest *)newsfeedGetMentions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedGetMentions
                                options:options
                               selector:_cmd];
}

- (VKRequest *)newsfeedGetBanned:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedGetBanned
                                options:options
                               selector:_cmd];
}

- (VKRequest *)newsfeedAddBan:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedAddBan
                                options:options
                               selector:_cmd];
}

- (VKRequest *)newsfeedDeleteBan:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedDeleteBan
                                options:options
                               selector:_cmd];
}

- (VKRequest *)newsfeedSearch:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedSearch
                                options:options
                               selector:_cmd];
}

- (VKRequest *)newsfeedGetLists:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedGetLists
                                options:options
                               selector:_cmd];
}

- (VKRequest *)newsfeedUnsubscribe:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNewsfeedUnsibscribe
                                options:options
                               selector:_cmd];
}

#pragma mark - Likes

- (VKRequest *)likesGetList:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKLikesGetList
                                options:options
                               selector:_cmd];
}

- (VKRequest *)likesAdd:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKLikesAdd
                                options:options
                               selector:_cmd];
}

- (VKRequest *)likesDelete:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKLikesDelete
                                options:options
                               selector:_cmd];
}

- (VKRequest *)likesIsLiked:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKLikesIsLiked
                                options:options
                               selector:_cmd];
}

#pragma mark - Account

- (VKRequest *)accountGetCounters:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAccountGetCounters
                                options:options
                               selector:_cmd];
}

- (VKRequest *)accountSetNameInMenu:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAccountSetNameInMenu
                                options:options
                               selector:_cmd];
}

- (VKRequest *)accountSetOnline:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAccountSetOnline
                                options:options
                               selector:_cmd];
}

- (VKRequest *)accountImportContacts:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAccountImportContacts
                                options:options
                               selector:_cmd];
}

- (VKRequest *)accountRegisterDevice:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAccountRegisterDevice
                                options:options
                               selector:_cmd];
}

- (VKRequest *)accountUnregisterDevice:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAccountUnregisterDevice
                                options:options
                               selector:_cmd];
}

- (VKRequest *)accountSetSilenceMode:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAccountSetSilenceMode
                                options:options
                               selector:_cmd];
}

- (VKRequest *)accountGetPushSettings:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAccountGetPushSettings
                                options:options
                               selector:_cmd];
}

- (VKRequest *)accountGetAppPermissions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAccountGetAppPermissions
                                options:options
                               selector:_cmd];
}

- (VKRequest *)accountGetActiveOffers:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAccountGetActiveOffers
                                options:options
                               selector:_cmd];
}

- (VKRequest *)accountBanUser:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAccountBanUser
                                options:options
                               selector:_cmd];
}

- (VKRequest *)accountUnbanUser:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAccountUnbanUser
                                options:options
                               selector:_cmd];
}

- (VKRequest *)accountGetBanned:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKAccountGetBanned
                                options:options
                               selector:_cmd];
}

#pragma mark - Status

- (VKRequest *)statusGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKStatsGet
                                options:options
                               selector:_cmd];
}

- (VKRequest *)statusSet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKStatusSet
                                options:options
                               selector:_cmd];
}

#pragma mark - Pages

- (VKRequest *)pagesGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPagesGet
                                options:options
                               selector:_cmd];
}

- (VKRequest *)pagesSave:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPagesSave
                                options:options
                               selector:_cmd];
}

- (VKRequest *)pagesSaveAccess:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPagesSaveAccess
                                options:options
                               selector:_cmd];
}

- (VKRequest *)pagesGetHistory:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPagesGetHistory
                                options:options
                               selector:_cmd];
}

- (VKRequest *)pagesGetTitles:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPagesGetTitles
                                options:options
                               selector:_cmd];
}

- (VKRequest *)pagesGetVersion:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPagesGetVersion
                                options:options
                               selector:_cmd];
}

- (VKRequest *)pagesParseWiki:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPagesParseWiki
                                options:options
                               selector:_cmd];
}

#pragma mark - Board

- (VKRequest *)boardGetTopics:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKBoardGetTopics
                                options:options
                               selector:_cmd];
}

- (VKRequest *)boardGetComments:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKBoardGetComments
                                options:options
                               selector:_cmd];
}

- (VKRequest *)boardAddTopic:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKBoardAddTopic
                                options:options
                               selector:_cmd];
}

- (VKRequest *)boardAddComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKBoardAddComment
                                options:options
                               selector:_cmd];
}

- (VKRequest *)boardDeleteTopic:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKBoardDeleteTopic
                                options:options
                               selector:_cmd];
}

- (VKRequest *)boardEditTopic:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKBoardEditTopic
                                options:options
                               selector:_cmd];
}

- (VKRequest *)boardEditComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKBoardEditComment
                                options:options
                               selector:_cmd];
}

- (VKRequest *)boardRestoreComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKBoardRestoreComment
                                options:options
                               selector:_cmd];
}

- (VKRequest *)boardDeleteComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKBoardDeleteComment
                                options:options
                               selector:_cmd];
}

- (VKRequest *)boardOpenTopic:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKBoardOpenTopic
                                options:options
                               selector:_cmd];
}

- (VKRequest *)boardCloseTopic:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKBoardCloseTopic
                                options:options
                               selector:_cmd];
}

- (VKRequest *)boardFixTopic:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKBoardFixTopic
                                options:options
                               selector:_cmd];
}

- (VKRequest *)boardUnfixTopic:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKBoardUnfixTopic
                                options:options
                               selector:_cmd];
}

#pragma mark - Notes

- (VKRequest *)notesGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNotesGet
                                options:options
                               selector:_cmd];
}

- (VKRequest *)notesGetByID:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNotesGetById
                                options:options
                               selector:_cmd];
}

- (VKRequest *)notesGetFriendsNotes:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNotesGetFriendsNotes
                                options:options
                               selector:_cmd];
}

- (VKRequest *)notesAdd:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNotesAdd
                                options:options
                               selector:_cmd];
}

- (VKRequest *)notesEdit:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNotesEdit
                                options:options
                               selector:_cmd];
}

- (VKRequest *)notesDelete:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNotesDelete
                                options:options
                               selector:_cmd];
}

- (VKRequest *)notesGetComments:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNotesGetComments
                                options:options
                               selector:_cmd];
}

- (VKRequest *)notesCreateComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNotesCreateComment
                                options:options
                               selector:_cmd];
}

- (VKRequest *)notesEditComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNotesEditComment
                                options:options
                               selector:_cmd];
}

- (VKRequest *)notesDeleteComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNotesDeleteComment
                                options:options
                               selector:_cmd];
}

- (VKRequest *)notesRestoreComment:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNotesRestoreComment
                                options:options
                               selector:_cmd];
}

#pragma mark - Places

- (VKRequest *)placesAdd:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPlacesAdd
                                options:options
                               selector:_cmd];
}

- (VKRequest *)placesGetByID:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPlacesGetById
                                options:options
                               selector:_cmd];
}

- (VKRequest *)placesSearch:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPlacesSearch
                                options:options
                               selector:_cmd];
}

- (VKRequest *)placesCheckIn:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPlacesCheckin
                                options:options
                               selector:_cmd];
}

- (VKRequest *)placesGetCheckins:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPlacesGetCheckins
                                options:options
                               selector:_cmd];
}

- (VKRequest *)placesGetTypes:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPlacesGetTypes
                                options:options
                               selector:_cmd];
}

- (VKRequest *)placesGetContries:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPlacesGetCountries
                                options:options
                               selector:_cmd];
}

- (VKRequest *)placesGetRegions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPlacesGetRegions
                                options:options
                               selector:_cmd];
}

- (VKRequest *)placesGetStreetByID:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPlacesGetStreetById
                                options:options
                               selector:_cmd];
}

- (VKRequest *)placesGetCountryByID:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPlacesGetCountryById
                                options:options
                               selector:_cmd];
}

- (VKRequest *)placesGetCities:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPlacesGetCities
                                options:options
                               selector:_cmd];
}

- (VKRequest *)placesGetCityByID:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPlacesGetCityById
                                options:options
                               selector:_cmd];
}

#pragma mark - Polls

- (VKRequest *)pollsGetByID:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPollsGetById
                                options:options
                               selector:_cmd];
}

- (VKRequest *)pollsAddVote:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPollsAddVote
                                options:options
                               selector:_cmd];
}

- (VKRequest *)pollsDeleteVote:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPollsDeleteVote
                                options:options
                               selector:_cmd];
}

- (VKRequest *)pollsGetVoters:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKPollsGetVotes
                                options:options
                               selector:_cmd];
}

#pragma mark - Docs

- (VKRequest *)docsGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKDocsGet
                                options:options
                               selector:_cmd];
}

- (VKRequest *)docsGetByID:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKDocsGetById
                                options:options
                               selector:_cmd];
}

- (VKRequest *)docsGetUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestMethod:kVKDocsGetUploadServer
                                              options:options
                                             selector:_cmd];
    request.cacheLiveTime = VKCachedDataLiveTimeNever;

    return request;
}

- (VKRequest *)docsGetWallUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestMethod:kVKDocsGetWallUloadServer
                                              options:options
                                             selector:_cmd];
    request.cacheLiveTime = VKCachedDataLiveTimeNever;

    return request;
}

- (VKRequest *)docsSave:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKDocsSave
                                options:options
                               selector:_cmd];
}

- (VKRequest *)docsDelete:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKDocsDelete
                                options:options
                               selector:_cmd];
}

- (VKRequest *)docsAdd:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKDocsAdd
                                options:options
                               selector:_cmd];
}

#pragma mark - Fave

- (VKRequest *)faveGetUsers:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFaveGetUsers
                                options:options
                               selector:_cmd];
}

- (VKRequest *)faveGetPhotos:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFaveGetPhotos
                                options:options
                               selector:_cmd];
}

- (VKRequest *)faveGetPosts:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFaveGetPosts
                                options:options
                               selector:_cmd];
}

- (VKRequest *)faveGetVideos:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFaveGetVideos
                                options:options
                               selector:_cmd];
}

- (VKRequest *)faveGetLinks:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFaveGetLinks
                                options:options
                               selector:_cmd];
}

#pragma mark - Notifications

- (VKRequest *)notificationsGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNotificationsGet
                                options:options
                               selector:_cmd];
}

- (VKRequest *)notificationsMarkeAsViewed:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKNotificationsMarkAsViewed
                                options:options
                               selector:_cmd];
}

#pragma mark - Stats

- (VKRequest *)statsGet:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKStatsGet
                                options:options
                               selector:_cmd];
}

#pragma mark - Search

- (VKRequest *)searchGetHints:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKSearchGetHints
                                options:options
                               selector:_cmd];
}

#pragma mark - Private methods

- (NSDictionary *)addAccessTokenKey:(NSDictionary *)options
{
    NSMutableDictionary *ops = [options mutableCopy];
    ops[@"access_token"] = self.user.accessToken.token;

    return ops;
}

- (VKRequest *)configureRequestMethod:(NSString *)methodName
                              options:(NSDictionary *)options
                             selector:(SEL)selector
{
    if (nil != self.user) {
        options = [self addAccessTokenKey:options];
    }

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
