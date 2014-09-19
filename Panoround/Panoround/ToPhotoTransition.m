//
//  ToPhotoTransition.m
//  Panoround
//
//  Created by Henrik Lundstedt on 2014-09-18.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import "ToPhotoTransition.h"

@implementation ToPhotoTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    GalleryViewController *galleryViewController = (GalleryViewController*) [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    PhotoViewController *photoViewController = (PhotoViewController*) [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    PhotoCell *cell = (PhotoCell*)[galleryViewController.collectionView cellForItemAtIndexPath:[[galleryViewController.collectionView indexPathsForSelectedItems] firstObject]];
    UIView *cellImageSnapshot = [cell.imageView snapshotViewAfterScreenUpdates:NO];
    cellImageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
    cell.imageView.hidden = YES;
    
    photoViewController.view.frame = [transitionContext finalFrameForViewController:photoViewController];
    photoViewController.view.alpha = 0;
    photoViewController.imageView.hidden = YES;
    
    [containerView addSubview:photoViewController.view];
    [containerView addSubview:cellImageSnapshot];
    
    [UIView animateWithDuration:duration animations:^{
        photoViewController.view.alpha = 1.0;
        
        CGRect frame = [containerView convertRect:photoViewController.imageView.frame fromView:photoViewController.view];
        cellImageSnapshot.frame = frame;
    } completion:^(BOOL finished) {
        photoViewController.imageView.hidden = NO;
        cell.imageView.hidden = NO;
        [cellImageSnapshot removeFromSuperview];
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.8;
}

@end
