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
#import "VKCache.h"
#import "VkontakteSDK_Logger.h"


@implementation VKCache
{
    NSString *_cacheDirectoryPath;

    dispatch_queue_t _backgroundQueue;
}

#pragma mark Visible VKCache methods
#pragma mark - init methods

- (instancetype)initWithCacheDirectory:(NSString *)path
{
    VK_LOG(@"%@", @{
            @"path": path
    });

    self = [super init];

    if (self) {
        [self createDirectoryIfNotExists:path];
        _backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

        _cacheDirectoryPath = [path copy];
    }

    return self;
}

- (NSString *)description
{
    NSDictionary *desc = @{
            @"cacheDirectoryPath": _cacheDirectoryPath
    };

    return [desc description];
}

#pragma mark - cache manipulation

- (void)addCache:(NSData *)cache
          forURL:(NSURL *)url
{
    VK_LOG(@"%@", @{
            @"cache": cache,
            @"url": url
    });

    [self addCache:cache
            forURL:url
          liveTime:VKCacheLiveTimeOneHour];
}

- (void)addCache:(NSData *)cache
          forURL:(NSURL *)url
        liveTime:(VKCacheLiveTime)cacheLiveTime
{
    VK_LOG(@"%@", @{
            @"cache": cache,
            @"url": url,
            @"cacheLiveTime": @(cacheLiveTime)
    });

//    нет надобности сохранять в кэше запрос с таким временем жизни
    if(VKCacheLiveTimeNever == cacheLiveTime)
        return;

//    сохраняем данные запроса в кэше
    NSString *encodedCachedURL = [[url absoluteString] md5];
    NSString *filePath = [_cacheDirectoryPath stringByAppendingFormat:@"%@",
                                                                      encodedCachedURL];
    NSUInteger creationTimestamp = ((NSUInteger) [[NSDate date]
                                                          timeIntervalSince1970]);

    NSDictionary *options = @{@"liveTime"          : @(cacheLiveTime),
                              @"data"              : (cache == nil ? [NSNull null] : cache),
                              @"creationTimestamp" : @(creationTimestamp)};

    dispatch_async(_backgroundQueue, ^
    {
        [options writeToFile:filePath
                  atomically:YES];
    });
}

- (void)removeCacheForURL:(NSURL *)url
{
    VK_LOG(@"%@", @{
            @"url": url
    });

    NSString *encodedCachedURL = [[url absoluteString] md5];
    NSString *filePath = [_cacheDirectoryPath stringByAppendingFormat:@"%@",
                                                                      encodedCachedURL];

    dispatch_async(_backgroundQueue, ^
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath
                                                   error:nil];
    });
}

- (void)clear
{
    VK_LOG();

    dispatch_async(_backgroundQueue, ^{

        [[NSFileManager defaultManager]
                        removeItemAtPath:_cacheDirectoryPath
                                   error:nil];

        [[NSFileManager defaultManager]
                        createDirectoryAtPath:_cacheDirectoryPath
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:nil];

    });
}

- (void)removeCacheDirectory
{
    VK_LOG();

    dispatch_async(_backgroundQueue, ^{

        [[NSFileManager defaultManager] removeItemAtPath:_cacheDirectoryPath
                                                   error:nil];

    });
}

- (NSData *)cacheForURL:(NSURL *)url
{
    VK_LOG(@"%@", @{
            @"url": url
    });

    return [self cacheForURL:url
                 offlineMode:NO];
}

- (NSData *)cacheForURL:(NSURL *)url
            offlineMode:(BOOL)offlineMode
{
    VK_LOG(@"%@", @{
            @"url": url,
            @"offlineMode": @(offlineMode)
    });

    NSString *encodedCachedURL = [[url absoluteString] md5];
    NSString *filePath = [_cacheDirectoryPath stringByAppendingFormat:@"%@",
                                                                      encodedCachedURL];

    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        return nil;

//    загружаем файл, получаем свойства
    NSDictionary *cachedFile = [NSDictionary dictionaryWithContentsOfFile:filePath];

    VKCacheLiveTime liveTime = (VKCacheLiveTime) [cachedFile[@"liveTime"] integerValue];
    NSData *cachedData = cachedFile[@"data"];
    NSUInteger creationTimestamp = [cachedFile[@"creationTimestamp"] unsignedIntegerValue];

//    определяем наши действия в соответствии с указанным временем жизни кэша запроса
    NSUInteger currentTimestamp = ((NSUInteger) [[NSDate date]
                                                         timeIntervalSince1970]);
    if (!offlineMode && (creationTimestamp + liveTime) < currentTimestamp) {
        [self removeCacheForURL:url];
        return nil;
    }

//    кэш действителен
    return cachedData;
}

#pragma mark - private methods

- (void)createDirectoryIfNotExists:(NSString *)path
{
    VK_LOG(@"%@", @{
            @"path": path
    });

    if (![[NSFileManager defaultManager]
                         fileExistsAtPath:path]) {

        NSError *error;
        [[NSFileManager defaultManager]
                        createDirectoryAtPath:path
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&error];
    }
}

@end