//
//  Position.m
//  inmapper
//
//  Created by Guilherme M. Trein on 11/13/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "Position.h"
#import "NMPosition.h"


@implementation Position

@dynamic x;
@dynamic y;
@dynamic z;
@dynamic heading;

- (void)setFrom:(NMPosition *)position {
    self.x = position.x;
    self.y = position.y;
    self.z = position.z;
    self.heading = position.heading;
}

@end
