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
    _isPortrait = true;
}

#pragma mark - StackLayout

- (CGRect)frameForViewWithDimen:(CGSize)dimen isPortrait:(BOOL)portrait
{
    float aspectRatio = dimen.width / dimen.height;
    if (portrait) {
        int imageWidth = self.collectionView.frame.size.width / _numberOfColumns;
        int height = imageWidth / aspectRatio;
        
        int minColumn = -1;
        int minHeight = INFINITY;
        for (int i=0; i<_numberOfColumns; ++i) {
            int height = [[_columnHeights objectAtIndex:i] intValue];
            if (height < minHeight) {
                minColumn = i;
                minHeight = height;
            }
        }
        int columnHeight = [_columnHeights[minColumn] intValue] + height;
        _columnHeights[minColumn] = @(columnHeight);
        if (columnHeight > _contentHeight) {
            _contentHeight = columnHeight;
        }
        
        return CGRectMake(imageWidth * minColumn, minHeight, imageWidth, height);
    } else {
        int imageHeight =  self.collectionView.frame.size.height / _numberOfRows;
        int width = imageHeight * aspectRatio;
        
        int minRow = -1;
        int minWidth = INFINITY;
        for (int i=0; i<_numberOfRows; i++) {
            int width = [[_rowWidths objectAtIndex:i] intValue];
            if (width < minWidth) {
                minRow = i;
                minWidth = width;
            }
        }
        int rowWidth = [_rowWidths[minRow] intValue] + width;
        _rowWidths[minRow] = @(rowWidth);
        if (rowWidth > _contentWidth) {
            _contentWidth = rowWidth;
        }
        
        return CGRectMake(minWidth, imageHeight * minRow, width, imageHeight);
    }
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

- (void)setOrientationPortrait:(BOOL)portrait
{
    if (portrait != _isPortrait) {
        _isPortrait = portrait;
        [self invalidateLayout];
    }
}

-(void) resetLayoutAttributes
{
    _columnHeights = [[NSMutableArray alloc] initWithCapacity:_numberOfColumns];
    for (int i=0; i<_numberOfColumns; ++i) {
        _columnHeights[i] = @0;
    }
    _contentHeight = 0;
    
    _rowWidths = [[NSMutableArray alloc] initWithCapacity:_numberOfRows];
    for (int i=0; i<_numberOfRows; ++i) {
        _rowWidths[i] = @0;
    }
    _contentWidth = 0;
}

#pragma mark - UICollectionViewLayout

- (void)prepareLayout
{
    NSMutableDictionary *layoutInfo = [NSMutableDictionary dictionary];
    [self resetLayoutAttributes];
    
    NSInteger numItems = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger item = 0; item < numItems; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        
        UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGSize dimen = [_customDataSource dimensionForViewAtIndexPath:indexPath];
        itemAttributes.frame = [self frameForViewWithDimen:dimen isPortrait:_isPortrait];
        
        layoutInfo[indexPath] = itemAttributes;
    }
    
    _layoutInfo = layoutInfo;
    if (_isPortrait) {
        _collectionViewContentSize = CGSizeMake(self.collectionView.frame.size.width, _contentHeight);
    } else {
        _collectionViewContentSize = CGSizeMake(_contentWidth, self.collectionView.frame.size.height);
    }
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
    
    if ([_indexPathsToAnimate containsObject:itemIndexPath]) {
        attrs.frame = _isPortrait ? CGRectMake(attrs.frame.origin.x, MAX(self.collectionView.frame.size.height, _contentHeight), attrs.frame.size.width, attrs.frame.size.height) : CGRectMake(MAX(self.collectionView.frame.size.width, _contentWidth), attrs.frame.origin.y, attrs.frame.size.width, attrs.frame.size.height);
        [_indexPathsToAnimate removeObject:itemIndexPath];
    }
    
    return attrs;
}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    return [self initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            case UICollectionUpdateActionDelete:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                break;
            case UICollectionUpdateActionMove:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            default:
                NSLog(@"unhandled case: %@", updateItem);
                break;
        }
    }
    _indexPathsToAnimate = indexPaths;
}

@end
