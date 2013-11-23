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
#import "VKStorageItem.h"
#import "VkontakteSDK_Logger.h"


@implementation VKStorageItem

#pragma mark Visible VKStorageItem methods
#pragma mark - Init methods

- (instancetype)initWithAccessToken:(VKAccessToken *)token
               mainCacheStoragePath:(NSString *)path
{
    VK_LOG(@"%@", @{
            @"token": token,
            @"path": path
    });

    self = [super init];

    if (nil != self && nil != token && nil != path) {
        NSString *cache;
        _accessToken = [token copy];

        cache = [path stringByAppendingFormat:@"%@/", @(_accessToken.userID)];
        _cache = [[VKCache alloc] initWithCacheDirectory:cache];

        return self;
    }

    return nil;
}

- (NSString *)description
{
    NSDictionary *desc = @{
            @"access token": self.accessToken,
            @"cache": _cache
    };

    return [desc description];
}

@end