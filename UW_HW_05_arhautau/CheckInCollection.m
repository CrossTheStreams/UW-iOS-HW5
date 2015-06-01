//
//  CheckInCollection.m
//  UW_HW_05_arhautau
//
//  Created by Andrew Hautau on 5/17/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "CheckInCollection.h"


@interface CheckInCollection ()

@property (strong, nonatomic) NSMutableArray *collection;

@end


@implementation CheckInCollection

+ (CheckInCollection*) createCheckInCollection {
    CheckInCollection * checkInCollection = [[CheckInCollection alloc] init];
    [checkInCollection setCollection: [[NSMutableArray alloc] init]];
    return checkInCollection;
}

#pragma mark NSSecureCoding

+ (BOOL) supportsSecureCoding {
    return YES;
}


-(void) encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject: self.collection forKey:@"collection"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        NSArray *collection = [aDecoder decodeObjectOfClass: [NSMutableArray class] forKey:@"collection"];
        NSMutableArray *mutableCollection = [NSMutableArray arrayWithArray: collection];
        
        [self setCollection: mutableCollection];
    }
    return self;
}

-(CheckIn*) checkInForRow: (NSUInteger) row {

    CheckIn *checkIn = [self.collection objectAtIndex: row];
    return checkIn;
}

-(NSInteger) count {
    return [self.collection count];
}

-(void) addCheckIn:(CheckIn*) checkIn {
    
    [self.collection addObject: checkIn];
}

-(NSInteger) rowForCheckIn: (CheckIn*) checkIn {
    return [self.collection indexOfObject: checkIn];
}

@end


