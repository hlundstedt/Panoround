//
//  MapViewController.h
//  Panoround
//
//  Created by Henrik Lundstedt on 2015-02-02.
//  Copyright (c) 2015 Macadamian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController : UIViewController

@property CLLocationCoordinate2D currentPosition;
@property CLLocationCoordinate2D photoLocation;

@end
