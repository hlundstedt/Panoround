//
//  PhotoViewController.h
//  Panoround
//
//  Created by Henrik Lundstedt on 2014-08-27.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "FromPhotoTransition.h"
#import "GalleryViewController.h"
#import "Photo.h"

@interface PhotoViewController : UIViewController <UIScrollViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) Photo *mediumPhoto;
@property (nonatomic, strong) Photo *originalPhoto;

@end
