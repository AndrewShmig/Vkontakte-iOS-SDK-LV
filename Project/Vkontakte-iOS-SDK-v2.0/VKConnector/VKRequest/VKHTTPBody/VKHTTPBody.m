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
    if(self = [super init]){
        _body = [[NSMutableData alloc] init];
        _isEmpty = YES;

        _boundary = [[NSProcessInfo processInfo] globallyUniqueString];
        _boundaryHeader = [NSString stringWithFormat:@"\r\n--%@\r\n", _boundary];
        _boundaryFooter = [NSString stringWithFormat:@"\r\n--%@--\r\n", _boundary];
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
    if(_isEmpty)
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
    if(_isEmpty)
        [_body appendData:[_boundary dataUsingEncoding:NSUTF8StringEncoding]];
    else
        [_body appendData:[_boundaryHeader dataUsingEncoding:NSUTF8StringEncoding]];

    NSString *contentDisposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n\r\n",name, field];
    [_body appendData:[contentDisposition dataUsingEncoding:NSUTF8StringEncoding]];

//    TODO: здесь должно быть определение Content-Type по расширению файла
//    добавить "Content-Type: ..... "

//    file part
    [_body appendData:file];
}

@end