//
//  FromPhotoTransition.m
//  Panoround
//
//  Created by Henrik Lundstedt on 2014-09-18.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import "FromPhotoTransition.h"

@implementation FromPhotoTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    PhotoViewController *photoViewController = (PhotoViewController*) [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    GalleryViewController *galleryViewController = (GalleryViewController*) [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    PhotoCell *cell = (PhotoCell*)[galleryViewController.collectionView cellForItemAtIndexPath:[[galleryViewController.collectionView indexPathsForSelectedItems] firstObject]];
    cell.imageView.hidden = YES;
    
    UIImageView *imageSnapshot = [[UIImageView alloc] initWithImage:cell.imageView.image];
    imageSnapshot.frame = [containerView convertRect:photoViewController.imageView.frame fromView:photoViewController.imageView.superview];
    
    photoViewController.imageView.hidden = YES;
    
    galleryViewController.view.frame = [transitionContext finalFrameForViewController:galleryViewController];
    [containerView insertSubview:galleryViewController.view belowSubview:photoViewController.view];
    [containerView addSubview:imageSnapshot];
    
    [UIView animateWithDuration:duration animations:^{
        photoViewController.view.alpha = 0;
        imageSnapshot.frame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
    } completion:^(BOOL finished) {
        [imageSnapshot removeFromSuperview];
        photoViewController.imageView.hidden = NO;
        cell.imageView.hidden = NO;
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.8;
}

@end
