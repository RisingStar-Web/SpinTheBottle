//
//  UICustomNavigationBar.h
//  SpinTheBottle
//
//  Created by Matt Davenport on 02/08/2012.
//  Copyright (c) 2012 Taptastic Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomBarButton.h"

@interface UICustomNavigationBar : UIView

@property (strong) UILabel *titleLabel;
@property (strong) UICustomBarButton *leftBarButton;
@property (strong) UICustomBarButton *rightBarButton;

@end
