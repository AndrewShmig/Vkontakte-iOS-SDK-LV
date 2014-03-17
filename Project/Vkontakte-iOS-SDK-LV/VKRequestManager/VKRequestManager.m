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


@implementation VKRequestManager

#pragma mark - Init

- (instancetype)initWithDelegate:(id <VKRequestDelegate>)delegate
                            user:(VKUser *)user
{
    VK_LOG(@"%@", @{
            @"delegate": delegate,
            @"user": user
    });

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
    if (!self.user) {
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
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)search:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKUsersSearch
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)subscriptions:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKUsersGetSubscriptions
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)followers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKUsersGetFollowers
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)isAppUser:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKUsersIsAppUser
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Wall

- (VKRequest *)wallGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKWallGet
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)wallGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKWallGetById
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)wallSavePost:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallSavePost
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)wallPost:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallPost
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)wallRepost:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallRepost
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)wallGetReposts:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKWallGetReposts
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)wallEdit:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallEdit
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)wallDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallDelete
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)wallRestore:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallRestore
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)wallGetComments:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKWallGetComments
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)wallAddComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallAddComment
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)wallDeleteComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallDeleteComment
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)wallRestoreComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKWallRestoreComment
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Groups

- (VKRequest *)groupsIsMember:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsIsMember
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)groupsGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsGetById
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)groupsGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsGet
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)groupsGetMembers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsGetMembers
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)groupsJoin:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsJoin
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)groupsLeave:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsLeave
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)groupsSearch:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsSearch
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)groupsGetInvites:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsGetInvites
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)groupsBanUser:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKGroupsBanUser
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)groupsUnbanUser:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKGroupsUnbanUser
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)groupsGetBanned:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKGroupsGetBanned
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Friends

- (VKRequest *)friendsGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGet
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)friendsGetOnline:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGetOnline
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)friendsGetMutual:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGetMutual
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)friendsGetRecent:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGetRecent
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)friendsGetRequests:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGetRequests
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)friendsAdd:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKFriendsAdd
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)friendsEdit:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKFriendsEdit
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)friendsDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKFriendsDelete
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)friendsGetLists:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGetLists
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)friendsAddList:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKFriendsAddList
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)friendsEditList:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKFriendsEditList
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)friendsDeleteList:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKFriendsDeleteList
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)friendsGetAppUsers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGetAppUsers
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)friendsGetByPhones:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGetByPhones
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)friendsDeleteAllRequests:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKFriendsDeleteAllRequests
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)friendsGetSuggestions:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsGetSuggestions
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)friendsAreFriends:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFriendsAreFriends
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Photos

- (VKRequest *)photosCreateAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosCreateAlbum
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosEditAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosEditAlbum
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetAlbums:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetAlbums
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGet
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetAlbumsCount:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetAlbumsCount
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetProfile:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetProfile
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetById
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestWithHTTPMethod:@"GET"
                                                   methodName:kVKPhotosGetUploadServer
                                                       option:options
                                                     selector:_cmd];
    request.cacheLiveTime = VKCacheLiveTimeNever;

    return request;
}

- (VKRequest *)photosGetProfileUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestWithHTTPMethod:@"GET"
                                                   methodName:kVKPhotosGetProfileUploadServer
                                                       option:options
                                                     selector:_cmd];

    request.cacheLiveTime = VKCacheLiveTimeNever;

    return request;
}

- (VKRequest *)photosGetChatUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestWithHTTPMethod:@"GET"
                                                   methodName:kVKPhotosGetChatUploadServer
                                                       option:options
                                                     selector:_cmd];

    request.cacheLiveTime = VKCacheLiveTimeNever;

    return request;
}

- (VKRequest *)photosSaveProfilePhoto:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosSaveProfilePhoto
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosSaveWallPhoto:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosSaveWallPhoto
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetWallUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestWithHTTPMethod:@"GET"
                                                   methodName:kVKPhotosGetWallUploadServer
                                                       option:options
                                                     selector:_cmd];
    request.cacheLiveTime = VKCacheLiveTimeNever;

    return request;
}

- (VKRequest *)photosGetMessagesUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestWithHTTPMethod:@"GET"
                                                   methodName:kVKPhotosGetMessagesUploadServer
                                                       option:options
                                                     selector:_cmd];
    request.cacheLiveTime = VKCacheLiveTimeNever;

    return request;
}

