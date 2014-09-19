//
//  GalleryViewController.m
//  Panoround
//
//  Created by Henrik Lundstedt on 5/21/14.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import "GalleryViewController.h"

@interface GalleryViewController ()

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, strong) NSArray *areaDistances;

@end

@implementation GalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
//    [_collectionView.viewForBaselineLayout.layer setSpeed:0.2f];
    _areaDistances = @[@1000, @5000, @10000, @50000, @100000];
    _photos = [NSMutableArray array];
    [_areaControl sendActionsForControlEvents:UIControlEventValueChanged];
    
    _stackLayout.customDataSource = self;
    [_stackLayout setIsPortrait: UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)areaControlAction:(id)sender
{
    [self clearPhotos];
    int distance = [[_areaDistances objectAtIndex:_areaControl.selectedSegmentIndex] intValue];
    [self setDownloadIndicatorEnabled:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [PhotoManager getPanoramasFromLocation:CLLocationCoordinate2DMake(51.5073, -0.1277) distance:distance delegate:self];
    });
    // Lund 55.7058400, 13.1932100
}

- (void)clearPhotos
{
    [_collectionView performBatchUpdates:^{
        int photoCount = _photos.count;
        NSMutableArray *arrayWithIndexPathsRemove = [NSMutableArray array];
        
        [_photos removeAllObjects];
        for (int i=0; i<photoCount; i++) {
            [arrayWithIndexPathsRemove addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [_collectionView deleteItemsAtIndexPaths:arrayWithIndexPathsRemove];
    } completion:nil];
}

- (void)setDownloadIndicatorEnabled:(BOOL)enabled
{
    [_indicator setHidden:!enabled];
    enabled ? [_indicator startAnimating] : [_indicator startAnimating];
}

- (void)receivedPanoramas:(Panoramas *)panoramas
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setDownloadIndicatorEnabled:NO];
        [_collectionView performBatchUpdates:^{
            NSMutableArray *arrayWithIndexPathsInsert = [NSMutableArray array];
            
            for (int i=0; i<panoramas.photos.count; i++) {
                [_photos addObject:[panoramas.photos objectAtIndex:i]];
                [arrayWithIndexPathsInsert addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            [_collectionView insertItemsAtIndexPaths:arrayWithIndexPathsInsert];
        } completion:nil];
    });
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPhoto"]) {
        PhotoViewController *viewController = (PhotoViewController*) [segue destinationViewController];
        viewController.photo = [_photos objectAtIndex:[[[self.collectionView indexPathsForSelectedItems] objectAtIndex:0] row]];
    }
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (fromVC == self && [toVC isKindOfClass:[PhotoViewController class]]) {
        return [[ToPhotoTransition alloc] init];
    }
    
    return nil;
}

@end
