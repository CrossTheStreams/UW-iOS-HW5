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

+ (instancetype) createCheckIn {
    CheckIn *checkIn = [[CheckIn alloc] init];
    checkIn.photos = [[NSMutableArray alloc] init];
    return checkIn;
}

+ (BOOL) supportsSecureCoding {
    return YES;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject: self.photos forKey:@"photoCollection"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    
    if (self) {
        NSMutableArray *photos = [aDecoder decodeObjectOfClass: [NSMutableArray class] forKey:@"photoCollection"];
        
        [self setPhotos: photos];
    }
    return self;
}

@end
