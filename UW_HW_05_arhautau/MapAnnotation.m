//
//  MapAnnotation.m
//  UW_HW_05_arhautau
//
//  Created by Andrew Hautau on 5/29/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation {
    NSString *_title;
    CLLocationCoordinate2D _coordinate;
}

- (instancetype) initWithMapItem: (MKMapItem*) mapItem {
    self = [self init];
    
    _title = mapItem.name;
    _coordinate = mapItem.placemark.coordinate;
    return self;
}

@end
