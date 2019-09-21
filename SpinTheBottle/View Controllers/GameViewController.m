//
//  GameViewController.m
//  SpinTheBottle
//
//  Created by Matt Davenport on 13/05/2012.
//  Copyright (c) 2012 Taptastic Apps All rights reserved.
//

//Sound : http://audiojungle.net/item/rolling-bottles/1043813?sso?WT.ac=search_item&WT.seg_1=search_item&WT.z_author=Reachground

#import <AudioToolbox/AudioServices.h>
#import "GameViewController.h"
#import "PlayersViewController.h"
#import "AboutUsViewController.h"
#import "NameButton.h"
#import "WinnerView.h"
#import "PlayerManager.h"
#import "LargeButton.h"

#define kAboutUsSize		(iPad ? 100 : 50)
#define kRadius				(iPad ? 310 : 120)
#define kNameLabelWidth		(iPad ? 140 : 80)
#define kNameLabelHeight	(iPad ? 34 : 16)

@interface GameViewController ()

@property (assign) Player *selectedPlayer;

@property (strong) UIImageView *background;
@property (strong) UIImageView *overlay;
@property (strong) UIView *nameView;
@property (strong) UIButton *infoButton;
@property (strong) UIButton *addPlayerButton;
@property (strong) LargeButton *spinButton;
@property (strong) UIImageView *spinner;
@property (strong) WinnerView *winnerView;

@property (strong) UIPopoverController *contentPopoverController;
@property (strong) NSMutableArray *playerLabels;

@property (assign) int lastPlayer;
@property (assign) BOOL spinning;

@end

@implementation GameViewController

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id) init
{
    self = [super init];
    if (self)
	{
		[self registerNotifications];
		
		self.view.backgroundColor = [UIColor whiteColor];
		self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		
		self.playerLabels = [NSMutableArray array];
		self.selectedPlayer = nil;
        self.spinning = NO;
        self.lastPlayer = -1;
		
		[[PlayerManager sharedInstance] loadPlayers];
		
		[self reload];
	}
	
	return self;
}

- (void) viewDidLoad
{
	[super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	self.spinning = NO;
	[self layout];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self layout];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if(iPad)
		return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
	
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Initialisation

- (void) loadView
{
	[super loadView];
    
    for (UIView *view in [self.view subviews])
        [view removeFromSuperview];
	
	self.background = [[UIImageView alloc] initWithImage:[UIImage universalImageNamed:@"Background.png"]];
	[self.view addSubview:self.background];
	
	self.nameView = [[UIView alloc] init];
	[self.view addSubview:self.nameView];
	
	self.addPlayerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.addPlayerButton setBackgroundImage:[UIImage universalImageNamed:@"AddPlayerBtn.png"] forState:UIControlStateNormal];
	[self.addPlayerButton setBackgroundImage:[UIImage universalImageNamed:@"AddPlayerBtnPushed.png"] forState:UIControlStateHighlighted];
	[self.addPlayerButton addTarget:self action:@selector(onPlayers) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.addPlayerButton];
	
	self.infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.infoButton setBackgroundImage:[UIImage universalImageNamed:@"InfoBtn.png"] forState:UIControlStateNormal];
	[self.infoButton setBackgroundImage:[UIImage universalImageNamed:@"InfoBtnPushed.png"] forState:UIControlStateHighlighted];
	[self.infoButton addTarget:self action:@selector(onOurApps) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.infoButton];
	
	self.spinButton = [[LargeButton alloc] init];
	[self.spinButton setTitle:NSLocalizedString(@"Spin", nil) forState:UIControlStateNormal];
	[self.spinButton addTarget:self action:@selector(onSpin) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.spinButton];
	
	UITapGestureRecognizer *recogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSpin)];
	self.spinner = [[UIImageView alloc] initWithImage:[UIImage universalImageNamed:@"Spinner.png"]];
	self.spinner.layer.anchorPoint = CGPointMake(0.5, 0.5);
	self.spinner.userInteractionEnabled = YES;
	[self.spinner addGestureRecognizer:recogniser];
	[self.view addSubview:self.spinner];
	
	self.overlay = [[UIImageView alloc] initWithImage:[UIImage universalImageNamed:@"Overlay.png"]];
	self.overlay.userInteractionEnabled = NO;
	[self.view addSubview:self.overlay];
	
	[self layout];
}

