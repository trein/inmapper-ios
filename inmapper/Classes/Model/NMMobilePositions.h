//
//  NMMobilePositions.h
//  inmapper
//
//  Created by Guilherme M. Trein on 10/18/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMMobilePositions : NSObject

@property(nonatomic, strong) NSString *UUID;
@property(nonatomic, strong) NSString *roomID;
@property(nonatomic, strong) NSArray *positions;

- (id)initWithUUID:(NSString *)UUID roomID:(NSString *)roomID postision:(NSArray *)positions;

- (NSDictionary *)jsonValue;

@end
