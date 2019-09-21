//
//  AppDelegate.m
//  SpinTheBottle
//
//  Created by Matt Davenport on 11/05/2012.
//  Copyright (c) 2012 Taptastic Apps All rights reserved.
//

#import "AppDelegate.h"

#import "GameViewController.h"

#import "PlayerManager.h"

#import "AboutUsView.h"

#define kAboutUsSize		(iPad ? 100 : 50)

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	AboutUsView *aboutUs = [[AboutUsView alloc] init];
	aboutUs.frame = CGRectMake(0, 0, self.window.frame.size.width, kAboutUsSize);
	[self.window addSubview:aboutUs];
	
	GameViewController *viewController = [[GameViewController alloc] init];
	self.navController = [[UINavigationController alloc] initWithRootViewController:viewController];
	
	[self.navController setNavigationBarHidden:YES];
	self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
