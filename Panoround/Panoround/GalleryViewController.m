//
//  GalleryViewController.m
//  Panoround
//
//  Created by Henrik Lundstedt on 5/21/14.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import "GalleryViewController.h"

@interface GalleryViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation GalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [_collectionView.viewForBaselineLayout.layer setSpeed:0.1f];
    _photos = [NSMutableArray array];
    _stackLayout.customDataSource = self;
    [_stackLayout setIsPortrait: UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])];
	[PhotoManager getPanoramasFromLocation:CLLocationCoordinate2DMake(55.7058400, 13.1932100) distance:5000 delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receivedPanoramas:(Panoramas *)panoramas
{
    for (int i=0; i<panoramas.photos.count; i++) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_photos addObject:[panoramas.photos objectAtIndex:i]];
            NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
            [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            [_collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
        });
        [NSThread sleepForTimeInterval:0.2];
    }
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
    [self performSegueWithIdentifier:@"showPhoto" sender:self];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark - View Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [_stackLayout setOrientationPortrait:UIInterfaceOrientationIsPortrait(toInterfaceOrientation)];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPhoto"]) {
        PhotoViewController *viewController = (PhotoViewController*) [segue destinationViewController];
        viewController.photo = [_photos objectAtIndex:[[[self.collectionView indexPathsForSelectedItems] objectAtIndex:0] row]];
    }
}

@end
