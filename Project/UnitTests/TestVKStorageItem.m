//
//  TestVKStorageItem.m
//  Project
//
//  Created by AndrewShmig on 6/30/13.
//  Copyright (c) 2013 AndrewShmig. All rights reserved.
//

#import "TestVKStorageItem.h"
#import "VKStorageItem.h"
#import "VKAccessToken.h"

@implementation TestVKStorageItem

- (void)testInitMethod1
{
    VKStorageItem *item = [[VKStorageItem alloc]
                                          initWithAccessToken:nil
                                         mainCacheStoragePath:@"/"];

    STAssertNil(item, @"Storage item should be nil");
}

- (void)testInitMethod2
{
    VKAccessToken *token = [[VKAccessToken alloc]
                                           initWithUserID:1
                                              accessToken:@"1"
                                                 liveTime:0
                                              permissions:@[@"offline",
                                                            @"friends"]];
    VKStorageItem *item = [[VKStorageItem alloc]
                                          initWithAccessToken:token
                                         mainCacheStoragePath:@"/"];

    STAssertNotNil(item, @"Storage item should not be nil");
}

- (void)testCachedDataInit
{
    VKAccessToken *token = [[VKAccessToken alloc] init];
    VKStorageItem *item = [[VKStorageItem alloc]
                                          initWithAccessToken:token
                                         mainCacheStoragePath:@"/"];

    STAssertNotNil(item.cachedData, @"Cache storage should not be nil");
}

@end