- (VKRequest *)photosSaveMessagesPhoto:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosSaveMessagesPhoto
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosSearch:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosSearch
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosSave:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosSave
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosEdit:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosEdit
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosMove:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosMove
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosMakeCover:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosMakeCover
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosReorderAlbums:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosReorderAlbums
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosReorderPhotos:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosReorderPhotos
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetAll:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetAll
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetUserPhotos:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetUserPhotos
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosDeleteAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosDeleteAlbum
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosDelete
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosConfirmTagWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosConfirmTag
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetComments:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetComments
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetAllComments:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetAllComments
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosCreateComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosCreateComment
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosDeleteComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosDeleteComment
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosRestoreComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosRestoreComment
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosEditComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosEditComment
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetTags:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetTags
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosPutTag:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosPutTag
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosRemoveTag:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPhotosRemoveTag
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)photosGetNewTags:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPhotosGetNewTags
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Video

- (VKRequest *)videoGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKVideoGet
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoEdit:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoEdit
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoAdd:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoAdd
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoSave:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoSave
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoDelete
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoRestore:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoRestore
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoSearch:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKVideoSearch
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoGetUserVideos:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKVideoGetUserVideos
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoGetAlbums:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKVideoGetAlbums
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoAddAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoAddAlbum
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoEditAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoEditAlbum
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoDeleteAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoDeleteAlbum
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoMoveToAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoMoveToAlbum
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoGetComments:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKVideoGetComments
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoCreateComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoCreateComment
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoDeleteComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoDeleteComment
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoRestoreComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoRestoreComment
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoEditComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoEditComment
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoGetTags:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKVideoGetTags
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoPutTag:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoPutTag
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoRemoveTag:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoRemoveTag
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoGetNewTags:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKVideoGetNewTags
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)videoReport:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKVideoReport
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Audio

- (VKRequest *)audioGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioGet
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioGetById
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioGetLyrics:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioGetLyrics
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioSearch:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioSearch
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioGetUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestWithHTTPMethod:@"GET"
                                                   methodName:kVKAudioGetUploadServer
                                                       option:options
                                                     selector:_cmd];
    request.cacheLiveTime = VKCacheLiveTimeNever;

    return request;
}

- (VKRequest *)audioSave:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioSave
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioAdd:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioAdd
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioDelete
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioEdit:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioEdit
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioReorder:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioReorder
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioRestore:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioRestore
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioGetAlbums:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioGetAlbums
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioAddAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioAddAlbum
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioEditAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioEditAlbum
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioDeleteAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioDeleteAlbum
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioMoveToAlbum:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioMoveToAlbum
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioSetBroadcast:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAudioSetBroadcast
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioGetBroadcastList:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioGetBroadcast
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioGetRecommendations:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioGetRecommendations
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioGetPopular:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioGetPopular
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)audioGetCount:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAudioGetCount
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Messages

- (VKRequest *)messagesGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGet
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesGetDialogs:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGetDialogs
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGetById
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesSearch:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesSearch
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesGetHistory:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGetHistory
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesSend:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesSend
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesDelete
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesDeleteDialog:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesDeleteDialog
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesRestore:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesRestore
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesMarkAsNew:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesMarkAsNew
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesMarkAsRead:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesMarkAsRead
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesMarkAsImportant:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesMarkAsImportant
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesGetLongPollServer:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGetLongPollServer
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesGetLongPollHistory:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGetLongPollHistory
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesGetChat:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGetChat
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesCreateChat:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesCreateChat
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesEditChat:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesEditChat
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesGetChatUsers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGetChatUsers
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesSetActivity:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesSetActivity
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesSearchDialogs:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesSearchDialogs
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesAddChatUser:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesAddChatUser
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesRemoveChatUser:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesRemoveChatUser
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesGetLastActivity:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKMessagesGetLastActivity
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesSetChatPhoto:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesSetChatPhoto
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)messagesDeleteChatPhoto:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKMessagesDeleteChatPhoto
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Newsfeed

- (VKRequest *)newsfeedGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNewsfeedGet
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedGetRecommended:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNewsfeedGetRecommended
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedGetComments:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNewsfeedGetComments
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedGetMentions:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNewsfeedGetMentions
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedGetBanned:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNewsfeedGetBanned
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedAddBan:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNewsfeedAddBan
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedDeleteBan:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNewsfeedDeleteBan
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedSearch:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNewsfeedSearch
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedGetLists:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNewsfeedGetLists
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)newsfeedUnsubscribe:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNewsfeedUnsubscribe
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Likes

