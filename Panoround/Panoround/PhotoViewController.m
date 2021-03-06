//
//  PhotoViewController.m
//  Panoround
//
//  Created by Henrik Lundstedt on 2014-08-27.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import "PhotoViewController.h"
#import "MapViewController.h"
#import "InfoPopover.h"

@interface PhotoViewController ()

@property (nonatomic, strong) UIBarButtonItem *infoBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *mapBarButtonItem;
@property (nonatomic, strong) UIPopoverController *infoPopoverController;

- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;

@end

@implementation PhotoViewController

@synthesize imageView = _imageView;

#pragma mark - Private

- (void)setupScrollView
{
    CGFloat scaleWidth = self.view.frame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = self.view.frame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    _scrollView.minimumZoomScale = minScale;
    _scrollView.maximumZoomScale = 1.0f;
    _scrollView.zoomScale = minScale;
}

- (void)centerScrollViewContents
{
    CGSize boundsSize = self.view.bounds.size;
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
    CGPoint tapPoint = [recognizer locationInView:_imageView];
    CGFloat newZoomScale = MAX(_scrollView.zoomScale * 1.5f, _scrollView.maximumZoomScale);
    
    CGSize scrollViewsSize = _scrollView.bounds.size;
    CGFloat w = scrollViewsSize.width / newZoomScale;
    CGFloat h = scrollViewsSize.height / newZoomScale;
    CGFloat x = tapPoint.x - w / 2.0f;
    CGFloat y = tapPoint.y - h / 2.0f;
    
    [_scrollView zoomToRect:CGRectMake(x, y, w, h) animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer *)recognizer
{
    CGFloat newZoomScale = MAX(_scrollView.zoomScale / 1.5f, _scrollView.minimumZoomScale);
    [_scrollView setZoomScale:newZoomScale animated:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerScrollViewContents];
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    _infoBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickInfoButton:)];
    _mapBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"globe_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickMapButton:)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:_infoBarButtonItem, _mapBarButtonItem, nil];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _originalPhoto.width, _originalPhoto.height)];
    [_imageView sd_setImageWithURL:_originalPhoto.photo_file_url placeholderImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:_mediumPhoto.photo_file_url]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageUrl) {
        // Image loaded
    }];
    [_scrollView addSubview:_imageView];
    _scrollView.contentSize = CGSizeMake(_originalPhoto.width, _originalPhoto.height);
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
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
    [super viewWillAppear:animated];
    [self setupScrollView];
    [self centerScrollViewContents];
}

- (void)viewDidLayoutSubviews
{
    _scrollView.contentSize = CGSizeMake(_originalPhoto.width, _originalPhoto.height);
    [self setupScrollView];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showOnMap"]) {
        MapViewController *viewController = [segue destinationViewController];
        viewController.photoLocation = CLLocationCoordinate2DMake(_originalPhoto.latitude, _originalPhoto.longitude);
    }
}

#pragma mark - Actions

- (IBAction)didClickMapButton:(id)sender {
    [self performSegueWithIdentifier:@"showOnMap" sender:self];
}

- (IBAction)didClickInfoButton:(id)sender {
    if (!_infoPopoverController) {
        InfoPopover *infoPopover = [[InfoPopover alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        infoPopover.title.text = _originalPhoto.photo_title;
        infoPopover.owner.text = [NSString stringWithFormat:@"taken by %@", _originalPhoto.owner_name];
        infoPopover.date.text = _originalPhoto.upload_date;
        
        CGRect titleRect = [infoPopover.title.text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:17] } context:nil];
        CGRect ownerRect = [infoPopover.owner.text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:17] } context:nil];
        CGRect dateRect = [infoPopover.date.text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:17] } context:nil];
        
        CGFloat popoverWidth = MAX(MAX(titleRect.size.width, ownerRect.size.width), dateRect.size.width) + 20;
        UIViewController *popoverContent = [[UIViewController alloc] init];
        popoverContent.view = infoPopover;
        popoverContent.preferredContentSize = CGSizeMake(popoverWidth, infoPopover.bounds.size.height);
        
        _infoPopoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    }
    
    [_infoPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
}

@end
