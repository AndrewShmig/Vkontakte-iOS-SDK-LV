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
#import "VKRequestManager.h"
#import "VkontakteSDK_Logger.h"
#import "VKMethods.h"


@implementation VKRequestManager

#pragma mark - Init

- (instancetype)initWithDelegate:(id <VKRequestDelegate>)delegate
                            user:(VKUser *)user
{
    VK_LOG(@"%@", @{
            @"delegate" : delegate,
            @"user"     : user
    });

    self = [super init];

    if (self) {
        _delegate = delegate;
        _user = user;
        _startAllRequestsImmediately = YES;
    }

    return self;
}

- (instancetype)initWithDelegate:(id <VKRequestDelegate>)delegate
{
    return [self initWithDelegate:delegate
                             user:nil];
}

#pragma mark - Users

- (VKRequest *)info
{
    if (nil == self.user) {
        return nil;
    }

    NSDictionary *options = @{
            @"uids"   : @(self.user.accessToken.userID),
            @"fields" : @"nickname,screen_name,sex,bdate,has_mobile,online,last_seen,status,photo_100"
    };

    return [self info:options];
}

- (VKRequest *)info:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKUsersGet
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)search:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKUsersSearch
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)subscriptions:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKUsersGetSubscriptions
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)followers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKUsersGetFollowers
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)isAppUser:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKUsersIsAppUser
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Wall

- (VKRequest *)wallGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKWallGet
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)wallGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKWallGetById
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)wallSavePost:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallSavePost
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)wallPost:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallPost
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)wallRepost:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallRepost
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)wallGetReposts:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKWallGetReposts
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)wallEdit:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallEdit
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)wallDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallDelete
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)wallRestore:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallRestore
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)wallGetComments:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKWallGetComments
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)wallAddComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallAddComment
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)wallDeleteComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallDeleteComment
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)wallRestoreComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallRestoreComment
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Groups

- (VKRequest *)groupsIsMember:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsIsMember
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)groupsGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsGetById
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)groupsGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsGet
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)groupsGetMembers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsGetMembers
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)groupsJoin:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsJoin
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)groupsLeave:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsLeave
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)groupsSearch:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsSearch
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)groupsGetInvites:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsGetInvites
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)groupsBanUser:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKGroupsBanUser
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)groupsUnbanUser:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKGroupsUnbanUser
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)groupsGetBanned:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsGetBanned
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Friends

- (VKRequest *)friendsGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGet
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)friendsGetOnline:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGetOnline
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)friendsGetMutual:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGetMutual
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)friendsGetRecent:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGetRecent
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)friendsGetRequests:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGetRequests
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)friendsAdd:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKFriendsAdd
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)friendsEdit:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKFriendsEdit
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)friendsDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKFriendsDelete
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)friendsGetLists:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGetLists
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)friendsAddList:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKFriendsAddList
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)friendsEditList:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKFriendsEditList
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)friendsDeleteList:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKFriendsDeleteList
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)friendsGetAppUsers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGetAppUsers
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)friendsGetByPhones:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGetByPhones
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)friendsDeleteAllRequests:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKFriendsDeleteAllRequests
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)friendsGetSuggestions:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGetSuggestions
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)friendsAreFriends:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsAreFriends
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Photos

- (VKRequest *)photosCreateAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosCreateAlbum
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosEditAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosEditAlbum
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetAlbums:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetAlbums
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGet
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetAlbumsCount:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetAlbumsCount
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetProfile:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetProfile
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetById
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestWithHTTPMethod:@"GET"
                                                   methodName:kVKPhotosGetUploadServer
                                              queryParameters:options
                                                     selector:_cmd];
    request.cacheLiveTime = VKCacheLiveTimeNever;

    return request;
}

- (VKRequest *)photosGetProfileUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestWithHTTPMethod:@"GET"
                                                   methodName:kVKPhotosGetProfileUploadServer
                                              queryParameters:options
                                                     selector:_cmd];

    request.cacheLiveTime = VKCacheLiveTimeNever;

    return request;
}

- (VKRequest *)photosGetChatUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestWithHTTPMethod:@"GET"
                                                   methodName:kVKPhotosGetChatUploadServer
                                              queryParameters:options
                                                     selector:_cmd];

    request.cacheLiveTime = VKCacheLiveTimeNever;

    return request;
}

- (VKRequest *)photosSaveProfilePhoto:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosSaveProfilePhoto
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosSaveWallPhoto:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosSaveWallPhoto
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetWallUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestWithHTTPMethod:@"GET"
                                                   methodName:kVKPhotosGetWallUploadServer
                                              queryParameters:options
                                                     selector:_cmd];
    request.cacheLiveTime = VKCacheLiveTimeNever;

    return request;
}

