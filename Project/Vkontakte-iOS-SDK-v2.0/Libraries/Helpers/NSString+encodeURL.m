//
//  NSString+encodeURL.m
//  TwitterCommunicator2
//
//  Created by digipeople on 06.12.12.
//  Copyright (c) 2012 digipeople. All rights reserved.
//

#import "NSString+encodeURL.h"

@implementation NSString (encodeURL)

-(NSString *)encodeURL
{    
    NSString *escaped = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    return escaped;
}

@end
