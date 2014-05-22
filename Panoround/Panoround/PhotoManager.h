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

#define URL_TEMPLATE @"http://www.panoramio.com/map/get_panoramas.php?order=popularity&set=public&from=0&to=100&minx=%f&miny=%f&maxx=%f&maxy=%f"

@protocol PhotoManagerDelegate <NSObject>

- (void)receivedPanoramas:(Panoramas *)panoramas;
- (void)getPanoramasFailedWithError:(NSError *)error;

@end

@interface PhotoManager : NSObject

+ (void)getPanoramasFromLocation:(CLLocationCoordinate2D)location distance:(NSInteger)distance delegate:(id<PhotoManagerDelegate>) delegate;

@end
