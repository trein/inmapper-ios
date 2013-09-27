//
//  NMPosition.m
//  inmapper
//
//  Created by Guilherme M. Trein on 9/26/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMPosition.h"

@implementation NMPosition

- (id)initWithAcceleration:(CMAcceleration)acceleration heading:(double)heading {
    self = [super init];
    if (self) {
        self.x = acceleration.x;
        self.y = acceleration.y;
        self.z = acceleration.z;
        self.heading = heading;
    }
    return self;
}

- (NSDictionary *)jsonValue {
    return @{ @"x" :  [[NSNumber numberWithDouble:self.x] stringValue],
              @"y" :  [[NSNumber numberWithDouble:self.y] stringValue],
              @"z" :  [[NSNumber numberWithDouble:self.z] stringValue],
              @"heading" :  [[NSNumber numberWithDouble:self.heading] stringValue]};
}

@end