- (void) drawPlayerLabels
{
	for (NameButton *playerBtn in self.playerLabels)
		[playerBtn removeFromSuperview];
	
	[self.playerLabels removeAllObjects];
	
	NSMutableArray *players = [[PlayerManager sharedInstance] players];
	for (int p=0; p<[players count]; p++)
	{
		Player *player = [players objectAtIndex:p];
		
		NameButton *nameButton = [[NameButton alloc] initWithTitle:player.name];
		nameButton.titleLabel.textColor = [UIColor clearColor];
		[nameButton addTarget:self action:@selector(nameTapped:) forControlEvents:UIControlEventTouchUpInside];
		[nameButton setTag:p];
		[self.view addSubview:nameButton];
		[self.playerLabels addObject:nameButton];
	}
	
	[self layoutPlayers];
	
	[self.view bringSubviewToFront:self.spinner];
}

- (void) layoutPlayers
{
	int count = 0;
	for (NameButton *btn in self.playerLabels)
	{
		int radius = kRadius;
		float angle = ((360 / [self.playerLabels count])*count);
		CGPoint center =  self.spinner.center;
		
		float x = center.x + radius * cos(degreesToRadians(-90+angle));
		float y = center.y + radius * sin(degreesToRadians(-90+angle));
		
		float xOffset = 0;
		float yOffset = 0;
		
		xOffset = angle == 90 ? (iPad? 0 : -15) : xOffset;
		xOffset = angle == 270 ? (iPad ? 0 : 15) : xOffset;
		
		yOffset = angle == 0 ? (iPad ? 20 : -20) : yOffset;
		yOffset = angle == 180 ? (iPad ? -20 : 20) : yOffset;
		
		[btn setFrame:CGRectMake((x-(btn.currentBackgroundImage.size.width/2))+xOffset,
								 (y-(btn.currentBackgroundImage.size.height/2))+yOffset,
								 btn.currentBackgroundImage.size.width,
								 btn.currentBackgroundImage.size.height)];
		
		
		btn.transform = CGAffineTransformMakeRotation(degreesToRadians(angle-angle));
		count++;
	}
}

- (void) registerNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(reload) 
												 name:kReloadPlayers 
											   object:nil];
}

#pragma mark - Layout

- (void) layout
{
	CGSize base = self.view.frame.size;
	self.background.frame = CGRectMake(0, 0, base.width, base.height);
	self.overlay.frame = CGRectMake(0, 0, base.width, base.height);
	self.nameView.frame = CGRectMake(0, 0, base.width, base.height);
	self.addPlayerButton.frame = CGRectMake(base.width - 10 - self.addPlayerButton.currentBackgroundImage.size.width, 10,
											self.addPlayerButton.currentBackgroundImage.size.width,
											self.addPlayerButton.currentBackgroundImage.size.height);
	self.infoButton.frame = CGRectMake(15, 15, self.infoButton.currentBackgroundImage.size.width, self.infoButton.currentBackgroundImage.size.height);
	self.spinner.frame = CGRectMake((base.width - self.spinner.image.size.width) / 2, 
									((self.view.frame.size.height-(kRadius+(kNameLabelWidth*2))) / 2),
									self.spinner.image.size.width, self.spinner.image.size.height);
	self.spinButton.frame = CGRectMake(iPad ? 15 : (self.view.frame.size.width-self.spinButton.bounds.size.width)/2,
									   self.view.frame.size.height-self.spinButton.bounds.size.height-15,
									   self.spinButton.bounds.size.width,
									   self.spinButton.bounds.size.height);
	
	[self reload];
}

#pragma mark - Actions

- (void) onPlayers
{
	[self showPlayersAnimated:YES];
}

- (void) onOurApps
{
	[self showOurAppsAnimated:YES];
}

