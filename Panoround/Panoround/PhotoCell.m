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
    if (_photo != photo) {
        _photo = photo;
    }
    
    NSURL *url = [[NSURL alloc] initWithString:_photo.photo_file_url];
    NSLog(@"Requesting photo from %@", [url absoluteString]);
    
    [_activityIndicator startAnimating];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error) {
                                   //TODO: Error handling
                               } else {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   _imageView.image = image;
                               }
                               
                               [_activityIndicator stopAnimating];
                               [_activityIndicator setHidden:NO];
                           }];
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
