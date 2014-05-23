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
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:photo.photo_file_url] queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ([response.URL isEqual:_photo.photo_file_url]) {
                                   if (error) {
                                       //TODO: Error handling
                                   } else {
                                       UIImage *image = [[UIImage alloc] initWithData:data];
                                       _imageView.image = image;
                                   }
                                   [_activityIndicator stopAnimating];
                                   [_activityIndicator setHidden:YES];
                               }
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