- (VKRequest *)likesGetList:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKLikesGetList
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)likesAdd:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKLikesAdd
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)likesDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKLikesDelete
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)likesIsLiked:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKLikesIsLiked
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Account

- (VKRequest *)accountGetCounters:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAccountGetCounters
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)accountSetNameInMenu:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAccountSetNameInMenu
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)accountSetOnline:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAccountSetOnline
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)accountImportContacts:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAccountImportContacts
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)accountRegisterDevice:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAccountRegisterDevice
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)accountUnregisterDevice:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAccountUnregisterDevice
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)accountSetSilenceMode:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAccountSetSilenceMode
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)accountGetPushSettings:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAccountGetPushSettings
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)accountGetAppPermissions:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAccountGetAppPermissions
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)accountGetActiveOffers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAccountGetActiveOffers
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)accountBanUser:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAccountBanUser
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)accountUnbanUser:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAccountUnbanUser
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)accountGetBanned:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAccountGetBanned
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)accountTestValidation:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAccountTestValidation
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Status

- (VKRequest *)statusGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKStatusGet
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)statusSet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKStatusSet
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Pages

- (VKRequest *)pagesGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPagesGet
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)pagesSave:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPagesSave
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)pagesSaveAccess:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPagesSaveAccess
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)pagesGetHistory:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPagesGetHistory
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)pagesGetTitles:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPagesGetTitles
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)pagesGetVersion:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPagesGetVersion
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)pagesParseWiki:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPagesParseWiki
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Board

- (VKRequest *)boardGetTopics:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKBoardGetTopics
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)boardGetComments:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKBoardGetComments
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)boardAddTopic:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardAddTopic
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)boardAddComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardAddComment
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)boardDeleteTopic:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardDeleteTopic
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)boardEditTopic:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardEditTopic
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)boardEditComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardEditComment
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)boardRestoreComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardRestoreComment
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)boardDeleteComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardDeleteComment
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)boardOpenTopic:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardOpenTopic
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)boardCloseTopic:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardCloseTopic
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)boardFixTopic:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardFixTopic
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)boardUnfixTopic:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKBoardUnfixTopic
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Notes

- (VKRequest *)notesGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNotesGet
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)notesGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNotesGetById
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)notesGetFriendsNotes:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNotesGetFriendsNotes
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)notesAdd:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNotesAdd
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)notesEdit:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNotesEdit
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)notesDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNotesDelete
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)notesGetComments:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNotesGetComments
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)notesCreateComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNotesCreateComment
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)notesEditComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNotesEditComment
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)notesDeleteComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNotesDeleteComment
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)notesRestoreComment:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNotesRestoreComment
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Places

- (VKRequest *)placesAdd:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPlacesAdd
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetById
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)placesSearch:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesSearch
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)placesCheckIn:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPlacesCheckin
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetCheckins:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetCheckins
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetTypes:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetTypes
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetContries:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetCountries
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetRegions:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetRegions
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetStreetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetStreetById
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetCountryByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetCountryById
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetCities:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetCities
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)placesGetCityByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPlacesGetCityById
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Polls

- (VKRequest *)pollsGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPollsGetById
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)pollsAddVote:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPollsAddVote
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)pollsDeleteVote:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKPollsDeleteVote
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)pollsGetVoters:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKPollsGetVotes
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Docs

- (VKRequest *)docsGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDocsGet
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)docsGetByID:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDocsGetById
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)docsGetUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestWithHTTPMethod:@"GET"
                                                   methodName:kVKDocsGetUploadServer
                                                       option:options
                                                     selector:_cmd];
    request.cacheLiveTime = VKCacheLiveTimeNever;

    return request;
}

- (VKRequest *)docsGetWallUploadServer:(NSDictionary *)options
{
    VKRequest *request = [self configureRequestWithHTTPMethod:@"GET"
                                                   methodName:kVKDocsGetWallUloadServer
                                                       option:options
                                                     selector:_cmd];
    request.cacheLiveTime = VKCacheLiveTimeNever;

    return request;
}

- (VKRequest *)docsSave:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKDocsSave
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)docsDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKDocsDelete
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)docsAdd:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKDocsAdd
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Fave

- (VKRequest *)faveGetUsers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFaveGetUsers
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)faveGetPhotos:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFaveGetPhotos
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)faveGetPosts:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFaveGetPosts
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)faveGetVideos:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFaveGetVideos
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)faveGetLinks:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKFaveGetLinks
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Notifications

