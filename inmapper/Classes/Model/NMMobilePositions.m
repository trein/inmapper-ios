//
//  NMMobilePositions.m
//  inmapper
//
//  Created by Guilherme M. Trein on 10/18/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMMobilePositions.h"

@implementation NMMobilePositions

- (id)initWithUUID:(NSString *)UUID roomID:(NSString *)roomID postision:(NSArray *)positions {
    self = [super init];
    if (self) {
        self.UUID = UUID;
        self.roomID = roomID;
        self.positions = positions;
    }
    return self;
}

- (NSDictionary *)jsonValue {
    return nil;
}

@end
