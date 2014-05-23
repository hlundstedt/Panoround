//
//  PhotoCell.h
//  Panoround
//
//  Created by Henrik Lundstedt on 5/22/14.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface PhotoCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) Photo *photo;

-(void) setPhoto:(Photo *)photo;
-(void) setDownloadAnimationEnabled:(BOOL)enabled;

@end
