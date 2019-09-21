//
//  PlayersViewController.m
//  SpinTheBottle
//
//  Created by Matt Davenport on 11/05/2012.
//  Copyright (c) 2012 Taptastic Apps All rights reserved.
//

#import "PlayersViewController.h"
#import "PlayerManager.h"
#import "AddPlayerCell.h"
#import "LargeButton.h"
#import "BackButton.h"

#define kTableViewY					(iPad ? 90 : 67)
#define kTableViewX					(iPad ? 5 : 0)
#define kTableViewBottomPadding		(iPad ? 3 : 0)
#define kAddButtonSize				(iPad ? 50 : 55)
#define kAddButtonX                 (iPad ? 15 : 5)
#define kAddButtonY                 (iPad ? 15 : 7)
#define kCloseButtonX               (iPad ? 692-230-15 : 5)
#define kCloseButtonY               (iPad ? 606-80-15 : 7)

@interface PlayersViewController ()

@property (strong) UIImageView *background;
@property (strong) UILabel *titleLabel;
@property (strong) UITableView *playersTableView;
@property (strong) UIButton *playerAddButton;
@property (strong) UIButton *closeButton;

@end

@implementation PlayersViewController

- (id) init
{
	self = [super init];
	if (self)
	{
		self.title = NSLocalizedString(@"Players", @"Players title");
		self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
		self.view.backgroundColor = [UIColor clearColor];
		
		[[PlayerManager sharedInstance] loadPlayers];
		
		[self draw];
		[self layout];
	}
	
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if(iPad)
		return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
	
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewDidLoad
{
	[super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!iPad)
        return;
    
    for (UIGestureRecognizer *gr in [self.view.window gestureRecognizers])
        [self.view.window removeGestureRecognizer:gr];
    
    //Allows the user to dismiss the modal VC by tapping the shaded area
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [recognizer setNumberOfTapsRequired:1];
    recognizer.cancelsTouchesInView = NO;
    [self.view.window addGestureRecognizer:recognizer];
}

#pragma mark - Initialisation

- (void) draw
{
	self.background = [[UIImageView alloc] initWithImage:[UIImage universalImageNamed:@"PlayersBackground.png"]];
	[self.view addSubview:self.background];
	
	self.playersTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[self.playersTableView setDelegate:self];
	[self.playersTableView setDataSource:self];
	[self.playersTableView setBackgroundColor:[UIColor clearColor]];
	[self.playersTableView setSeparatorColor:[UIColor clearColor]];
	self.playersTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:self.playersTableView];
	
	self.playerAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.playerAddButton setImage:[UIImage universalImageNamed:@"PlayerAddBtn.png"] forState:UIControlStateNormal];
	[self.playerAddButton setImage:[UIImage universalImageNamed:@"PlayerAddBtnPushed.png"] forState:UIControlStateHighlighted];
	[self.playerAddButton addTarget:self action:@selector(inputPlayer) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.playerAddButton];
    
	if (iPad)
	{
		self.closeButton = [[LargeButton alloc] init];
		[self.closeButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
		[self.closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:self.closeButton];
	}
	else
	{
		self.closeButton = [[BackButton alloc] init];
		[self.closeButton setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
		[self.closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:self.closeButton];
	}
	
	self.titleLabel = [[UILabel alloc] init];
	self.titleLabel.text = NSLocalizedString(@"Players", nil);
	self.titleLabel.textAlignment = UITextAlignmentCenter;
	self.titleLabel.adjustsFontSizeToFitWidth = YES;
	
	if (iPad)
	{
		self.titleLabel.font = [UIFont fontWithName:@"Debussy" size:52];
		self.titleLabel.textColor = rgb(165, 21, 0);
		self.titleLabel.backgroundColor = [UIColor clearColor];
	}
	else
	{
		self.titleLabel.font = [UIFont fontWithName:@"Days" size:20];
		self.titleLabel.textColor = [UIColor whiteColor];
		self.titleLabel.backgroundColor = [UIColor clearColor];
		self.titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.8];
		self.titleLabel.shadowOffset = CGSizeMake(0, 1);
	}
	[self.view addSubview:self.titleLabel];
}

#pragma mark - Layout

