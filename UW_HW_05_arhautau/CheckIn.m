//
//  CheckIn.m
//  UW_HW_05_arhautau
//
//  Created by Andrew Hautau on 5/17/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "CheckIn.h"

@interface CheckIn ()


@end

@implementation CheckIn

+ (instancetype) createCheckInWithMapAnnotation: (MapAnnotation*) mapAnnotation {
    CheckIn *checkIn = [[CheckIn alloc] init];
    [checkIn setPhotos: [[NSMutableArray alloc] init]];
    [checkIn setName: mapAnnotation.title];
    return checkIn;
}

+ (BOOL) supportsSecureCoding {
    return YES;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject: self.photos forKey:@"photoCollection"];
    [aCoder encodeObject: self.name forKey:@"name"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    
    if (self) {
        NSArray *photos = [aDecoder decodeObjectOfClass: [NSMutableArray class] forKey:@"photoCollection"];
        NSMutableArray *mutablePhotos = [NSMutableArray arrayWithArray: photos];
        
        NSString *name = [aDecoder decodeObjectOfClass: [NSString class] forKey:@"name"];
        [self setPhotos: mutablePhotos];
        [self setName: name];
    }
    return self;
}

@end
