//
//  MapAnnotation.h
//  UW_HW_05_arhautau
//
//  Created by Andrew Hautau on 5/29/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MapAnnotation : NSObject <MKAnnotation, NSSecureCoding>

- (instancetype) initWithMapItem: (MKMapItem*) mapItem;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property(nonatomic, readonly, copy) NSString *title;


@end
