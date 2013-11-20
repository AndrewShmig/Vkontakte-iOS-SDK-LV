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


#import <Foundation/Foundation.h>


/** Current class works with user access token and stores information about
it:

- list of permissions
- expiration time
- user unique identifier
- token
*/
@interface VKAccessToken : NSObject <NSCopying, NSCoding>

/**
 @name Properties
 */
/** Array of permissions which were granted to current application
*/
@property (nonatomic, copy, readonly) NSArray *permissions;

/** Access token creation time
*/
@property (nonatomic, assign, readonly) NSTimeInterval creationTime;

/** Access token life time.
*/
@property (nonatomic, assign, readonly) NSTimeInterval liveTime;

/** Unique user identifier
*/
@property (nonatomic, assign, readonly) NSUInteger userID;

/** Token (access token)
*/
@property (nonatomic, copy, readonly) NSString *token;

/** Is current access token expired?

Current token is not expired if:

- Token expiration time is greater then zero and greater then current time (timestamp)
- Token expiration time equals zero and list of permissions contains "offline" permission
*/
@property (nonatomic, readonly) BOOL isExpired;

/** Is current access token valid?

Returns YES if current access token is not nil and its not expired.
*/
@property (nonatomic, readonly) BOOL isValid;

/**
 @name Initialization methods
 */
/** Designated initialization method

@param userID unique user identifier
@param token access token
@param liveTime access token life time
@param permissions list of all granted permissions
@return instance of VKAccessToken class
*/
- (instancetype)initWithUserID:(NSUInteger)userID
                   accessToken:(NSString *)token
                      liveTime:(NSTimeInterval)liveTime
                   permissions:(NSArray *)permissions;

/** Initialization method

List of permissions defaults to an empty list (@[]).

@see initWithUserID:accessToken:liveTime:permissions:

@param userID unique user identifier
@param token access token
@param liveTime access token life time
@return instance of VKAccessToken class
*/
- (instancetype)initWithUserID:(NSUInteger)userID
                   accessToken:(NSString *)token
                      liveTime:(NSTimeInterval)liveTime;

/** Initialization method

List of permissions defaults to an empty list (@[]).
liveTime defaults to 0 (zero).

@see initWithUserID:accessToken:liveTime:permissions:

@param userID unique user identifier
@param token access token
@return instance of VKAccessToken class
 */
- (instancetype)initWithUserID:(NSUInteger)userID
                   accessToken:(NSString *)token;

/**
 @name Overridden methods
 */
/** Access token description.

@return String representation.
*/
- (NSString *)description;

/** Checks if two access tokens are equal.

@param token another access token
@return YES - if two access tokens are equal (tokens are equal if and only if their
corresponding tokens, list of permissions and userIDs are equal), otherwise NO
is returned.
*/
- (BOOL)isEqual:(VKAccessToken *)token;

/**
 @name Public methods
 */
/** Method checks if list of permissions contains a permission.

@param permission permissions name (wall, offline, friends etc)
@return YES - if list of permissions contains current permission, otherwise NO
is returned.
*/
- (BOOL)hasPermission:(NSString *)permission;

@end