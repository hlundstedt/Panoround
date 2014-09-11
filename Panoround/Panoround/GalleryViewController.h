//
//  GalleryViewController.h
//  Panoround
//
//  Created by Henrik Lundstedt on 5/21/14.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoManager.h"
#import "PhotoCell.h"
#import "StackLayout.h"
#import "PhotoViewController.h"

@interface GalleryViewController : UIViewController <UICollectionViewDataSource, StackLayoutDelegate, PhotoManagerDelegate>

@property (nonatomic, weak) IBOutlet UISegmentedControl *areaControl;
@property (nonatomic, weak) IBOutlet StackLayout *stackLayout;
@property (nonatomic, strong) NSMutableArray *photos;

@end
