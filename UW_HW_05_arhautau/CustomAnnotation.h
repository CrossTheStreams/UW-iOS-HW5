//
//  CustomAnnotation.h
//  UW_HW_05_arhautau
//
//  Created by Andrew Hautau on 5/28/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (id)initWithLocation:(CLLocationCoordinate2D)coord;

// Other methods and properties.
@end