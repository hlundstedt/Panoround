//
//  PhotoViewController.h
//  Panoround
//
//  Created by Henrik Lundstedt on 2014-08-27.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PhotoViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) Photo *photo;

@end
