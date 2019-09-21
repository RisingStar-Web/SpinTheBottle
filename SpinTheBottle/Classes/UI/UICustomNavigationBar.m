//
//  UICustomNavigationBar.m
//  SpinTheBottle
//
//  Created by Matt Davenport on 02/08/2012.
//  Copyright (c) 2012 Taptastic Apps. All rights reserved.
//

#import "UICustomNavigationBar.h"

@implementation UICustomNavigationBar

- (id) init
{
    self = [super init];
    if (self)
	{
		self.backgroundColor = [UIColor darkGrayColor];
		self.layer.shadowColor = [UIColor blackColor].CGColor;
		self.layer.shadowOffset = CGSizeMake(0, 0);
		self.layer.shadowOpacity = 0.6;
		self.layer.shadowRadius = 3.0;
		
		self.titleLabel = [[UILabel alloc] init];
		[self.titleLabel setBackgroundColor:[UIColor clearColor]];
		[self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
		[self.titleLabel setTextAlignment:UITextAlignmentCenter];
		[self.titleLabel setTextColor:[UIColor whiteColor]];
		[self.titleLabel setAdjustsFontSizeToFitWidth:YES];
		[self addSubview:self.titleLabel];
		
		self.leftBarButton = [[UICustomBarButton alloc] init];
		[self.leftBarButton setTitle:@"Back" forState:UIControlStateNormal];
		[self addSubview:self.leftBarButton];
		
		self.rightBarButton = [[UICustomBarButton alloc] init];
		[self.rightBarButton setTitle:@"Restore" forState:UIControlStateNormal];
		[self addSubview:self.rightBarButton];
	}
    return self;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	self.titleLabel.frame = CGRectMake(100, 0, self.frame.size.width-200, self.frame.size.height);
	self.leftBarButton.frame = CGRectMake(5, (self.frame.size.height-30)/2, self.leftBarButton.frame.size.width, 30);
	self.rightBarButton.frame = CGRectMake(self.frame.size.width-self.rightBarButton.frame.size.width-5, (self.frame.size.height-30)/2, self.rightBarButton.frame.size.width, 30);
}

@end
