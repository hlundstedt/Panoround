//
//  PhotoManager.h
//  Panoround
//
//  Created by Henrik Lundstedt on 5/21/14.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Panoramas.h"

#define URL_TEMPLATE_MEDIUM @"http://www.panoramio.com/map/get_panoramas.php?order=popularity&set=public&from=0&to=100&minx=%f&miny=%f&maxx=%f&maxy=%f&size=medium"
#define URL_TEMPLATE_ORIGINAL @"http://www.panoramio.com/map/get_panoramas.php?order=popularity&set=public&from=0&to=100&minx=%f&miny=%f&maxx=%f&maxy=%f&size=original"

@protocol PhotoManagerDelegate <NSObject>

- (void)receivedMediumPanoramas:(Panoramas *)mediumPanoramas originalPanoramas:(Panoramas *)originalPanoramas;
- (void)getPanoramasFailedWithError:(NSError *)error;

@end

@interface PhotoManager : NSObject

@property (nonatomic, strong) id<PhotoManagerDelegate> delegate;

- (void)getPanoramasFromLocation:(CLLocationCoordinate2D)location distance:(NSInteger)distance;

@end
