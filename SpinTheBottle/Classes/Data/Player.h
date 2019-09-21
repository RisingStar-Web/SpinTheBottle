//
//  Player.h
//  SpinTheBottle
//
//  Created by Matt Davenport on 11/05/2012.
//  Copyright (c) 2012 Taptastic Apps All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Player : NSObject

@property (nonatomic, strong) NSString *name;

- (id) initWithName:(NSString *)name;

@end
