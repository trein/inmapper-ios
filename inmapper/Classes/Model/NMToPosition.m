//
//  NMPosition.m
//  inmapper
//
//  Created by Guilherme M. Trein on 9/26/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMToPosition.h"

@implementation NMToPosition

- (id)initWithAcceleration:(CMAcceleration)acceleration heading:(double)heading {
    self = [super init];
    if (self) {
        self.x = [NSNumber numberWithDouble:acceleration.x];
        self.y = [NSNumber numberWithDouble:acceleration.y];
        self.z = [NSNumber numberWithDouble:acceleration.z];
        self.heading = [NSNumber numberWithDouble:heading];
    }
    return self;
}

@end
