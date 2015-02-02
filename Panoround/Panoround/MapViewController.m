//
//  MapViewController.m
//  Panoround
//
//  Created by Henrik Lundstedt on 2015-02-02.
//  Copyright (c) 2015 Macadamian. All rights reserved.
//

#import "MapViewController.h"
#import "GalleryViewController.h"

@interface MapViewController ()

@property (nonatomic, weak) IBOutlet GMSMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:[GalleryViewController getLastLocation].coordinate];
    [path addCoordinate:_photoLocation];
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
    GMSCameraPosition *camera = [_mapView cameraForBounds:bounds insets:UIEdgeInsetsMake(200, 200, 200, 200)];
    
    _mapView.camera = camera;
    _mapView.mapType = kGMSTypeSatellite;
    _mapView.myLocationEnabled = YES;
    _mapView.settings.zoomGestures = YES;
    _mapView.settings.myLocationButton = YES;
    self.view = _mapView;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(_photoLocation.latitude, _photoLocation.longitude);
    marker.map = _mapView;
}

@end
