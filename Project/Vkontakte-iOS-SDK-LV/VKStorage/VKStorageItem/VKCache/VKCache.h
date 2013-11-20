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
#import "NSString+Utilities.h"


/** Possible lifetimes of cached data.
*/
typedef enum
{
    VKCacheLiveTimeNever = 0,
    VKCacheLiveTimeOneMinute = 60,
    VKCacheLiveTimeThreeMinutes = 3 * 60,
    VKCacheLiveTimeFiveMinutes = 5 * 60,
    VKCacheLiveTimeOneHour = 1 * 60 * 60,
    VKCacheLiveTimeFiveHours = 5 * 60 * 60,
    VKCacheLiveTimeOneDay = 24 * 60 * 60,
    VKCacheLiveTimeOneWeek = 7 * 24 * 60 * 60,
    VKCacheLiveTimeOneMonth = 30 * 24 * 60 * 60,
    VKCacheLiveTimeOneYear = 365 * 24 * 60 * 60,
} VKCacheLiveTime;


/** Current class manages cached responses' data. Cached data are saved in
directory which was selected during initialization process.
*/
@interface VKCache : NSObject

/**
@name Initialization methods
*/
/** Initialization methods

@param path directory where would be saved cached data. If there is no such
directory then it's going to be created.
@return instance of VKCache
*/
- (instancetype)initWithCacheDirectory:(NSString *)path;

/**
@name Methods to manage cached data
*/
/** Current method adds new data to cached data directory

Life time of current cached data defaults to one hour.

@param cache data which should be cached
@param url URL that corresponds to cached data
*/
- (void)addCache:(NSData *)cache
          forURL:(NSURL *)url;

/** Current method adds new data to cached data directory

@param cache data which should be cached
@param url URL that corresponds to cached data
@param cacheLiveTime life time of current cached data (possible values: VKCacheLiveTimeOneHour,
VKCacheLiveTimeOneDay, VKCacheLiveTimeForever etc).
*/
- (void)addCache:(NSData *)cache
          forURL:(NSURL *)url
        liveTime:(VKCacheLiveTime)cacheLiveTime;

/** Removes cached data by its URL

@param url URL that corresponds to cached data which needs to be removed
*/
- (void)removeCacheForURL:(NSURL *)url;

/** Removes all cached data in a directory which were used for initialization.
*/
- (void)clear;

/** Removes directory with all cached data.
*/
- (void)removeCacheDirectory;

/**
@name Getting cached data
*/
/** Returns cached data by its URL, or nil, if life time of cached data has expired.

@param url URL that corresponds to cached data
@return instance of NSData class, cached data
*/
- (NSData *)cacheForURL:(NSURL *)url;

/** Returns cached data by its URL, or nil, if life time of cached data has
expired or there is no data for current URL.

As you know, offlineMode can make current method return cached data even if its
life time expired. You should use offlineMode (YES) if there is no internet
connection.

@param url URL that corresponds to cached data
@param offlineMode offline mode
@return instance of NSData class, cached data which corresponds to received URL
*/
- (NSData *)cacheForURL:(NSURL *)url
            offlineMode:(BOOL)offlineMode;

@end