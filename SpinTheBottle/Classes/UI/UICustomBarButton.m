//
//  UICustomBarButton.m
//  SpinTheBottle
//
//  Created by Matt Davenport on 02/08/2012.
//  Copyright (c) 2012 Taptastic Apps. All rights reserved.
//

#import "UICustomBarButton.h"

@implementation UICustomBarButton

- (id)init
{
    self = [super init];
    if (self) {
		self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1.0];
		self.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
		self.layer.borderWidth = 1.0;
		self.layer.cornerRadius = 6.0;
    }
    return self;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	CGRect f = self.frame;
	f.size.width = ([self.currentTitle sizeWithFont:self.titleLabel.font].width)+20;
	self.frame = f;
}

- (void) selected
{
	[self setTitleColor:[UIColor colorWithWhite:0.8 alpha:1.0] forState:UIControlStateNormal];
	self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
}

- (void) deselected
{
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1.0];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	[self selected];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
	[self deselected];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	[self deselected];
}

@end
