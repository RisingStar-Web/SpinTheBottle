//
//  AddPlayerCell.m
//  SpinTheBottle
//
//  Created by Matt Davenport on 30/08/2012.
//  Copyright (c) 2012 Taptastic Apps. All rights reserved.
//

#import "AddPlayerCell.h"

@interface AddPlayerCell()

@property (strong) UIView *seperator;

@end

@implementation AddPlayerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont fontWithName:@"Days" size:22];
		self.textLabel.adjustsFontSizeToFitWidth = YES;
		self.textLabel.textColor = rgb(99, 16, 0);
		
		self.seperator = [[UIView alloc] init];
		self.seperator.backgroundColor = rgb(195, 193, 189);
		[self addSubview:self.seperator];
    }
    return self;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	self.textLabel.frame = CGRectMake(15, 0, self.frame.size.width-100, self.frame.size.height);
	self.seperator.frame = CGRectMake(0, 0, self.frame.size.width+100, 1);
	
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

	if (selected)
	{
		self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.05];
	}
	else
	{
		self.backgroundColor = [UIColor clearColor];
	}
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	[self setSelected:highlighted animated:animated];
}

@end
