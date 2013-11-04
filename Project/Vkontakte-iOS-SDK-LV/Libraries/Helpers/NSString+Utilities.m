//
// Created by AndrewShmig on 11/3/13.
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
#import "NSString+Utilities.h"
#import <CommonCrypto/CommonCrypto.h>


@implementation NSString (Utilities)

- (NSString *)toBase64
{
    NSData *the_data = [self dataUsingEncoding:NSASCIIStringEncoding];
    const uint8_t *input = (const uint8_t *) [the_data bytes];
    NSInteger length = [the_data length];

    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *) data.mutableBytes;

    NSInteger i;
    for (i = 0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;

            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }

        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] = table[(value >> 18) & 0x3F];
        output[theIndex + 1] = table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6) & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0) & 0x3F] : '=';
    }

    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

- (NSString *)encodeURL
{
    NSString *escaped = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) self, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);

    return escaped;
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, strlen(cStr), digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;
}

- (BOOL)startsWithString:(NSString *)string
{
    if(![self possibleToCompareStrings:string])
        return NO;

//    сравнения
    for(NSUInteger index = 0; index < [string length]; index++) {
        if([self characterAtIndex:index] != [string characterAtIndex:index]) {
            return NO;
        }
    }

    return YES;
}

- (BOOL)endsWithString:(NSString *)string
{
    if(![self possibleToCompareStrings:string])
        return NO;

//    сравнения
    for (NSUInteger selfIndex = [self length] - 1, stringIndex = [string length] - 1;
         selfIndex > 0 && stringIndex > 0;
         selfIndex--, stringIndex--) {

        if([self characterAtIndex:selfIndex] != [string characterAtIndex:stringIndex]) {
            return NO;
        }
    }

    return YES;
}

- (BOOL)isEmpty
{
    NSString *filtered = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    return (0 == [filtered length]);
}

#pragma mark - Methods for internal usage

- (BOOL)possibleToCompareStrings:(NSString *)string
{
    BOOL ok = YES;

    ok = (ok && (nil != string));
    ok = (ok && ([self length] >= [string length]));

    return ok;
}


@end