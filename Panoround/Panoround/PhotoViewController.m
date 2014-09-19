//
//  PhotoViewController.m
//  Panoround
//
//  Created by Henrik Lundstedt on 2014-08-27.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;

@end

@implementation PhotoViewController

@synthesize imageView = _imageView;

#pragma mark - Private

- (void)centerScrollViewContents
{
    CGSize boundsSize = self.view.frame.size;
    CGRect contentsFrame = _imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    _imageView.frame = contentsFrame;
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer *)recognizer
{
    
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer *)recognizer
{
    
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _photo.width, _photo.height)];
    [_imageView sd_setImageWithURL:_photo.photo_file_url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageUrl) {
        // Loading complete
    }];
    [_scrollView addSubview:_imageView];
    _scrollView.contentSize = _imageView.frame.size;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    CGFloat scaleWidth = _scrollView.frame.size.width / _scrollView.contentSize.width;
    CGFloat scaleHeight = _scrollView.frame.size.height / _scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    _scrollView.minimumZoomScale = minScale;
    
    _scrollView.maximumZoomScale = 1.0f;
    _scrollView.zoomScale = minScale;
    
    [self centerScrollViewContents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if (fromVC == self && [toVC isKindOfClass:[GalleryViewController class]]) {
        return [[FromPhotoTransition alloc] init];
    }
    
    return nil;
}

@end
