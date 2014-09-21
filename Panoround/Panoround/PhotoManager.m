//
//  PhotoManager.m
//  Panoround
//
//  Created by Henrik Lundstedt on 5/21/14.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import "PhotoManager.h"
#import "Panoramas.h"

@implementation PhotoManager

+ (void)getPanoramasFromLocation:(CLLocationCoordinate2D)location distance:(NSInteger)distance delegate:(id<PhotoManagerDelegate>) delegate;
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, distance, distance);
    double latMin = region.center.latitude - .5 * region.span.latitudeDelta;
    double latMax = region.center.latitude + .5 * region.span.latitudeDelta;
    double lonMin = region.center.longitude - .5 * region.span.longitudeDelta;
    double lonMax = region.center.longitude + .5 * region.span.longitudeDelta;
    
    NSURL *mediumPanormasUrl = [[NSURL alloc] initWithString:[NSString stringWithFormat:URL_TEMPLATE_MEDIUM, lonMin, latMin, lonMax, latMax, nil]];
    NSURL *originalPanormasUrl = [[NSURL alloc] initWithString:[NSString stringWithFormat:URL_TEMPLATE_ORIGINAL, lonMin, latMin, lonMax, latMax, nil]];
    
    __block Panoramas *mediumPanoramas = nil;
    __block Panoramas *originalPanoramas = nil;
    
    NSLog(@"Getting medium panoramas from %@", [mediumPanormasUrl absoluteString]);
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:mediumPanormasUrl] queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
       if (error) {
           [delegate getPanoramasFailedWithError:error];
       } else {
           mediumPanoramas = [[Panoramas alloc] initWithString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] error:&error];
           if (error) {
               [delegate getPanoramasFailedWithError:error];
           } else {
               NSLog(@"Getting original panoramas from %@", [originalPanormasUrl absoluteString]);
               [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:originalPanormasUrl] queue:[[NSOperationQueue alloc] init]completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                   if (error) {
                       [delegate getPanoramasFailedWithError:error];
                   } else {
                       originalPanoramas = [[Panoramas alloc] initWithString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] error:&error];
                       if (error) {
                           [delegate getPanoramasFailedWithError:error];
                       } else {
                           [delegate receivedMediumPanoramas:mediumPanoramas originalPanoramas:originalPanoramas];
                       }
                   }
                }];
           }
       }
    }];
}

@end