- (void) onSpin
{
	if([[[PlayerManager sharedInstance] players] count] < 2)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add players", @"Add players title")
														message:NSLocalizedString(@"Please add at least 2 players to start", @"Add players content")
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"OK", @"OK button")
											  otherButtonTitles:nil];
		[alert show];
		
		[self onPlayers];
		
		return;
	}
	
	NSMutableArray *players = [[PlayerManager sharedInstance] players];
    
    self.spinButton.enabled = NO;
	self.addPlayerButton.enabled = NO;
	
	int numberOfPlayers = [players count];
	if (numberOfPlayers < 2 || self.spinning)
		return;
	
	self.spinning = YES;
	int chosenPlayer = 1 + arc4random() % numberOfPlayers;
	if (self.selectedPlayer != nil)
		chosenPlayer = [players indexOfObject:self.selectedPlayer];
	
	self.selectedPlayer = nil;
	float playerDegrees = ((M_PI/numberOfPlayers)*2)*chosenPlayer;
	float duration = 3.0;
    
    self.lastPlayer = chosenPlayer == numberOfPlayers ? 0 : chosenPlayer;
	
	CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: (M_PI * 2.0 * 3 * duration)+playerDegrees];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
	rotationAnimation.fillMode = kCAFillModeForwards;
	rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.repeatCount = 1.0; 
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotationAnimation.delegate = self;
    [self.spinner.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	self.spinning = NO;
	NSMutableArray *players = [[PlayerManager sharedInstance] players];
    Player *player = [players objectAtIndex:self.lastPlayer];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    self.winnerView = [[WinnerView alloc] initWithName:player.name];
    CGSize bgSize = self.winnerView.background.image.size;
    self.winnerView.frame = CGRectMake(center.x-(bgSize.width/2), -bgSize.height, bgSize.width, bgSize.height);
    //self.winnerView.frame = CGRectMake(center.x, center.y, 0, 0);
	self.winnerView.alpha = 0;
    [self.view addSubview:self.winnerView];
    
    [UIView animateWithDuration:0.8
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.winnerView.frame = CGRectMake(center.x-(bgSize.width/2), center.y-(bgSize.height/2), bgSize.width, bgSize.height);
                         self.winnerView.alpha = 1;
                     } completion:^(BOOL finished) {
                         self.spinButton.enabled = YES;
						 self.addPlayerButton.enabled = YES;
                         [UIView animateWithDuration:0.4
                                               delay:1.5
                                             options:UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              self.winnerView.frame = CGRectMake(center.x-(bgSize.width/2), -bgSize.height, bgSize.width, bgSize.height);
                                              self.winnerView.alpha = 0;
                                          } completion:^(BOOL finished) {
                                              [self.winnerView removeFromSuperview];
                                          }];
                     }];
}

- (void) nameTapped:(UIButton *)playerBtn
{
	NSMutableArray *players = [[PlayerManager sharedInstance] players];
	self.selectedPlayer = [players objectAtIndex:playerBtn.tag];
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
			
#pragma mark - View loading

- (void) showPlayersAnimated:(BOOL)animated
{
	PlayersViewController *viewController = [[PlayersViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:animated];

//    if(iPad)
//    {
//        viewController.modalPresentationStyle = UIModalPresentationFormSheet;
//        viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        
//        [self presentModalViewController:viewController animated:NO];
//        
//        CGRect r = CGRectMake((self.view.bounds.size.width - 692) / 2, (self.view.bounds.size.height - 606) / 2, 692, 606);
//        r = [self.view convertRect:r toView:viewController.view.superview.superview];
//        viewController.view.superview.frame = r;
//    }
//    else 
//    {
//        [self.navigationController pushViewController:viewController animated:animated];
//    }
}

- (void) showOurAppsAnimated:(BOOL)animated
{
	AboutUsViewController *viewController = [[AboutUsViewController alloc] initWithView:self.view];
	[self.navigationController pushViewController:viewController animated:NO];
}

#pragma mark - Reloading

- (void) reload
{
	[self drawPlayerLabels];
	self.selectedPlayer = nil;
}

@end
