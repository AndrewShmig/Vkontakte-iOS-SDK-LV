//
//  ASAAppDelegate.h
//  Project
//
//  Created by AndrewShmig on 6/28/13.
//  Copyright (c) 2013 AndrewShmig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKConnector.h"
#import "VKRequest.h"


@class ASAViewController;


@interface ASAAppDelegate : UIResponder <UIApplicationDelegate, VKConnectorDelegate, VKRequestDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ASAViewController *viewController;

@end