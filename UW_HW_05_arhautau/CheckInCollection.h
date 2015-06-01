//
//  CheckInCollection.h
//  UW_HW_05_arhautau
//
//  Created by Andrew Hautau on 5/17/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CheckIn.h"

@interface CheckInCollection : NSObject <NSSecureCoding>

+ (CheckInCollection*) createCheckInCollection;

- (CheckIn*) checkInForRow: (NSUInteger) row;

-(NSInteger) count;

-(NSInteger) rowForCheckIn: (CheckIn*) checkIn;

-(void) addCheckIn:(CheckIn*) checkIn;

@end
