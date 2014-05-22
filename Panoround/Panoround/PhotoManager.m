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
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:URL_TEMPLATE, lonMin, latMin, lonMax, latMax, nil]];
    NSLog(@"Getting panoramas from %@", [url absoluteString]);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [delegate getPanoramasFailedWithError:error];
        } else {
            Panoramas *panoramas = [[Panoramas alloc] initWithString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] error:&error];
            if (error) {
                [delegate getPanoramasFailedWithError:error];
            }
            [delegate receivedPanoramas:panoramas];
        }
    }];
}

@end
