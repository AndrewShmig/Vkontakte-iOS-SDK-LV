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
#import "VKAccessToken.h"
#import "VKStorageItem.h"
#import "VKStorage.h"


/** Manages users
*/
@interface VKUser : NSObject

/** User's access token
*/
@property (nonatomic, readwrite) VKAccessToken *accessToken;

/**
@name Class methods
*/
/** Current activated user

If there is no users in VKStorage then nil will be returned.
If no user was activated, then random user will be activated.

Lets assume we have such situation:

    // user A authorized
    // user B authorized
    // user C authorized
    [VKUser currentUser] // random user will be activated - A or B or C

Second example:

    // user A authorized
    [VKUser currentUser] // user A becomes active user
    // user B authorized, but A is still active
    // user C authorized, but A is still active
    // so on.

*/
+ (instancetype)currentUser;

/** Activates user with passed unique user identifier

If there is no such user then NO will be returned, otherwise - YES.

@param userID unique user identifier, user which should be activated
@return YES - if user was activated, NO - otherwise
*/
+ (BOOL)activateUserWithID:(NSUInteger)userID;

/** List of users which were saved in VKStorage

@return list of users (@(NSUInteger) objects - user unique identifiers)
*/
+ (NSArray *)localUsers;

/*
@name Instance methods
*/
/** Logs out current active user.

After calling this method, [VKUser currentUser] will return random user from
VKStorage if there was more than 2 users in VKStorage before current user
logged out, or nil, if there are no users.
*/
- (void)logout;

/**
@name Overridden methods
 */
/** Description of current user
*/
- (NSString *)description;

@end