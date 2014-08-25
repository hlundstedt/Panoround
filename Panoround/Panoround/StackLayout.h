//
//  StackLayout.h
//  Panoround
//
//  Created by Henrik Lundstedt on 2014-08-14.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_NUMBER_OF_COLUMNS 3
#define DEFAULT_NUMBER_OF_ROWS 5

@protocol StackLayoutDelegate

- (CGSize)dimensionForViewAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface StackLayout : UICollectionViewLayout

@property (nonatomic, weak) id<StackLayoutDelegate> customDataSource;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic) NSInteger numberOfRows;
@property (nonatomic) int imageWidth;
@property (nonatomic) int contentHeight;
@property (nonatomic, strong) NSMutableArray *columnHeights;
@property (nonatomic, strong) NSDictionary *layoutInfo;
@property (nonatomic) CGSize collectionViewContentSize;

- (void)setNumberOfColumns:(NSInteger)numberOfColumns;
- (void)setNumberOfRows:(NSInteger)numberOfRows;

@end
