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


@implementation VKAccessToken

#pragma mark - Init methods

- (instancetype)initWithUserID:(NSUInteger)userID
                   accessToken:(NSString *)token
                expirationTime:(NSTimeInterval)expirationTime
                   permissions:(NSArray *)permissions
{
    if (self = [super init]) {
        _userID = userID;
        _token = [token copy];
        _expirationTime = expirationTime;
        _permissions = [permissions copy];
        _creationTime = [[NSDate date] timeIntervalSince1970];
    }

    return self;
}

- (instancetype)initWithUserID:(NSUInteger)userID
                   accessToken:(NSString *)token
                expirationTime:(NSTimeInterval)expirationTime
{
    return [self initWithUserID:userID
                    accessToken:token
                 expirationTime:expirationTime
                    permissions:@[]];
}

- (instancetype)initWithUserID:(NSUInteger)userID accessToken:(NSString *)token
{
    return [self initWithUserID:userID
                    accessToken:token
                 expirationTime:0
                    permissions:@[]];
}

- (instancetype)init
{
    return [self initWithUserID:0
                    accessToken:@""
                 expirationTime:0
                    permissions:@[]];
}

#pragma mark - Overriden methods

- (NSString *)description
{
    NSDictionary *desc = @{
            @"User ID"         : @(self.userID),
            @"Expiration time" : @(((NSUInteger) (self.creationTime + self.expirationTime))),
            @"Creation time"   : @(((NSUInteger) self.creationTime)),
            @"Permissions"     : self.permissions,
            @"Token"           : self.token
    };

    return [desc description];
}

- (NSDictionary *)tokenAsDictionary
{
    NSDictionary *tokenDictionary = @{
            @"userID"         : @(self.userID),
            @"expirationTime" : @(((NSUInteger) (self.creationTime + self.expirationTime))),
            @"creationTime"   : @(((NSUInteger) self.creationTime)),
            @"permissions"    : self.permissions,
            @"token"          : self.token
    };

    return tokenDictionary;
}

- (BOOL)isEqual:(VKAccessToken *)token
{
    NSSet *currentSet = [NSSet setWithArray:self.permissions];
    NSSet *otherSet = [NSSet setWithArray:token.permissions];

    return ([self.token isEqualToString:token.token] &&
            [currentSet isEqualToSet:otherSet] &&
            (self.userID == token.userID));
}

- (VKAccessToken *)copyWithZone:(NSZone *)zone
{
    VKAccessToken *copyToken = [[VKAccessToken alloc] initWithUserID:self.userID
                                                         accessToken:self.token
                                                      expirationTime:self.expirationTime
                                                         permissions:self.permissions];

    return copyToken;
}

#pragma mark - Visible methods

- (BOOL)hasPermission:(NSString *)permission
{
    return [self.permissions containsObject:permission];
}

- (BOOL)isExpired
{
    NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];

    if (self.expirationTime == 0 && [self hasPermission:@"offline"])
        return NO;
    else
        return ((self.expirationTime + self.creationTime) < currentTimestamp);
}

- (BOOL)isValid
{
    return (nil != self.token && ![self isExpired]);
}

@end