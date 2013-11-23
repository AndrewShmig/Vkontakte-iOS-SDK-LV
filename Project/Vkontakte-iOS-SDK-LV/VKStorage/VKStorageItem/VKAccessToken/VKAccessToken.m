//
// Created by AndrewShmig on 5/28/13.
//
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
//
#import "VKAccessToken.h"
#import "VkontakteSDK_Logger.h"


@implementation VKAccessToken

#pragma mark - Init methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    VK_LOG();

    self = [super init];

    if (!self)
        return nil;

    self->_userID = (NSUInteger) [aDecoder decodeIntegerForKey:@"userID"];
    self->_token = [aDecoder decodeObjectForKey:@"token"];
    self->_liveTime = [aDecoder decodeDoubleForKey:@"liveTime"];
    self->_permissions = [aDecoder decodeObjectForKey:@"permissions"];
    self->_creationTime = [aDecoder decodeDoubleForKey:@"creationTime"];

    return self;
}

- (instancetype)initWithUserID:(NSUInteger)userID
                   accessToken:(NSString *)token
                      liveTime:(NSTimeInterval)liveTime
                   permissions:(NSArray *)permissions
{
    VK_LOG(@"%@", @{
            @"userID": @(userID),
            @"token": token,
            @"liveTime": @(liveTime),
            @"permission": permissions
    });

    if (self = [super init]) {
        _userID = userID;
        _token = [token copy];
        _liveTime = liveTime;
        _permissions = [permissions copy];
        _creationTime = [[NSDate date] timeIntervalSince1970];
    }

    return self;
}

- (instancetype)initWithUserID:(NSUInteger)userID
                   accessToken:(NSString *)token
                      liveTime:(NSTimeInterval)liveTime
{
    VK_LOG(@"%@", @{
            @"userID": @(userID),
            @"token": token,
            @"liveTime": @(liveTime)
    });

    return [self initWithUserID:userID
                    accessToken:token
                       liveTime:liveTime
                    permissions:@[]];
}

- (instancetype)initWithUserID:(NSUInteger)userID
                   accessToken:(NSString *)token
{
    VK_LOG(@"%@", @{
            @"userID": @(userID),
            @"token": token
    });

    return [self initWithUserID:userID
                    accessToken:token
                       liveTime:0
                    permissions:@[]];
}

- (instancetype)init
{
    VK_LOG();

    return [self initWithUserID:0
                    accessToken:@""
                       liveTime:0
                    permissions:@[]];
}

#pragma mark - Overridden methods

- (NSString *)description
{
    VK_LOG();

    NSDictionary *desc = @{
            @"User ID"         : @(self.userID),
            @"Expiration time" : @(((NSUInteger) (self.creationTime + self.liveTime))),
            @"Creation time"   : @(((NSUInteger) self.creationTime)),
            @"Permissions"     : self.permissions,
            @"Token"           : self.token
    };

    return [desc description];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    VK_LOG();

    [aCoder encodeInteger:_userID forKey:@"userID"];
    [aCoder encodeObject:_token forKey:@"token"];
    [aCoder encodeDouble:_liveTime forKey:@"liveTime"];
    [aCoder encodeObject:_permissions forKey:@"permissions"];
    [aCoder encodeDouble:_creationTime forKey:@"creationTime"];
}

- (BOOL)isEqual:(VKAccessToken *)token
{
    VK_LOG(@"%@", @{
            @"token": token
    });

    NSSet *currentSet = [NSSet setWithArray:self.permissions];
    NSSet *otherSet = [NSSet setWithArray:token.permissions];

    return ([self.token isEqualToString:token.token] &&
            [currentSet isEqualToSet:otherSet] &&
            (self.userID == token.userID));
}

- (VKAccessToken *)copyWithZone:(NSZone *)zone
{
    VK_LOG();

    VKAccessToken *copyToken = [[VKAccessToken alloc] init];

    copyToken->_permissions = [_permissions copy];
    copyToken->_creationTime = _creationTime;
    copyToken->_liveTime = _liveTime;
    copyToken->_userID = _userID;
    copyToken->_token = [_token copy];

    return copyToken;
}

#pragma mark - Visible methods

- (BOOL)hasPermission:(NSString *)permission
{
    VK_LOG(@"%@", @{
            @"permissions": permission
    });

    return [self.permissions containsObject:permission];
}

- (BOOL)isExpired
{
    VK_LOG();

    NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];

    if (self.liveTime == 0 && [self hasPermission:@"offline"])
        return NO;
    else
        return ((self.liveTime + self.creationTime) < currentTimestamp);
}

- (BOOL)isValid
{
    VK_LOG();

    return (nil != self.token && ![self isExpired]);
}

@end