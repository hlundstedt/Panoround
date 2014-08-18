//
//  ViewController.m
//  Panoround
//
//  Created by Henrik Lundstedt on 5/21/14.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    ((StackLayout*) _collectionView.collectionViewLayout).customDataSource = self;
	[PhotoManager getPanoramasFromLocation:CLLocationCoordinate2DMake(55.7058400, 13.1932100) distance:5000 delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receivedPanoramas:(Panoramas *)panoramas
{
    _photos = [panoramas.photos mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_collectionView reloadData];
    });
    for (Photo *photo in _photos) {
        NSLog(@"Received photo with dimesions (%d, %d)", photo.width, photo.height);
    }
}

- (void)getPanoramasFailedWithError:(NSError *)error
{
    NSLog(@"Get panoramas failed: %@", [error userInfo]);
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_photos count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    [cell setPhoto:[_photos objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - StackLayoutDelegate

- (CGSize)dimensionForViewAtIndexPath:(NSIndexPath *)indexPath
{
    Photo *photo = [_photos objectAtIndex:indexPath.row];
    return CGSizeMake(photo.width, photo.height);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

@end
