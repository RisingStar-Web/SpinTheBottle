//
//  AMSharer.m
//  SpinTheBottle
//
//  Created by Matt Davenport on 18/03/2013.
//  Copyright (c) 2013 Taptastic Apps. All rights reserved.
//

#import "AMSharer.h"
#import <Social/Social.h>
#import <Twitter/Twitter.h>

@implementation AMSharer

+ (void) shareOnTwitterWithShareString:(NSString *)shareString presentedFromViewController:(UIViewController *)viewController
{
	if (NSClassFromString(@"SLComposeViewController"))
	{
		SLComposeViewController *composerController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];

		if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
		{
			SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
				
				[composerController dismissViewControllerAnimated:YES
													   completion:nil];
				
			};
			
			[composerController setInitialText:shareString];
			[composerController setCompletionHandler:completionHandler];
			[viewController.navigationController presentModalViewController:composerController animated:YES];
		}
	}
	else if(NSClassFromString(@"TWTweetComposeViewController"))
	{
		if ([TWTweetComposeViewController canSendTweet])
		{
			TWTweetComposeViewController *composerController = [[TWTweetComposeViewController alloc] init];
			[composerController setInitialText:shareString];
			[viewController.navigationController presentModalViewController:composerController animated:YES];
			[composerController release];
		}
	}
}

+ (void) shareOnFacebookWithShareString:(NSString *)shareString presentedFromViewController:(UIViewController *)viewController
{
	if (NSClassFromString(@"SLComposeViewController"))
	{
		SLComposeViewController *composerController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
		
		if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
		{
			SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
				
				[composerController dismissViewControllerAnimated:YES
													   completion:nil];
				
			};
			
			[composerController setInitialText:shareString];
			[composerController setCompletionHandler:completionHandler];
			[viewController.navigationController presentModalViewController:composerController animated:YES];
		}
	}
}

@end
