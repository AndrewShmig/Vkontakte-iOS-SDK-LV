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
#import "VKCachedData.h"
#import "NSString+toBase64.h"
#import "NSString+toBase64.h"


#define NSLog //NSLog


@implementation VKCachedData
{
    NSString *_cacheDirectoryPath;

    dispatch_queue_t _backgroudQueue;
}

#pragma mark Visible VKCachedData methods
#pragma mark - init methods

- (instancetype)initWithCacheDirectory:(NSString *)path
{
    NSLog(@"%s", __FUNCTION__);

    self = [super init];

    if (self) {
        [self createDirectoryIfNotExists:path];
        _backgroudQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

        _cacheDirectoryPath = [path copy];
    }

    return self;
}

#pragma mark - cache manipulation

- (void)addCachedData:(NSData *)cache forURL:(NSURL *)url
{
    NSLog(@"%s", __FUNCTION__);

    NSString *encodedCachedURL = [[url absoluteString] toBase64];
    NSString *filePath = [_cacheDirectoryPath stringByAppendingFormat:@"%@",
                                                                      encodedCachedURL];
    NSUInteger creationTimestamp = ((NSUInteger) [[NSDate date]
                                                          timeIntervalSince1970]);

    NSDictionary *cacheRecord = @{@"liveTime"          : @(VKCachedDataLiveTimeNever),
                                  @"data"              : (cache == nil ? [NSNull null] : cache),
                                  @"creationTimestamp" : @(creationTimestamp)};

    dispatch_async(_backgroudQueue, ^
    {
        [cacheRecord writeToFile:filePath
                      atomically:YES];
    });
}

- (void)addCachedData:(NSData *)cache
               forURL:(NSURL *)url
             liveTime:(VKCachedDataLiveTime)cacheLiveTime
{
    NSLog(@"%s", __FUNCTION__);

    NSString *encodedCachedURL = [[url absoluteString] toBase64];
    NSString *filePath = [_cacheDirectoryPath stringByAppendingFormat:@"%@",
                                                                      encodedCachedURL];
    NSUInteger creationTimestamp = ((NSUInteger) [[NSDate date]
                                                          timeIntervalSince1970]);

    NSDictionary *options = @{@"liveTime"          : @(cacheLiveTime),
                              @"data"              : (cache == nil ? [NSNull null] : cache),
                              @"creationTimestamp" : @(creationTimestamp)};

    dispatch_async(_backgroudQueue, ^
    {
        [options writeToFile:filePath
                  atomically:YES];
    });
}

- (void)removeCachedDataForURL:(NSURL *)url
{
    NSLog(@"%s", __FUNCTION__);

    NSString *encodedCachedURL = [[url absoluteString] toBase64];
    NSString *filePath = [_cacheDirectoryPath stringByAppendingFormat:@"%@",
                                                                      encodedCachedURL];

    dispatch_async(_backgroudQueue, ^
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath
                                                   error:nil];
    });
}

- (void)clearCachedData
{
    NSLog(@"%s", __FUNCTION__);

    NSArray *cachedFiles = [[NSFileManager defaultManager]
                                           contentsOfDirectoryAtPath:_cacheDirectoryPath
                                                               error:nil];

    dispatch_async(_backgroudQueue, ^
    {
        for (NSString *fileName in cachedFiles) {
            NSString *filePath = [_cacheDirectoryPath stringByAppendingFormat:@"%@",
                                                                              fileName];

            [[NSFileManager defaultManager]
                            removeItemAtPath:filePath
                                       error:nil];
        }
    });
}

- (BOOL)containsCachedDataForURL:(NSURL *)url
{
    NSLog(@"%s", __FUNCTION__);

    NSString *encodedCachedURL = [[url absoluteString] toBase64];
    NSString *filePath = [_cacheDirectoryPath stringByAppendingFormat:@"%@",
                                                                      encodedCachedURL];

    return [[NSFileManager defaultManager]
                           fileExistsAtPath:filePath];
}

- (NSData *)cachedDataForURL:(NSURL *)url
{
    NSLog(@"%s", __FUNCTION__);

    NSString *encodedCachedURL = [[url absoluteString] toBase64];
    NSString *filePath = [_cacheDirectoryPath stringByAppendingFormat:@"%@",
                                                                      encodedCachedURL];

    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        return nil;

//    загружаем файл, получаем свойства
    NSDictionary *cachedFile = [NSDictionary dictionaryWithContentsOfFile:filePath];

    VKCachedDataLiveTime liveTime = (VKCachedDataLiveTime) [cachedFile[@"liveTime"] integerValue];
    NSData *cachedData = cachedFile[@"data"];
    NSUInteger creationTimestamp = [cachedFile[@"creationTimestamp"] unsignedIntegerValue];

//    определяем наши действия в соответствии с указанным временем жизни кэша запроса
    if (liveTime == VKCachedDataLiveTimeNever)
        return nil;

    if (liveTime == VKCachedDataLiveTimeForever)
        return cachedData;

    NSUInteger currentTimestamp = ((NSUInteger) [[NSDate date]
                                                         timeIntervalSince1970]);
    if ((creationTimestamp + liveTime) < currentTimestamp) {
        [self removeCachedDataForURL:url];
        return nil;
    }

//    кэш действителен
    return cachedData;
}

#pragma mark - private methods

- (void)createDirectoryIfNotExists:(NSString *)path
{
    NSLog(@"%s", __FUNCTION__);

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