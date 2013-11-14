//
//  Position.m
//  inmapper
//
//  Created by Guilherme M. Trein on 11/13/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMPosition.h"
#import "NMToPosition.h"


@implementation NMPosition

@dynamic token;
@dynamic x;
@dynamic y;
@dynamic z;
@dynamic heading;
@dynamic createdAt;

- (void)setFrom:(NMToPosition *)position withToken:(NSString *)token {
    self.token = token;
    self.x = position.x;
    self.y = position.y;
    self.z = position.z;
    self.heading = position.heading;
}

- (void)awakeFromInsert {
    [super awakeFromInsert];
    self.createdAt = [NSDate date];
}

- (NSDictionary *)jsonValue {
    return @{@"x" : [self.x stringValue],
             @"y" : [self.y stringValue],
             @"z" : [self.z stringValue],
             @"heading" : [self.heading stringValue]};
}

- (NSString *)description {
    return [[self jsonValue] description];
}

@end
