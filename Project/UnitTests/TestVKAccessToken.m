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

#import "TestVKAccessToken.h"
#import "VKAccessToken.h"

@implementation TestVKAccessToken

- (void)testPermissions1
{
    VKAccessToken *token = [[VKAccessToken alloc] init];

    STAssertFalse([token hasPermission:@"offline"], @"Has no offline permission.");
}

- (void)testPermissions2
{
    VKAccessToken *token = [[VKAccessToken alloc]
                                           initWithUserID:1
                                              accessToken:@"token"
                                           liveTime:1
                                              permissions:@[@"offline",
                                                            @"wall",
                                                            @"friends",
                                                            @"feed"]];

    STAssertTrue([token hasPermission:@"friends"], @"Has friends permission.");
}

- (void)testIsValid1
{
    VKAccessToken *token = [[VKAccessToken alloc] init];

    STAssertFalse([token isValid], @"Invalid token.");
}

- (void)testIsValid2
{
    VKAccessToken *token = [[VKAccessToken alloc]
                                           initWithUserID:1
                                              accessToken:nil];

    STAssertFalse([token isValid], @"Invalid token.");
}

- (void)testIsValid3
{
    VKAccessToken *token = [[VKAccessToken alloc]
                                           initWithUserID:1
                                              accessToken:@""];

    STAssertFalse([token isValid], @"Valid token.");
}

- (void)testIsExpired1
{
    VKAccessToken *token = [[VKAccessToken alloc]
                                           initWithUserID:1
                                              accessToken:@""
                                           liveTime:0];

    STAssertTrue([token isExpired], @"Expired token.");
}

- (void)testIsExpired2
{
    VKAccessToken *token = [[VKAccessToken alloc]
                                           initWithUserID:1
                                              accessToken:@""
                                           liveTime:0
                                              permissions:@[@"offline"]];

    STAssertFalse([token isExpired], @"Not expired token.");
}

- (void)testIsExpired3
{
    NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];
    VKAccessToken *token = [[VKAccessToken alloc]
                                           initWithUserID:1
                                              accessToken:@""
                                           liveTime:currentTimestamp + 80000
                                              permissions:@[@"friends",
                                                            @"wall"]];

    STAssertTrue([token isValid], @"Not expired token.");
}

- (void)testCopy1
{
    VKAccessToken *token1 = [[VKAccessToken alloc]
                                            initWithUserID:1
                                               accessToken:@"1"
                                            liveTime:1
                                               permissions:@[@"wall",
                                                             @"friends"]];
    VKAccessToken *token1Copy = [token1 copy];

    STAssertTrue([token1 isEqual:token1Copy], @"Tokens should be equal.");
}

- (void)testCopy2
{
    VKAccessToken *token1 = [[VKAccessToken alloc]
                                            initWithUserID:1
                                               accessToken:@"1"];
    VKAccessToken *token1Copy = [token1 copy];

    STAssertTrue([token1 isEqual:token1Copy], @"Tokens should be equal.");
}

- (void)testIsEqual1
{
    VKAccessToken *token1 = [[VKAccessToken alloc]
                                            initWithUserID:1
                                               accessToken:@"2"];
    VKAccessToken *token2 = [[VKAccessToken alloc]
                                            initWithUserID:1
                                               accessToken:@"2"];

    STAssertTrue([token1 isEqual:token2], @"Tokens should be equal.");
}

- (void)testIsEqual2
{
    VKAccessToken *token1 = [[VKAccessToken alloc]
                                            initWithUserID:1
                                               accessToken:@"2"];
    VKAccessToken *token2 = [[VKAccessToken alloc]
                                            initWithUserID:1
                                               accessToken:@"3"];

    STAssertFalse([token1 isEqual:token2], @"Tokens are not equal.");
}

- (void)testIsEqual3
{
    VKAccessToken *token1 = [[VKAccessToken alloc]
                                            initWithUserID:2
                                               accessToken:@"4"];
    VKAccessToken *token2 = [[VKAccessToken alloc]
                                            initWithUserID:3
                                               accessToken:@"4"];

    STAssertFalse([token1 isEqual:token2], @"Tokens are not equal.");
}

- (void)testIsEqual4
{
    VKAccessToken *token1 = [[VKAccessToken alloc]
                                            initWithUserID:1
                                               accessToken:@"1"
                                            liveTime:0
                                               permissions:@[@"offline",
                                                             @"friends"]];
    VKAccessToken *token2 = [[VKAccessToken alloc]
                                            initWithUserID:1
                                               accessToken:@"1"
                                            liveTime:0
                                               permissions:@[@"offline",
                                                             @"friends"]];

    STAssertTrue([token1 isEqual:token2], @"Token are equal.");
}

- (void)testIsEqual5
{
    VKAccessToken *token1 = [[VKAccessToken alloc]
                                            initWithUserID:1
                                               accessToken:@"1"
                                            liveTime:0
                                               permissions:@[@"friends",
                                                             @"offline"]];
    VKAccessToken *token2 = [[VKAccessToken alloc]
                                            initWithUserID:1
                                               accessToken:@"1"
                                            liveTime:0
                                               permissions:@[@"offline",
                                                             @"friends"]];

    STAssertTrue([token1 isEqual:token2], @"Tokens are equal.");
}

- (void)testIsEqual6
{
    VKAccessToken *token1 = [[VKAccessToken alloc]
                                            initWithUserID:2
                                               accessToken:@"1"
                                            liveTime:0
                                               permissions:@[@"friends",
                                                             @"offline"]];
    VKAccessToken *token2 = [[VKAccessToken alloc]
                                            initWithUserID:1
                                               accessToken:@"1"
                                            liveTime:0
                                               permissions:@[@"offline",
                                                             @"friends"]];

    STAssertFalse([token1 isEqual:token2], @"Tokens are not equal.");
}

@end
