//
//  BackButton.m
//  SpinTheBottle
//
//  Created by Matt Davenport on 01/02/2013.
//  Copyright (c) 2013 Taptastic Apps. All rights reserved.
//

#import "BackButton.h"

#define kFontSize			(iPad ? 40 : 16)
#define kShadowSize			(iPad ? 2 : 1)

@implementation BackButton

- (id) init
{
	self = [super init];
	if (self)
	{
		[self setBackgroundImage:[UIImage universalImageNamed:@"BackBtn.png"] forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage universalImageNamed:@"BackBtnPushed.png"] forState:UIControlStateHighlighted];
		
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
	
	self.titleLabel.frame = CGRectMake(15, 3, self.frame.size.width - 20, self.frame.size.height);
}
@end
