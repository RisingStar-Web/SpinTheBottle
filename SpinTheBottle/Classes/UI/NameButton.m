//
//  NameButton.m
//  SpinTheBottle
//
//  Created by Matt Davenport on 29/08/2012.
//  Copyright (c) 2012 Taptastic Apps. All rights reserved.
//

#import "NameButton.h"

#define kFontSize			(iPad ? 22 : 12)
#define kTextPadding		(iPad ? 40 : 20)

@implementation NameButton

- (id) initWithTitle:(NSString *)title
{
	self = [super init];
	if (self)
	{
		[self setBackgroundImage:[UIImage universalImageNamed:@"NameBackground.png"] forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage universalImageNamed:@"NameBackground.png"] forState:UIControlStateHighlighted];
		
		[self setTitle:title forState:UIControlStateNormal];
		[self setTitleColor:rgb(99, 16, 0) forState:UIControlStateNormal];
		[self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
		[self.titleLabel setFont:[UIFont fontWithName:@"Days" size:kFontSize]];
		[self.titleLabel setAdjustsFontSizeToFitWidth:YES];
		[self.titleLabel setTextAlignment:UITextAlignmentCenter];
	}
	return self;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	self.titleLabel.frame = CGRectMake(kTextPadding, (self.frame.size.height-(kFontSize+4))/2,
									   self.frame.size.width-(kTextPadding*2), kFontSize+4);
}

@end
