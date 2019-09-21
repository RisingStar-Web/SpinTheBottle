//
//  PlayerManager.h
//  SpinTheBottle
//
//  Created by Matt Davenport on 11/05/2012.
//  Copyright (c) 2012 Taptastic Apps All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface PlayerManager : NSObject

@property (nonatomic, strong) NSMutableArray *players;

+ (PlayerManager *) sharedInstance;

- (void) loadPlayers;
- (void) savePlayers;
- (void) addPlayer:(Player *)player;
- (void) removePlayer:(Player *)player;
- (void) removePlayerAtIndex:(int)index;
- (int) indexForPlayer:(Player *)player;

@end