- (VKRequest *)photosGetMessagesUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestWithHTTPMethod:@"GET"
                                                   methodName:kVKPhotosGetMessagesUploadServer
                                              queryParameters:options
                                                     selector:_cmd];
    request.cacheLiveTime = VKCacheLiveTimeNever;

    return request;
}

- (VKRequest *)photosSaveMessagesPhoto:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosSaveMessagesPhoto
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosSearch:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosSearch
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosSave:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosSave
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosEdit:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosEdit
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosMove:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosMove
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosMakeCover:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosMakeCover
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosReorderAlbums:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosReorderAlbums
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosReorderPhotos:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosReorderPhotos
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetAll:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetAll
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetUserPhotos:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetUserPhotos
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosDeleteAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosDeleteAlbum
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosDelete
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosConfirmTagWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosConfirmTag
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetComments:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetComments
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetAllComments:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetAllComments
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosCreateComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosCreateComment
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosDeleteComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosDeleteComment
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosRestoreComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosRestoreComment
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosEditComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosEditComment
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetTags:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetTags
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosPutTag:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosPutTag
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosRemoveTag:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosRemoveTag
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetNewTags:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetNewTags
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Video

- (VKRequest *)videoGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKVideoGet
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoEdit:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoEdit
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoAdd:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoAdd
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoSave:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoSave
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoDelete
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoRestore:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoRestore
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoSearch:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKVideoSearch
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoGetUserVideos:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKVideoGetUserVideos
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoGetAlbums:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKVideoGetAlbums
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoAddAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoAddAlbum
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoEditAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoEditAlbum
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoDeleteAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoDeleteAlbum
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoMoveToAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoMoveToAlbum
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoGetComments:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKVideoGetComments
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoCreateComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoCreateComment
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoDeleteComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoDeleteComment
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoRestoreComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoRestoreComment
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoEditComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoEditComment
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoGetTags:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKVideoGetTags
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoPutTag:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoPutTag
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoRemoveTag:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoRemoveTag
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoGetNewTags:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKVideoGetNewTags
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)videoReport:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoReport
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Audio

- (VKRequest *)audioGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioGet
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioGetById
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioGetLyrics:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioGetLyrics
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioSearch:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioSearch
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioGetUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestWithHTTPMethod:@"GET"
                                                   methodName:kVKAudioGetUploadServer
                                              queryParameters:options
                                                     selector:_cmd];
    request.cacheLiveTime = VKCacheLiveTimeNever;

    return request;
}

- (VKRequest *)audioSave:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioSave
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioAdd:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioAdd
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioDelete
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioEdit:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioEdit
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioReorder:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioReorder
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioRestore:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioRestore
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioGetAlbums:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioGetAlbums
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioAddAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioAddAlbum
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioEditAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioEditAlbum
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioDeleteAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioDeleteAlbum
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioMoveToAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioMoveToAlbum
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioSetBroadcast:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioSetBroadcast
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioGetBroadcastList:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioGetBroadcast
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioGetRecommendations:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioGetRecommendations
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioGetPopular:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioGetPopular
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)audioGetCount:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioGetCount
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Messages

- (VKRequest *)messagesGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGet
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesGetDialogs:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGetDialogs
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGetById
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesSearch:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesSearch
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesGetHistory:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGetHistory
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesSend:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesSend
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesDelete
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesDeleteDialog:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesDeleteDialog
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesRestore:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesRestore
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesMarkAsNew:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesMarkAsNew
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesMarkAsRead:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesMarkAsRead
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesMarkAsImportant:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesMarkAsImportant
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesGetLongPollServer:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGetLongPollServer
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesGetLongPollHistory:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGetLongPollHistory
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesGetChat:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGetChat
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesCreateChat:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesCreateChat
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesEditChat:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesEditChat
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesGetChatUsers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGetChatUsers
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesSetActivity:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesSetActivity
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesSearchDialogs:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesSearchDialogs
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesAddChatUser:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesAddChatUser
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesRemoveChatUser:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesRemoveChatUser
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesGetLastActivity:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGetLastActivity
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesSetChatPhoto:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesSetChatPhoto
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)messagesDeleteChatPhoto:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesDeleteChatPhoto
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Newsfeed

