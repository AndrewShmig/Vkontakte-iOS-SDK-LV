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

- (VKRequest *)infoWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKUsersGet
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)searchWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKUsersSearch
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)subscriptionsWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKUsersGetSubscriptions
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)followersWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKUsersGetFollowers
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

#pragma mark - Wall

- (VKRequest *)wallGetWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallGet
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)wallGetByIDWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallGetById
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)wallSavePostWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallSavePost
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallPostWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallPost
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallRepostWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallRepost
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallGetRepostsWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallGetReposts
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallEditWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallEdit
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallDeleteWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallDelete
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallRestoreWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallRestore
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallGetCommentsWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallGetComments
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallAddCommentWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallAddComment
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallDeleteCommentWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallDeleteComment
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)wallRestoreCommentWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKWallRestoreComment
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

#pragma mark - Groups

- (VKRequest *)groupsIsMemberWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsIsMember
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)groupsGetByIDWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsGetById
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)groupsGetWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsGet
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)groupsGetMembersWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsGetMembers
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)groupsJoinWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsJoin
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)groupsLeaveWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsLeave
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)groupsSearchWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsSearch
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)groupsGetInvitesWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsGetInvites
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)groupsBanUserWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsBanUser
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)groupsUnbanUserWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsUnbanUser
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)groupsGetBannedWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKGroupsGetBanned
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

#pragma mark - Friends

- (VKRequest *)friendsGetWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGet
                                options:options
                               selector:_cmd
                         addAccessToken:NO];
}

- (VKRequest *)friendsGetOnlineWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetOnline
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsGetMutualWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetMutual
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsGetRecentWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetRecent
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsGetRequestsWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetRequests
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsAddWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsAdd
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsEditWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsEdit
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsDeleteWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsDelete
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsGetListsWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetLists
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsAddListWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsAddList
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsEditListWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsEditList
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsDeleteListWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsDeleteList
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsGetAppUsersWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetAppUsers
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsGetByPhonesWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetByPhones
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsDeleteAllRequestsWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsDeleteAllRequests
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsGetSuggestionsWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsGetSuggestions
                                options:options
                               selector:_cmd
                         addAccessToken:YES];
}

- (VKRequest *)friendsAreFriendsWithCustomOptions:(NSDictionary *)options
{
    return [self configureRequestMethod:kVKFriendsAreFriends
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