//
//  NMSession.m
//  inmapper
//
//  Created by Guilherme M. Trein on 10/18/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMSession.h"
#import "NMPosition.h"

@implementation NMSession

- (id)initWithToken:(NSString *)token roomId:(NSString *)roomId userHeight:(NSString *)userHeight {
    self = [super init];
    if (self) {
        self.token = token;
        self.roomId = roomId;
        self.userHeight = userHeight;
    }
    return self;
}

- (NSDictionary *)jsonValue:(NSArray *)positions {
    return @{@"token" : self.token,
            @"roomId" : self.roomId,
            @"userHeight" : self.userHeight,
            @"positions" : [self extractJsonFromPositions:positions]};
}

- (NSArray *)extractJsonFromPositions:(NSArray *)positions {
    NSMutableArray *json = [NSMutableArray new];

    for (NSNumber *index in positions) {
        NMPosition *position = [positions objectAtIndex:[index integerValue]];

        [json addObject:[position jsonValue]];
    }
    return json;
}

@end