- (VKRequest *)notificationsGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKNotificationsGet
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)notificationsMarkeAsViewed:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKNotificationsMarkAsViewed
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Stats

- (VKRequest *)statsGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKStatsGet
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Search

- (VKRequest *)searchGetHints:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKSearchGetHints
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Ads

- (VKRequest *)adsGetAccounts:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetAccounts
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetClients:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetClients
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsCreateClients:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsCreateClients
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsUpdateClients:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsUpdateClients
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsDeleteClients:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsDeleteClients
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetCampaigns:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetCampaigns
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsCreateCampaigns:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsCreateCampaigns
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsUpdateCampaings:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsUpdateCampaigns
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsDeleteCampaings:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsDeleteCampaigns
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsGet:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetAds
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetLayout:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetAdsLayout
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetTargeting:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetAdsTargeting
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsCreate:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsCreateAds
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsUpdate:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsUpdateAds
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsDelete:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsDeleteAds
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetStatistics:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetStatistics
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetDemographics:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetDemographics
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetBudget:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetBudget
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetOfficeUsers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetOfficeUsers
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsAddOfficeUsers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsAddOfficeUsers
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsRemoveOfficeUsers:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsRemoveOfficeUsers
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetTargetingStats:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetTargetingStats
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetSuggestions:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetSuggestions
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetCategories:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetCategories
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetUploadURL:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetUploadURL
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetVideoUploadURL:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetVideoUploadURL
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetFloodStats:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetFloodStats
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetRejectionReason:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetRejectionReason
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsCreateTargetGroup:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsCreateTargetGroup
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsUpdateTargetGroup:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsUpdateTargetGroup
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsDeleteTargetGroup:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsDeleteTargetGroup
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsGetTargetGroups:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAdsGetTargetGroups
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)adsImportTargetContacts:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKAdsImportTargetContacts
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Execute

- (VKRequest *)execute:(NSString *)code
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKExecute
                                         option:@{
                                                 @"code": code
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
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Apps

- (VKRequest *)appsGetCatalog:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKAppsGetCatalog
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Utils

- (VKRequest *)utilsCheckLink:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"POST"
                                     methodName:kVKUtilsCheckLink
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)utilsResolveScreenName:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKUtilsResolveScreenName
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)utilsGetServerTime:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKUtilsGetServerTime
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Database

- (VKRequest *)databaseGetCountries:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetCountries
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)databaseGetRegions:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetRegions
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)databaseGetCities:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetCities
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)databaseGetCitiesById:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetCitiesById
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)databaseGetCountriesById:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetCountriesById
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)databaseGetFaculties:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetFaculties
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)databaseGetSchools:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetSchools
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)databaseGetStreetsById:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetStreetsById
                                         option:options
                                       selector:_cmd];
}

- (VKRequest *)databaseGetUniversities:(NSDictionary *)options
{
    return [self configureRequestWithHTTPMethod:@"GET"
                                     methodName:kVKDatabaseGetUniversities
                                         option:options
                                       selector:_cmd];
}

#pragma mark - Private methods

- (NSDictionary *)addAccessTokenKey:(NSDictionary *)options
{
    VK_LOG(@"%@", @{
            @"options": options
    });

    NSMutableDictionary *ops;
    ops = [options mutableCopy];

    ops[@"access_token"] = self.user.accessToken.token;

    return ops;
}

- (VKRequest *)configureRequestWithHTTPMethod:(NSString *)httpMethod
                                   methodName:(NSString *)methodName
                                       option:(NSDictionary *)options
                                     selector:(SEL)selector
{
    //    logging
    VK_LOG(@"%@", @{
            @"httpMethod": httpMethod,
            @"methodName": methodName,
            @"options": options,
            @"selector": NSStringFromSelector(selector)
    });

//    lets not work with nil values
    if(nil == options) {
        options = [[NSMutableDictionary alloc] init];
    }

//    adding access token if needed
    if (nil != self.user) {
        options = [self addAccessTokenKey:options];
    }

    VKRequest *req = [VKRequest requestHTTPMethod:httpMethod
                                       methodName:methodName
                                          options:options
                                         delegate:self.delegate];

    req.signature = NSStringFromSelector(selector);
    req.offlineMode = self.offlineMode;

    if (self.startAllRequestsImmediately)
        [req start];

    return req;
}

@end
