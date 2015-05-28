//
//  CustomAnnotation.m
//  UW_HW_05_arhautau
//
//  Created by Andrew Hautau on 5/28/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "CustomAnnotation.h"


@implementation CustomAnnotation

@synthesize coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}
@end
