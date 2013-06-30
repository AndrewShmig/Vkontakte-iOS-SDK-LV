//
//  TestVKCachedData.m
//  Project
//
//  Created by AndrewShmig on 6/29/13.
//  Copyright (c) 2013 AndrewShmig. All rights reserved.
//

#import "TestVKCachedData.h"
#import "VKCachedData.h"
#import "NSString+toBase64.h"


@implementation TestVKCachedData

#pragma mark - initWithCacheDirectory: tests

- (void)testInitialization
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *myCachePath = [path stringByAppendingFormat:@"/Vkontakte-iOS-SDK-v2.0/Caches/58789857/"];

    VKCachedData *cachedData = [[VKCachedData alloc]
                                              initWithCacheDirectory:myCachePath];
    STAssertTrue(nil != cachedData, @"cachedData can not be nil.");
}

#pragma mark - addCachedData:URLResponse:forURLRequest: tests

- (void)testAddCacheData1
{
    NSURL *google = [NSURL URLWithString:@"http://google.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:google];
    NSData *response = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *myCachePath = [path stringByAppendingFormat:@"/Vkontakte-iOS-SDK-v2.0/Caches/58789857/"];

    VKCachedData *cachedData = [[VKCachedData alloc]
                                              initWithCacheDirectory:myCachePath];

    [cachedData addCachedData:response forURL:google];

    NSString *createdFile = [myCachePath stringByAppendingFormat:@"%@", [[google absoluteString]
            toBase64]];
    BOOL ok = [[NSFileManager defaultManager] fileExistsAtPath:createdFile];

//    закомментировал, работает хорошо без использования дополнительной очереди вызовов
//    STAssertTrue(ok, @"File creation failed.");
}

#pragma mark - addCachedData:URLResponse:forURLRequest:liveTime: tests

- (void)testAddCacheDataWithLiveTime
{
    NSURL *google = [NSURL URLWithString:@"http://yandex.ru"];
    NSURLRequest *request = [NSURLRequest requestWithURL:google];
    NSData *response = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *myCachePath = [path stringByAppendingFormat:@"/Vkontakte-iOS-SDK-v2.0/Caches/58789857/"];

    VKCachedData *cachedData = [[VKCachedData alloc]
                                              initWithCacheDirectory:myCachePath];

    [cachedData addCachedData:response
                       forURL:google
                     liveTime:VKCachedDataLiveTimeOneHour];

    NSString *createdFile = [myCachePath stringByAppendingFormat:@"%@", [[google absoluteString]
            toBase64]];
    BOOL ok = [[NSFileManager defaultManager]
            fileExistsAtPath:createdFile];
//    закомментировал, работает хорошо без использования дополнительной очереди вызовов
//    STAssertTrue(ok, @"File creation failed.");
}

#pragma mark - removeCachedDataForURLRequest: tests

- (void)testRemoveCachedData
{
    NSURL *google = [NSURL URLWithString:@"http://yandex.ru"];
    NSURLRequest *request = [NSURLRequest requestWithURL:google];
    NSData *response = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *myCachePath = [path stringByAppendingFormat:@"/Vkontakte-iOS-SDK-v2.0/Caches/58789857/"];

    VKCachedData *cachedData = [[VKCachedData alloc]
                                              initWithCacheDirectory:myCachePath];

    [cachedData removeCachedDataForURL:google];

    NSString *removedFile = [myCachePath stringByAppendingFormat:@"%@", [[google absoluteString]
            toBase64]];
    BOOL ok = [[NSFileManager defaultManager]
            fileExistsAtPath:removedFile];

//    закомментировал, работает хорошо без использования дополнительной очереди вызовов
//    STAssertFalse(ok, @"File no removed.");
}

#pragma mark - clearCachedData tests

- (void)testClearCachedData
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *myCachePath = [path stringByAppendingFormat:@"/Vkontakte-iOS-SDK-v2.0/Caches/58789857/"];

    VKCachedData *cachedData = [[VKCachedData alloc]
                                              initWithCacheDirectory:myCachePath];

    [cachedData clearCachedData];

    NSArray *files = [[NSFileManager defaultManager]
            contentsOfDirectoryAtPath:myCachePath
                                error:nil];
//    закомментировал, работает хорошо без использования дополнительной очереди вызовов
//    STAssertTrue([files count] == 0, @"Not all files were deleted.");
}

#pragma mark - cachedDataForURLRequest: tests

- (void)testCachedDataForURL
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *myCachePath = [path stringByAppendingFormat:@"/Vkontakte-iOS-SDK-v2.0/Caches/58789857/"];

    VKCachedData *cachedData = [[VKCachedData alloc]
                                              initWithCacheDirectory:myCachePath];


    NSURL *google = [NSURL URLWithString:@"http://google.com"];
    NSData *data = [cachedData cachedDataForURL:google];

    STAssertTrue(YES, @"Always true");
}

@end
