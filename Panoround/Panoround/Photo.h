//
//  Photo.h
//  Panoround
//
//  Created by Henrik Lundstedt on 5/21/14.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol Photo @end
@interface Photo : JSONModel

@property (nonatomic) int height;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) int owner_id;
@property (nonatomic, strong) NSString* owner_name;
@property (nonatomic, strong) NSString* owner_url;
@property (nonatomic, strong) NSString* photo_file_url;
@property (nonatomic) int photo_id;
@property (nonatomic, strong) NSString* photo_title;
@property (nonatomic, strong) NSString* photo_url;
@property (nonatomic, strong) NSString* upload_date;
@property (nonatomic) int width;

@end
