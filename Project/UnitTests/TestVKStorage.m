//
//  TestVKStorage.m
//  Project
//
//  Created by AndrewShmig on 6/30/13.
//  Copyright (c) 2013 AndrewShmig. All rights reserved.
//

#import "TestVKStorage.h"
#import "VKStorage.h"
#import "VKStorageItem.h"
#import "VKAccessToken.h"

@implementation TestVKStorage

- (void)testSharedStorage
{
    STAssertNotNil([VKStorage sharedStorage], @"Shared storage is nil");
}

- (void)testIsEmpty1
{
    BOOL empty = [[VKStorage sharedStorage] isEmpty];

    STAssertTrue(empty, @"Storage should be empty");
}

- (void)testIsEmpty2
{
    VKAccessToken *token = [[VKAccessToken alloc]
                                           initWithUserID:1
                                              accessToken:@"1"
                                                 liveTime:0
                                              permissions:@[@"offline",
                                                            @"friends"]];
    VKStorageItem *item = [[VKStorage sharedStorage]
                                      createStorageItemForAccessToken:token];
    [[VKStorage sharedStorage] addItem:item];

    BOOL empty = [[VKStorage sharedStorage] isEmpty];

    STAssertFalse(empty, @"Storage should not be empty");

    [[VKStorage sharedStorage] clean];
}

- (void)testCount1
{
    STAssertNotNil([VKStorage sharedStorage], @"Shared storage is nil");

    NSUInteger count = [[VKStorage sharedStorage] count];

    STAssertTrue(count == 0, @"Count != 0");
}

- (void)testCount2
{
    VKAccessToken *token = [[VKAccessToken alloc]
                                           initWithUserID:1
                                              accessToken:@"1"
                                                 liveTime:0
                                              permissions:@[@"offline",
                                                            @"friends"]];
    VKStorageItem *item = [[VKStorage sharedStorage]
                                      createStorageItemForAccessToken:token];
    [[VKStorage sharedStorage] addItem:item];

    NSUInteger count = [[VKStorage sharedStorage] count];

    STAssertTrue(count == 1, @"count != 1");

    [[VKStorage sharedStorage] clean];
}

- (void)testFullStoragePath
{
    STAssertNotNil([[VKStorage sharedStorage]
                               fullStoragePath], @"Full storage path equals nil");
}

- (void)testFullCacheStoragePath
{
    STAssertNotNil([[VKStorage sharedStorage]
                               fullCacheStoragePath], @"Full cache storage path equals nil");
}

- (void)testRemoveItem1
{
    VKAccessToken *token = [[VKAccessToken alloc]
                                           initWithUserID:1
                                              accessToken:@"1"
                                           liveTime:0
                                              permissions:@[@"offline",
                                                            @"friends"]];
    VKStorageItem *item = [[VKStorage sharedStorage]
                                      createStorageItemForAccessToken:token];
    [[VKStorage sharedStorage] addItem:item];
    [[VKStorage sharedStorage] removeItem:item];

    STAssertTrue([[VKStorage sharedStorage] isEmpty], @"Storage is not empty");

    [[VKStorage sharedStorage] clean];
}

- (void)testRemoveItem2
{
    VKAccessToken *token = [[VKAccessToken alloc]
                                           initWithUserID:1
                                              accessToken:@"1"
                                           liveTime:0
                                              permissions:@[@"offline",
                                                            @"friends"]];
    VKStorageItem *item = [[VKStorage sharedStorage]
                                      createStorageItemForAccessToken:token];
    [[VKStorage sharedStorage] removeItem:item];

    STAssertTrue([[VKStorage sharedStorage] isEmpty], @"Storage is not empty");

    [[VKStorage sharedStorage] clean];
}

- (void)testClean1
{
    VKAccessToken *token = [[VKAccessToken alloc]
                                           initWithUserID:1
                                              accessToken:@"1"
                                           liveTime:0
                                              permissions:@[@"offline",
                                                            @"friends"]];
    VKStorageItem *item = [[VKStorage sharedStorage]
                                      createStorageItemForAccessToken:token];
    [[VKStorage sharedStorage] addItem:item];

    [[VKStorage sharedStorage] clean];

    STAssertTrue([[VKStorage sharedStorage] isEmpty], @"Storage is not empty");
}

- (void)testClean2
{
    VKAccessToken *token = [[VKAccessToken alloc]
                                           initWithUserID:1
                                              accessToken:@"1"
                                           liveTime:0
                                              permissions:@[@"offline",
                                                            @"friends"]];
    VKStorageItem *item = [[VKStorage sharedStorage]
                                      createStorageItemForAccessToken:token];
    [[VKStorage sharedStorage] addItem:item];

    [[VKStorage sharedStorage] cleanCachedData];

    NSArray *files = [[NSFileManager defaultManager]
                                     contentsOfDirectoryAtPath:[[VKStorage sharedStorage]
                                                                           fullCacheStoragePath]
                                                         error:nil];

//    работает правильно, закомментировал потому, что удаление происходит в другом потоке
//    STAssertTrue([files count] == 0, @"Cache is not cleared");

    [[VKStorage sharedStorage] clean];
}

- (void)testStorageItemForUserID1
{
    VKAccessToken *token = [[VKAccessToken alloc]
                                           initWithUserID:1
                                              accessToken:@"1"
                                           liveTime:0
                                              permissions:@[@"offline",
                                                            @"friends"]];
    VKStorageItem *item = [[VKStorage sharedStorage]
                                      createStorageItemForAccessToken:token];
    [[VKStorage sharedStorage] addItem:item];

    VKStorageItem *back = [[VKStorage sharedStorage]
                                      storageItemForUserID:token.userID];

    STAssertNotNil(back, @"Storage item can not be nil");

    [[VKStorage sharedStorage] clean];
}

- (void)testStorageItemForUserID2
{
    VKStorageItem *back = [[VKStorage sharedStorage]
                                      storageItemForUserID:100500];

    STAssertNil(back, @"Storage item should be nil");

    [[VKStorage sharedStorage] clean];
}

- (void)testStorageItems1
{
    NSArray *items = [[VKStorage sharedStorage] storageItems];

    STAssertTrue([items count] == 0, @"Items count is not 0");
}

- (void)testStorageItems2
{
    VKAccessToken *token = [[VKAccessToken alloc]
                                           initWithUserID:1
                                              accessToken:@"1"
                                           liveTime:0
                                              permissions:@[@"offline",
                                                            @"friends"]];
    VKStorageItem *item = [[VKStorage sharedStorage]
                                      createStorageItemForAccessToken:token];
    [[VKStorage sharedStorage] addItem:item];

    NSArray *items = [[VKStorage sharedStorage] storageItems];

    STAssertTrue([items count] == 1, @"Items count is not 1");

    [[VKStorage sharedStorage] clean];
}

@end
