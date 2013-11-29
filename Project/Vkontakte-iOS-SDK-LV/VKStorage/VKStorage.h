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


#import <Foundation/Foundation.h>
#import "VKStorageItem.h"
#import "VKAccessToken.h"


@class VKUser;


static NSString *const kVKStorageUserDefaultsKey = @"Vkontakte-iOS-SDK-Storage";
static NSString *const kVKStoragePath = @"/Vkontakte-iOS-SDK-Storage/";
static NSString *const kVKStorageCachePath = @"/Vkontakte-iOS-SDK-Storage/Cache/";


/** Class manages user access tokens and corresponding cached data.
*/
@interface VKStorage : NSObject

/**
@name Properties
*/
/** Is current storage empty?
*/
@property (nonatomic, readonly) BOOL isEmpty;

/** Size of VKStorage storage (number of objects in it)
*/
@property (nonatomic, readonly) NSUInteger count;

/** Full path to main storage directory
*/
@property (nonatomic, readonly) NSString *fullStoragePath;

/** Full path to main cache directory
*/
@property (nonatomic, readonly) NSString *fullCacheStoragePath;

/**
@name Initialization
*/
/** Shared storage

@return shared instance of VKStorage class
*/
+ (instancetype)sharedStorage;

/**
@name VKStorageItem creation
*/
/** Creates new VKStorageItem

@param token VKAccessToken for which new storage item will be created
@return instance of VKStorageItem
*/
- (VKStorageItem *)createStorageItemForAccessToken:(VKAccessToken *)token;

/**
@name Managing VKStorage items
*/
/** Adds new element to VKStorage

@param item new item to be added
*/
- (void)storeItem:(VKStorageItem *)item;

/** Removes VKStorageItem from VKStorage.

@param item item to remove from VKStorage
*/
- (void)removeItem:(VKStorageItem *)item;

/** Clears storage.
*/
- (void)clean;

/** Removes all cached data for all users.
*/
- (void)cleanCachedData;

/**
@name Obtaining VKStorageItems
*/
/** Returns user's corresponding VKStorageItem by unique user identifier

@param userID unique user identifier
@return instance of VKStorageItem, or nil, if there is no such.
*/
- (VKStorageItem *)storageItemForUserID:(NSUInteger)userID;

/** Returns user's corresponding VKStorageItem

@param user user object
@return instance of VKStorageItem, or nil, if there is no such.
*/
- (VKStorageItem *)storageItemForUser:(VKUser *)user;

/** List of all items in current storage

@return array of VKStorageItems
*/
- (NSArray *)storageItems;

@end