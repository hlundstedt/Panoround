//
//  StackLayout.h
//  Panoround
//
//  Created by Henrik Lundstedt on 2014-08-14.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COLUMNS 3

@protocol StackLayoutDelegate

- (CGSize)dimensionForViewAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface StackLayout : UICollectionViewLayout

@property (nonatomic, weak) id<StackLayoutDelegate> customDataSource;

@property (nonatomic) int imageWidth;
@property (nonatomic) int contentHeight;
@property (nonatomic, strong) NSMutableArray *columnHeights;
@property (nonatomic, strong) NSDictionary *layoutInfo;
@property (nonatomic) CGSize collectionViewContentSize;

@end
