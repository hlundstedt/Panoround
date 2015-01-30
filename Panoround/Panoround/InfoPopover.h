//
//  InfoPopover.h
//  Panoround
//
//  Created by Henrik Lundstedt on 2015-01-30.
//  Copyright (c) 2015 Macadamian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoPopover : UIView

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *owner;
@property (nonatomic, weak) IBOutlet UILabel *date;

@end
