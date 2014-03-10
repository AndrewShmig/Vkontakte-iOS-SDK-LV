//
// Created by AndrewShmig on 11/4/13.
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

#ifndef Project_VkontakteSDK_Logger____FILEEXTENSION___
#define Project_VkontakteSDK_Logger____FILEEXTENSION___

#define VK_SILENT_LOGS 0
#define VK_VERBOSE_LOGS 1
#define VK_MEGA_VERBOSE_LOGS 2

#define VK_LOG_MODE VK_SILENT_LOGS // Current log level

#if VK_LOG_MODE == VK_MEGA_VERBOSE_LOGS
#   define VK_LOG(format, ...)\
    @try {\
        NSLog(@"(%d, %@, %@) " format, __LINE__, [self class], NSStringFromSelector(_cmd), ##__VA_ARGS__);\
    } @catch (NSException *e) {\
        NSLog(@"!!!EXCEPTION OCCURED!!! (%d, %@, %@): %@", __LINE__, [self class], NSStringFromSelector(_cmd), e);\
    }
#elif VK_LOG_MODE == VK_VERBOSE_LOGS
#   define VK_LOG(format, ...) NSLog(@"(%d, %@, %@)", __LINE__, [self class], NSStringFromSelector(_cmd))
#elif VK_LOG_MODE == VK_SILENT_LOGS
#   define VK_LOG(format, ...) /**/
#endif

#endif