- (VKRequest *)newsfeedGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNewsfeedGet
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedGetRecommended:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNewsfeedGetRecommended
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedGetComments:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNewsfeedGetComments
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedGetMentions:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNewsfeedGetMentions
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedGetBanned:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNewsfeedGetBanned
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedAddBan:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNewsfeedAddBan
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedDeleteBan:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNewsfeedDeleteBan
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedSearch:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNewsfeedSearch
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedGetLists:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNewsfeedGetLists
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedUnsubscribe:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNewsfeedUnsubscribe
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Likes

- (VKRequest *)likesGetList:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKLikesGetList
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)likesAdd:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKLikesAdd
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)likesDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKLikesDelete
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)likesIsLiked:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKLikesIsLiked
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Account

- (VKRequest *)accountGetCounters:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAccountGetCounters
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)accountSetNameInMenu:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAccountSetNameInMenu
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)accountSetOnline:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAccountSetOnline
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)accountImportContacts:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAccountImportContacts
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)accountRegisterDevice:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAccountRegisterDevice
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)accountUnregisterDevice:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAccountUnregisterDevice
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)accountSetSilenceMode:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAccountSetSilenceMode
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)accountGetPushSettings:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAccountGetPushSettings
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)accountGetAppPermissions:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAccountGetAppPermissions
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)accountGetActiveOffers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAccountGetActiveOffers
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)accountBanUser:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAccountBanUser
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)accountUnbanUser:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAccountUnbanUser
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)accountGetBanned:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAccountGetBanned
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)accountTestValidation:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAccountTestValidation
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Status

- (VKRequest *)statusGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKStatusGet
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)statusSet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKStatusSet
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Pages

- (VKRequest *)pagesGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPagesGet
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)pagesSave:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPagesSave
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)pagesSaveAccess:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPagesSaveAccess
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)pagesGetHistory:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPagesGetHistory
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)pagesGetTitles:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPagesGetTitles
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)pagesGetVersion:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPagesGetVersion
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)pagesParseWiki:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPagesParseWiki
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Board

- (VKRequest *)boardGetTopics:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKBoardGetTopics
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)boardGetComments:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKBoardGetComments
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)boardAddTopic:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardAddTopic
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)boardAddComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardAddComment
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)boardDeleteTopic:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardDeleteTopic
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)boardEditTopic:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardEditTopic
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)boardEditComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardEditComment
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)boardRestoreComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardRestoreComment
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)boardDeleteComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardDeleteComment
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)boardOpenTopic:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardOpenTopic
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)boardCloseTopic:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardCloseTopic
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)boardFixTopic:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardFixTopic
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)boardUnfixTopic:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardUnfixTopic
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Notes

- (VKRequest *)notesGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNotesGet
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)notesGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNotesGetById
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)notesGetFriendsNotes:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNotesGetFriendsNotes
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)notesAdd:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNotesAdd
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)notesEdit:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNotesEdit
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)notesDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNotesDelete
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)notesGetComments:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNotesGetComments
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)notesCreateComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNotesCreateComment
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)notesEditComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNotesEditComment
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)notesDeleteComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNotesDeleteComment
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)notesRestoreComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNotesRestoreComment
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Places

- (VKRequest *)placesAdd:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPlacesAdd
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetById
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)placesSearch:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesSearch
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)placesCheckIn:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPlacesCheckin
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetCheckins:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetCheckins
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetTypes:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetTypes
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetContries:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetCountries
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetRegions:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetRegions
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetStreetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetStreetById
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetCountryByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetCountryById
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetCities:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetCities
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetCityByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetCityById
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Polls

- (VKRequest *)pollsGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPollsGetById
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)pollsAddVote:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPollsAddVote
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)pollsDeleteVote:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPollsDeleteVote
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)pollsGetVoters:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPollsGetVotes
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Docs

- (VKRequest *)docsGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDocsGet
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)docsGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDocsGetById
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)docsGetUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestWithHTTPMethod:@"GET"
                                                   methodName:kVKDocsGetUploadServer
                                              queryParameters:options
                                                     selector:_cmd];
    request.cacheLiveTime = VKCacheLiveTimeNever;

    return request;
}

- (VKRequest *)docsGetWallUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestWithHTTPMethod:@"GET"
                                                   methodName:kVKDocsGetWallUloadServer
                                              queryParameters:options
                                                     selector:_cmd];
    request.cacheLiveTime = VKCacheLiveTimeNever;

    return request;
}

- (VKRequest *)docsSave:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKDocsSave
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)docsDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKDocsDelete
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)docsAdd:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKDocsAdd
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Fave

