//
//  StackLayout.h
//  Panoround
//
//  Created by Henrik Lundstedt on 2014-08-14.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_NUMBER_OF_COLUMNS 3
#define DEFAULT_NUMBER_OF_ROWS 3

@protocol StackLayoutDelegate

- (CGSize)dimensionForViewAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface StackLayout : UICollectionViewLayout

@property (nonatomic, weak) id<StackLayoutDelegate> customDataSource;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic) NSInteger numberOfRows;
@property (nonatomic) BOOL isPortrait;
@property (nonatomic) int contentHeight;
@property (nonatomic) int contentWidth;
@property (nonatomic, strong) NSMutableArray *columnHeights;
@property (nonatomic, strong) NSMutableArray *rowWidths;
@property (nonatomic, strong) NSMutableArray *indexPathsToAnimate;
@property (nonatomic, strong) NSDictionary *layoutInfo;
@property (nonatomic, strong) NSMutableDictionary *finalLayout;
@property (nonatomic) CGSize collectionViewContentSize;

- (void)setNumberOfColumns:(NSInteger)numberOfColumns;
- (void)setNumberOfRows:(NSInteger)numberOfRows;
- (void)setOrientationPortrait:(BOOL)portrait;

@end
