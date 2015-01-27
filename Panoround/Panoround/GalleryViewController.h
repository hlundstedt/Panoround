//
//  GalleryViewController.h
//  Panoround
//
//  Created by Henrik Lundstedt on 5/21/14.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PhotoManager.h"
#import "PhotoCell.h"
#import "StackLayout.h"
#import "PhotoViewController.h"
#import "ToPhotoTransition.h"

@interface GalleryViewController : UIViewController <UICollectionViewDataSource, UINavigationControllerDelegate, CLLocationManagerDelegate, StackLayoutDelegate, PhotoManagerDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *areaControl;
@property (nonatomic, weak) IBOutlet StackLayout *stackLayout;
@property (nonatomic, strong) NSMutableArray *photos;

@end