- (VKRequest *)faveGetUsers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFaveGetUsers
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)faveGetPhotos:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFaveGetPhotos
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)faveGetPosts:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFaveGetPosts
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)faveGetVideos:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFaveGetVideos
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)faveGetLinks:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFaveGetLinks
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Notifications

- (VKRequest *)notificationsGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNotificationsGet
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)notificationsMarkeAsViewed:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNotificationsMarkAsViewed
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Stats

- (VKRequest *)statsGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKStatsGet
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Search

- (VKRequest *)searchGetHints:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKSearchGetHints
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Ads

- (VKRequest *)adsGetAccounts:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetAccounts
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetClients:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetClients
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsCreateClients:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsCreateClients
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsUpdateClients:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsUpdateClients
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsDeleteClients:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsDeleteClients
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetCampaigns:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetCampaigns
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsCreateCampaigns:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsCreateCampaigns
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsUpdateCampaings:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsUpdateCampaigns
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsDeleteCampaings:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsDeleteCampaigns
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetAds
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetLayout:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetAdsLayout
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetTargeting:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetAdsTargeting
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsCreate:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsCreateAds
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsUpdate:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsUpdateAds
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsDeleteAds
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetStatistics:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetStatistics
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetDemographics:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetDemographics
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetBudget:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetBudget
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetOfficeUsers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetOfficeUsers
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsAddOfficeUsers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsAddOfficeUsers
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsRemoveOfficeUsers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsRemoveOfficeUsers
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetTargetingStats:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetTargetingStats
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetSuggestions:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetSuggestions
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetCategories:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetCategories
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetUploadURL:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetUploadURL
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetVideoUploadURL:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetVideoUploadURL
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetFloodStats:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetFloodStats
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetRejectionReason:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetRejectionReason
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsCreateTargetGroup:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsCreateTargetGroup
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsUpdateTargetGroup:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsUpdateTargetGroup
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsDeleteTargetGroup:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsDeleteTargetGroup
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetTargetGroups:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetTargetGroups
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)adsImportTargetContacts:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsImportTargetContacts
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Execute

- (VKRequest *)execute:(NSString *)code
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKExecute
                                queryParameters:@{
                                        @"code" : code
                                }
                                       selector:_cmd];
}

- (VKRequest *)executePredefinedProcedureWithName:(NSString *)procedureName
                                          options:(NSDictionary *)options
{
    NSString *methodName = [NSString stringWithFormat:@"%@.%@",
                                                      kVKExecute,
                                                      procedureName];

    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:methodName
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Apps

- (VKRequest *)appsGetCatalog:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAppsGetCatalog
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Utils

- (VKRequest *)utilsCheckLink:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKUtilsCheckLink
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)utilsResolveScreenName:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKUtilsResolveScreenName
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)utilsGetServerTime:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKUtilsGetServerTime
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Database

- (VKRequest *)databaseGetCountries:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetCountries
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)databaseGetRegions:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetRegions
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)databaseGetCities:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetCities
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)databaseGetCitiesById:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetCitiesById
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)databaseGetCountriesById:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetCountriesById
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)databaseGetFaculties:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetFaculties
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)databaseGetSchools:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetSchools
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)databaseGetStreetsById:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetStreetsById
                                queryParameters:options
                                       selector:_cmd];
}

- (VKRequest *)databaseGetUniversities:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetUniversities
                                queryParameters:options
                                       selector:_cmd];
}

#pragma mark - Private methods

- (VKRequest *)configureRequestWithHTTPMethod:(NSString *)httpMethod
                                   methodName:(NSString *)methodName
                              queryParameters:(NSDictionary *)queryParameters
                                     selector:(SEL)selector
{
    //    logging
    VK_LOG(@"%@", @{
            @"httpMethod"      : httpMethod,
            @"methodName"      : methodName,
            @"queryParameters" : queryParameters,
            @"selector"        : NSStringFromSelector(selector)
    });

//    lets not work with nil values
    if (nil == queryParameters) {
        queryParameters = [NSMutableDictionary new];
    } else {
        queryParameters = [queryParameters mutableCopy];
    }

    VKRequest *req = [VKRequest requestHTTPMethod:httpMethod
                                       methodName:methodName
                                  queryParameters:queryParameters
                                         delegate:self.delegate];

    req.signature = NSStringFromSelector(selector);
    req.offlineMode = self.offlineMode;
    req.requestManager = self;

    if (self.startAllRequestsImmediately)
        [req start];

    return req;
}

@end
