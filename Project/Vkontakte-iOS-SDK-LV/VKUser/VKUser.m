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
#import "VkontakteSDK_Logger.h"
#import "VKConnector.h"


@implementation VKUser
{
    VKStorageItem *_storageItem;
}

#pragma mark Visible VKUser methods
#pragma mark - Init methods

- (instancetype)initWithStorageItem:(VKStorageItem *)storageItem
{
    VK_LOG(@"%@", @{
            @"storageItem" : storageItem
    });

    self = [super init];

    if (self) {
        _storageItem = storageItem;
    }

    return self;
}

#pragma mark - Class methods

static VKUser *_currentUser;

+ (instancetype)currentUser
{
    VK_LOG();

//    пользователь установлен, но в хранилище его записи нет (возможно была удалена), а этого нельзя так оставлять - сбрасываем
    VKStorageItem *item = [[VKStorage sharedStorage]
                                      storageItemForUserID:_currentUser.accessToken.userID];

    if (nil == item) {
//        пользователь еще не был запрошен и не был установлен активным, либо
//        пользователь был удалён
        if (![[VKStorage sharedStorage] isEmpty]) {

//            хранилище содержит некоторые данные
//            устанавливаем произвольного пользователя активным
            VKStorageItem *storageItem = [[[VKStorage sharedStorage]
                                                      storageItems] lastObject];
            _currentUser = [[VKUser alloc] initWithStorageItem:storageItem];

        }
    } else {
//        обновление токена доступа текущего пользователя для случаев, когда до
//        этого имело место повторная авторизация пользователем приложения ВК
        _currentUser.accessToken = item.accessToken;
    }

    return _currentUser;
}

+ (BOOL)activateUserWithID:(NSUInteger)userID
{
    VK_LOG(@"%@", @{
            @"userID" : @(userID)
    });

    VKStorageItem *storageItem = [[VKStorage sharedStorage]
                                             storageItemForUserID:userID];

    if (nil == storageItem)
        return NO;

    _currentUser = [[VKUser alloc] initWithStorageItem:storageItem];

    return YES;
}

- (void)logout
{
    VK_LOG();

    if(nil == _currentUser)
        return;

//    чистим куки
    [[VKConnector sharedInstance] clearCookies];

//    находим нужную запись и удаляем из хранилища
    VKStorageItem *item = [[VKStorage sharedStorage]
                                      storageItemForUserID:_currentUser.accessToken.userID];
    [[VKStorage sharedStorage] removeItem:item];

//    обнуляем текущего пользователя
    _currentUser = nil;
}

+ (NSArray *)localUsers
{
    VK_LOG();

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

#pragma mark - Setters & Getters

- (VKAccessToken *)accessToken
{
    VK_LOG();

    return _storageItem.accessToken;
}

#pragma mark - Overridden methods

- (NSString *)description
{
    VK_LOG();

    return [_storageItem.accessToken description];
}

@end