- (void) layout
{
	CGSize base = self.view.frame.size;
	self.background.frame = CGRectMake(0, 0, base.width, base.height);
	self.playersTableView.frame = CGRectMake(kTableViewX, kTableViewY*2, base.width-(kTableViewX*2), base.height-kTableViewY-kTableViewBottomPadding);
	self.playerAddButton.frame = CGRectMake(base.width-kAddButtonX-kAddButtonSize, kAddButtonY*4, kAddButtonSize, kAddButtonSize);
	if (iPad)
	{
		self.closeButton.frame = CGRectMake(kCloseButtonX, kCloseButtonY, self.closeButton.bounds.size.width, self.closeButton.bounds.size.height);
		self.titleLabel.frame = CGRectMake(25, 20, 170, 60);
	}
	else
	{
		self.closeButton.frame = CGRectMake(kCloseButtonX, kCloseButtonY*6, self.closeButton.currentBackgroundImage.size.width, self.closeButton.currentBackgroundImage.size.height);
		self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.closeButton.frame) + 10, 35, 170, 45);
	}
}

#pragma mark - Actions

- (void) inputPlayer
{
	if([[[PlayerManager sharedInstance] players] count] >= 8)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Too many players", @"Too many players title")
														message:NSLocalizedString(@"You have reached the maximum number of players", @"Too many players message")
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"Cancel", @"UIAlertView Cancel")
											  otherButtonTitles:nil];
		[alert show];
	}
	else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please enter a name", @"Enter a name title")
														message:nil
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Cancel", @"UIAlertView Cancel")
											  otherButtonTitles:NSLocalizedString(@"OK", @"UIAlertView OK"), nil];
		alert.alertViewStyle = UIAlertViewStylePlainTextInput;
		[alert show];
		
		UITextField *alertField = [alert textFieldAtIndex:0];
		alertField.delegate = self;
	}
}

#pragma mark - UITableView DataSource

- (int) numberOfSectionsInTableView:(UITableView *)tableView 
{ 
	return 1; 
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[PlayerManager sharedInstance] players].count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	AddPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[AddPlayerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	Player *player = [[[PlayerManager sharedInstance] players] objectAtIndex:indexPath.row];
	cell.textLabel.text = player.name;
	
	return cell;
}

#pragma mark - UITableView Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Remove player", nil)
														message:NSLocalizedString(@"Are you sure you want to remove this player?", nil)
													   delegate:self
											  cancelButtonTitle:@"No"
											  otherButtonTitles:@"Yes", nil];
	alertView.tag = 100 + indexPath.row; //ew!!
	[alertView show];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self deleteUserAtIndex:indexPath.row];
}

#pragma mark - Delete user

- (void) deleteUserAtIndex:(NSInteger)index
{
	NSMutableArray *players = [[PlayerManager sharedInstance] players];
	Player *player = [players objectAtIndex:index];
	[[PlayerManager sharedInstance] removePlayer:player];
	
	[self.playersTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]]
								 withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark - UIAlertView delegate

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == alertView.cancelButtonIndex)
		return;

	if (alertView.tag >= 100)
	{
		[self deleteUserAtIndex:alertView.tag - 100];
		return;
	}
	
	NSString *playerName = [[[alertView textFieldAtIndex:0] text] capitalizedString];
	
	if([playerName isEqualToString:@""])
		return;
	
	Player *player = [[Player alloc] initWithName:playerName];
	[[PlayerManager sharedInstance] addPlayer:player];
	
	NSIndexPath *playerIndexPath = [NSIndexPath indexPathForRow:[[PlayerManager sharedInstance] indexForPlayer:player]
													  inSection:0];
	
	[self.playersTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:playerIndexPath]
								 withRowAnimation:UITableViewRowAnimationTop];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - Dismiss

- (void) handleTapBehind:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded && iPad)
    {
        CGPoint location = [sender locationInView:nil];
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil])
        {
            [self.view.window removeGestureRecognizer:sender];
            [self dismiss];
        }
    }
}

- (void) dismiss
{
    for (UIGestureRecognizer *gr in [self.view.window gestureRecognizers])
        [self.view.window removeGestureRecognizer:gr];
    
    [self.navigationController popViewControllerAnimated:YES];
    
//    if (iPad)
//        [self dismissModalViewControllerAnimated:YES];
//    else
//        [self.navigationController popViewControllerAnimated:YES];
}

@end
