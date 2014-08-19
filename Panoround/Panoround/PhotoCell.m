//
//  PhotoCell.m
//  Panoround
//
//  Created by Henrik Lundstedt on 5/22/14.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

-(void) setPhoto:(Photo *)photo
{
    _photo = photo;
    
    NSLog(@"Requesting photo from %@", [photo.photo_file_url absoluteString]);
    
    _imageView.image = nil;
    [_activityIndicator setHidden:NO];
    [_activityIndicator startAnimating];
    [_imageView sd_setImageWithURL:photo.photo_file_url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageUrl) {
        [_activityIndicator stopAnimating];
        [_activityIndicator setHidden:YES];
    }];
}

-(void) setDownloadAnimationEnabled:(BOOL)enabled
{
    [_activityIndicator setHidden:!enabled];
    if (enabled) {
        [_activityIndicator startAnimating];
    } else {
        [_activityIndicator stopAnimating];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
