//
//  PlayerManager.m
//  SpinTheBottle
//
//  Created by Matt Davenport on 11/05/2012.
//  Copyright (c) 2012 Taptastic Apps All rights reserved.
//

#import "Paths.h"
#import "PlayerManager.h"

#define kReloadPlayers		@"kReloadPlayers"

@interface PlayerManager()

- (void) notifyReload;

@end

@implementation PlayerManager

@synthesize players = _players;

- (id) init
{
	self = [super init];
	if (self)
	{
		self.players = [NSMutableArray array];
		[self loadPlayers];
	}
	return self;
}

#pragma mark - Data handling

- (void) loadPlayers
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if([userDefaults objectForKey:@"players"])
	{
		NSData *data = [[NSMutableData alloc] initWithData:[userDefaults objectForKey:@"players"]];
		NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		self.players = [unarchiver decodeObjectForKey:@"players"];
	}
}

- (void) savePlayers
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
	[archiver encodeObject:self.players forKey:@"players"];
	[archiver finishEncoding];
	[userDefaults setObject:data forKey:@"players"];
	[userDefaults synchronize];
}

- (void) addPlayer:(Player *)player
{
	[self.players addObject:player];
	[self savePlayers];
	[self notifyReload];
}

- (void) removePlayer:(Player *)player
{
	[self.players removeObject:player];
	[self savePlayers];
	[self notifyReload];
}

- (void) removePlayerAtIndex:(int)index
{
	[self.players removeObjectAtIndex:index];
	[self savePlayers];
	[self notifyReload];
}

- (int) indexForPlayer:(Player *)player
{
	return [self.players indexOfObject:player];
}

#pragma mark - Notifications

- (void) notifyReload
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kReloadPlayers
														object:self 
													  userInfo:nil];
}

#pragma mark - Singleton setup

+ (PlayerManager *) sharedInstance {
    static dispatch_once_t pred;
    static PlayerManager *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[PlayerManager alloc] init];
    });
    return shared;
}

@end
