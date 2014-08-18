//
//  ViewController.h
//  Panoround
//
//  Created by Henrik Lundstedt on 5/21/14.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoManager.h"
#import "PhotoCell.h"
#import "StackLayout.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, StackLayoutDelegate, PhotoManagerDelegate>

@property (nonatomic, strong) NSMutableArray<Photo> *photos;

@end
