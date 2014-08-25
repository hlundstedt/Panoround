//
//  StackLayout.m
//  Panoround
//
//  Created by Henrik Lundstedt on 2014-08-14.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import "StackLayout.h"

@implementation StackLayout

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    _numberOfColumns = DEFAULT_NUMBER_OF_COLUMNS;
    _numberOfRows = DEFAULT_NUMBER_OF_ROWS;
}

#pragma mark - StackLayout

- (CGRect)frameForViewWithDimen:(CGSize)dimen
{
    _imageWidth = self.collectionView.frame.size.width / _numberOfColumns;
    
    float aspectRatio = dimen.width / dimen.height;
    int height = _imageWidth / aspectRatio;
    
    int minColumn = -1;
    int minHeight = INFINITY;
    for (int i=0; i<_numberOfColumns; ++i) {
        int height = [[_columnHeights objectAtIndex:i] intValue];
        if (height < minHeight) {
            minColumn = i;
            minHeight = height;
        }
    }
    _columnHeights[minColumn] = @([_columnHeights[minColumn] intValue] + height);
    
    return CGRectMake(_imageWidth * minColumn, minHeight, _imageWidth, height);
}

#pragma mark - StackLayout

- (void)setNumberOfColumns:(NSInteger)numberOfColumns
{
    if (numberOfColumns != _numberOfColumns) {
        _numberOfColumns = numberOfColumns;
        [self invalidateLayout];
    }
}

- (void)setNumberOfRows:(NSInteger)numberOfRows
{
    if (numberOfRows != _numberOfRows) {
        _numberOfRows = numberOfRows;
        [self invalidateLayout];
    }
}

#pragma mark - UICollectionViewLayout

- (void)prepareLayout
{
    NSMutableDictionary *layoutInfo = [NSMutableDictionary dictionary];
    _columnHeights = [[NSMutableArray alloc] initWithCapacity:_numberOfColumns];
    for (int i=0; i<_numberOfColumns; ++i) {
        _columnHeights[i] = @0;
    }
    _contentHeight = 0;
    
    NSInteger numItems = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger item = 0; item < numItems; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        
        UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGSize dimen = [_customDataSource dimensionForViewAtIndexPath:indexPath];
        itemAttributes.frame = [self frameForViewWithDimen:dimen];
        int maxY = CGRectGetMaxY(itemAttributes.frame);
        if (maxY > _contentHeight) {
            _contentHeight = maxY;
        }
        
        layoutInfo[indexPath] = itemAttributes;
    }
    
    _layoutInfo = layoutInfo;
    _collectionViewContentSize = CGSizeMake(self.collectionView.frame.size.width, _contentHeight);
}

- (CGSize)collectionViewContentSize
{
    return _collectionViewContentSize;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    [_layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }];
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _layoutInfo[indexPath];
}

- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attrs = [[self layoutAttributesForItemAtIndexPath:itemIndexPath] copy];
    attrs.frame = CGRectMake(attrs.frame.origin.x, MAX(self.collectionView.frame.size.height, _contentHeight),
                             attrs.frame.size.width, attrs.frame.size.height);
    return attrs;
}

@end
