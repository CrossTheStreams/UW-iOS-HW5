//
//  CheckIn.h
//  UW_HW_05_arhautau
//
//  Created by Andrew Hautau on 5/17/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapAnnotation.h"

@interface CheckIn : NSObject <NSSecureCoding>

@property (strong, nonatomic) NSMutableArray *photos;

@property (strong, nonatomic) NSString *name;

// TODO: add property to reference coordinates of added check-ins later

+ (instancetype) createCheckInWithMapAnnotation: (MapAnnotation*) mapAnnotation ;


@end
