//
//  InfoPopover.m
//  Panoround
//
//  Created by Henrik Lundstedt on 2015-01-30.
//  Copyright (c) 2015 Macadamian. All rights reserved.
//

#import "InfoPopover.h"

@interface InfoPopover ()

@property (nonatomic, strong) UIView *view;

@end

@implementation InfoPopover

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        [self setup];
    }
    return self;
}

- (void)setup
{
    _view = [[[NSBundle mainBundle] loadNibNamed:@"InfoPopover" owner:self options:nil] lastObject];
    self.frame = _view.bounds;
    [self addSubview:_view];
}

@end
