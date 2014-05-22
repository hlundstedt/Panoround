//
//  Panoramas.h
//  Panoround
//
//  Created by Henrik Lundstedt on 5/21/14.
//  Copyright (c) 2014 Macadamian. All rights reserved.
//

#import "JSONModel.h"
#import "Photo.h"

@interface Panoramas : JSONModel

@property (nonatomic) int count;
@property (nonatomic) BOOL has_more;
@property (nonatomic, strong) NSArray<Photo> *photos;

@end
