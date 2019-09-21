//
//  Player.m
//  SpinTheBottle
//
//  Created by Matt Davenport on 11/05/2012.
//  Copyright (c) 2012 Taptastic Apps All rights reserved.
//

#import "Player.h"

@implementation Player

@synthesize name = _name;

- (void) encodeWithCoder:(NSCoder *)coder 
{
    [coder encodeObject:self.name forKey:@"PName"];
}

- (id) initWithCoder:(NSCoder *)coder 
{
	self.name = [coder decodeObjectForKey:@"PName"];
    return self;
}

- (id) initWithName:(NSString *)name
{
	self = [super init];
	if (self)
	{
		self.name = name;
	}
	return self;
}

@end
