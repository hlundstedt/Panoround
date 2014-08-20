//
//  CALayer+XibConfiguration.m
//  Panoround
//
//  Created by Henrik Lundstedt on 2014-08-19.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer(XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
