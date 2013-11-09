//
//  VkontakteSDK_Logger.h
//  Vkontakte-iOS-SDK-LV-Workspace
//
//  Created by AndrewShmig on 11/9/13.
//  Copyright (c) 2013 AndrewShmig. All rights reserved.
//

#ifndef Project_VkontakteSDK_Logger____FILEEXTENSION___
#define Project_VkontakteSDK_Logger____FILEEXTENSION___

#define VKONTAKTE_DEBUG_MODE 1

#if VKONTAKTE_DEBUG_MODE
#define LOG() NSLog(@"%s", __FUNCTION__)
#else
#define LOG() NSLog(@"")
#endif

#endif
