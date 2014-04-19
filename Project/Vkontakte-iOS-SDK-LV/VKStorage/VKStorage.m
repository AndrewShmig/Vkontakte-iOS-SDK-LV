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
#import "VKStorage.h"
#import "VKUser.h"
#import "VkontakteSDK_Logger.h"


@implementation VKStorage
{
    NSMutableDictionary *_storageItems;
}

#pragma mark Visible VKStorage methods
#pragma mark - Init methods

- (instancetype)init
{
    VK_LOG();

    self = [super init];

    if (self) {
        _storageItems = [[NSMutableDictionary alloc] init];
    }

    return self;
}

#pragma mark - Shared storage

+ (instancetype)sharedStorage
{
    VK_LOG();

    static VKStorage *sharedStorage;
    static dispatch_once_t predicate;

    dispatch_once(&predicate, ^
    {
        sharedStorage = [[[self class] alloc] init];

//        проверим, если kVKStorageCachePath существует, если нет - создадим,
//        а параллельно будет создан и kVKStoragePath
        NSString *cacheStoragePath = [sharedStorage fullCacheStoragePath];

        if (![[NSFileManager defaultManager]
                             fileExistsAtPath:cacheStoragePath]) {

            [[NSFileManager defaultManager]
                            createDirectoryAtPath:cacheStoragePath
                      withIntermediateDirectories:YES
                                       attributes:nil
                                            error:nil];
        }
    });

    [sharedStorage loadStorage];

    return sharedStorage;
}

#pragma mark - Getters

- (BOOL)isEmpty
{
    VK_LOG();

    return ([_storageItems count] == 0);
}

- (NSUInteger)count
{
    VK_LOG();

    return [_storageItems count];
}

- (VKStorageItem *)createStorageItemForAccessToken:(VKAccessToken *)token
{
    VK_LOG();

    VKStorageItem *storageItem = [[VKStorageItem alloc]
                                                 initWithAccessToken:token
                                                mainCacheStoragePath:[self fullCacheStoragePath]];

    return storageItem;
}

- (NSArray *)storageItems
{
    VK_LOG();

    return [_storageItems allValues];
}

#pragma mark - Storage manipulation methods

- (void)storeItem:(VKStorageItem *)item
{
    VK_LOG(@"%@", @{
            @"item": item
    });

    if (nil == item || nil == item.accessToken || nil == item.cache)
        return;

//    удаляем данные предыдущей записи
    [self removeItem:item];

//    добавляем новые данные
    id storageKey = @(item.accessToken.userID);
    _storageItems[storageKey] = item;

    [self saveStorage];
}

- (void)removeItem:(VKStorageItem *)item
{
    VK_LOG(@"%@", @{
            @"item": item
    });

    id storageKey = @(item.accessToken.userID);

    [item.cache removeCacheDirectory];
    [_storageItems removeObjectForKey:storageKey];

    [self saveStorage];
}

- (void)clean
{
    VK_LOG();

    [_storageItems removeAllObjects];
    [self cleanCachedData];

    [self saveStorage];
}

- (void)cleanCachedData
{
    VK_LOG();

    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);

    dispatch_async(backgroundQueue, ^
    {

        [[NSFileManager defaultManager]
                        removeItemAtPath:[self fullCacheStoragePath]
                                   error:nil];

        [[NSFileManager defaultManager]
                        createDirectoryAtPath:[self fullCacheStoragePath]
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:nil];
    });
}

- (VKStorageItem *)storageItemForUserID:(NSUInteger)userID
{
    VK_LOG(@"%@", @{
            @"userID": @(userID)
    });

    id storageKey = @(userID);
    return _storageItems[storageKey];
}

- (VKStorageItem *)storageItemForUser:(VKUser *)user
{
    return [self storageItemForUserID:user.accessToken.userID];
}

#pragma mark - Storage paths

- (NSString *)fullStoragePath
{
    VK_LOG();

    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [cachePath stringByAppendingFormat:@"%@", kVKStoragePath];
}

- (NSString *)fullCacheStoragePath
{
    VK_LOG();

    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [cachePath stringByAppendingFormat:@"%@", kVKStorageCachePath];
}

#pragma mark - Storage hidden methods

- (void)loadStorage
{
    VK_LOG();

    NSDictionary *storageDefaults = [[NSUserDefaults standardUserDefaults]
                                                     objectForKey:kVKStorageUserDefaultsKey];

//    хранилище пустое, создаем
    if (nil == storageDefaults) {
        [[NSUserDefaults standardUserDefaults]
                         setObject:@{}
                            forKey:kVKStorageUserDefaultsKey];
    } else {
//        загрузка данных из хранилища
        NSDictionary *storage = [[NSUserDefaults standardUserDefaults]
                                                 objectForKey:kVKStorageUserDefaultsKey];

        [storage enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
        {
            VKAccessToken *token = [NSKeyedUnarchiver unarchiveObjectWithData:obj];

            VKStorageItem *storageItem = [[VKStorageItem alloc]
                                                         initWithAccessToken:token
                                                        mainCacheStoragePath:[self fullCacheStoragePath]];

            _storageItems[@(token.userID)] = storageItem;
        }];
    }
}

- (void)saveStorage
{
    VK_LOG();

//    сохраняем только данные токенов доступов
//    данные кэшев мы сможем потом просто восстановить
    NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *newStorage = [[NSMutableDictionary alloc] init];

    [_storageItems enumerateKeysAndObjectsUsingBlock:^(id key,
                                                       id obj,
                                                       BOOL *stop)
    {
        VKAccessToken *token = [(VKStorageItem *) obj accessToken];

        [newStorage setObject:[NSKeyedArchiver archivedDataWithRootObject:token]
                       forKey:[NSString stringWithFormat:@"%d", token.userID]];
    }];

    [myDefaults setObject:newStorage
                   forKey:kVKStorageUserDefaultsKey];

    [myDefaults synchronize];
}

@end