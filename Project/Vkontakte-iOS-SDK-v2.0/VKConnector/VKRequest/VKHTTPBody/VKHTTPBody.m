//
// Created by AndrewShmig on 7/10/13.
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
#import "VKHTTPBody.h"


@implementation VKHTTPBody
{
    NSMutableData *_body;
    NSString *_boundary, *_boundaryHeader, *_boundaryFooter;

    BOOL _isEmpty;
}

#pragma mark - Init methods

- (instancetype)init
{
    if (self = [super init]) {
        _body = [[NSMutableData alloc] init];
        _isEmpty = YES;

        _boundary = [[NSProcessInfo processInfo] globallyUniqueString];
        _boundaryHeader = [NSString stringWithFormat:@"\r\n--%@\r\n",
                                                     _boundary];
        _boundaryFooter = [NSString stringWithFormat:@"\r\n--%@--\r\n",
                                                     _boundary];
    }

    return self;
}

#pragma mark - Manipulation methods

- (void)appendAudioFile:(NSData *)file
                   name:(NSString *)name
                  field:(NSString *)field
{
    [self appendFile:file
                name:name
               field:field];
}

- (void)appendDocumentFile:(NSData *)file
                      name:(NSString *)name
                     field:(NSString *)field
{
    [self appendFile:file
                name:name
               field:field];
}

- (void)appendImageFile:(NSData *)file
                   name:(NSString *)name
                  field:(NSString *)field
{
    [self appendFile:file
                name:name
               field:field];
}

- (void)appendVideoFile:(NSData *)file
                   name:(NSString *)name
                  field:(NSString *)field
{
    [self appendFile:file
                name:name
               field:field];
}

#pragma mark - Getters & Setters

- (NSData *)data
{
//    данные еще не добавлены
    if (_isEmpty)
        return _body;

//    какие-то файлы добавлены
    NSMutableData *tmp = [_body copy];
    [tmp appendData:[_boundaryFooter dataUsingEncoding:NSUTF8StringEncoding]];

    return [NSData dataWithData:tmp];
}

#pragma mark - Private methods

- (void)appendFile:(NSData *)file
              name:(NSString *)name
             field:(NSString *)field
{
//    header part
    if (_isEmpty)
        [_body appendData:[_boundary dataUsingEncoding:NSUTF8StringEncoding]];
    else
        [_body appendData:[_boundaryHeader dataUsingEncoding:NSUTF8StringEncoding]];

    NSString *contentDisposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
                                                              name,
                                                              field];
    [_body appendData:[contentDisposition dataUsingEncoding:NSUTF8StringEncoding]];

//    Content-Type
    NSString *contentType = [self determineContentTypeFromExtension:[[name componentsSeparatedByString:@"."]
                                                                           lastObject]];
    if (nil != contentType) {
        NSString *fullContentType = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",
                                                               contentType];
        [_body appendData:[fullContentType dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        [_body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }

//    file part
    [_body appendData:file];
}

- (NSString *)determineContentTypeFromExtension:(NSString *)extension
{
    NSDictionary *contentTypes = @{

//            audio
            @"mid"  : @"audio/midi",
            @"midi" : @"audio/midi",
            @"mpg"  : @"audio/mpeg",
            @"mp3"  : @"audio/mpeg3",
            @"wav"  : @"audio/wav",

//            video
            @"avi"  : @"video/avi",
            @"mpeg" : @"video/mpeg",
            @"mpg"  : @"video/mpeg",
            @"mov"  : @"video/quicktime",

//            image
            @"bmp"  : @"image/bmp",
            @"gif"  : @"image/gif",
            @"jpeg" : @"image/jpeg",
            @"jpg"  : @"image/jpeg",
            @"png"  : @"image/png",
            @"tif"  : @"image/tiff",
            @"tiff" : @"image/tiff",
            @"ico"  : @"image/x-icon",

//            documents
            @"pdf"  : @"application/pdf",
            @"xls"  : @"application/excel",
            @"ppt"  : @"application/mspowerpoint",
            @"pps"  : @"application/mspowerpoint",
            @"doc"  : @"application/msword",
            @"docx" : @"application/msword",
            @"psd"  : @"application/octet-stream",
            @"rtf"  : @"application/rtf",
            @"gz"   : @"application/x-compressed",
            @"tgz"  : @"application/x-compressed",
            @"zip"  : @"application/x-compressed"
    };

    return contentTypes[[extension lowercaseString]];
}

@end