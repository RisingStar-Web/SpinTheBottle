//
//  LargeButton.m
//  SpinTheBottle
//
//  Created by Matt Davenport on 01/02/2013.
//  Copyright (c) 2013 Taptastic Apps. All rights reserved.
//

#import "LargeButton.h"

#define kFontSize			(iPad ? 40 : 30)
#define kShadowSize			(iPad ? 2 : 1)

@implementation LargeButton

- (id) init
{
	self = [super init];
	if (self)
	{
		[self setBackgroundImage:[UIImage universalImageNamed:@"LargeBtn.png"] forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage universalImageNamed:@"LargeBtnPushed.png"] forState:UIControlStateHighlighted];
		
		[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
		[self.titleLabel setFont:[UIFont fontWithName:@"Debussy" size:kFontSize]];
		[self.titleLabel setAdjustsFontSizeToFitWidth:YES];
		[self.titleLabel setTextAlignment:UITextAlignmentCenter];
		[self.titleLabel setShadowColor:rgb(99, 16, 0)];
		[self.titleLabel setShadowOffset:CGSizeMake(0, kShadowSize)];
		
		[self layoutSubviews];
	}
	return self;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	self.bounds = CGRectMake(0, 0, self.currentBackgroundImage.size.width, self.currentBackgroundImage.size.height);
	
	self.titleLabel.frame = self.bounds;
	self.titleLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) + 5);
}
@end
