//
//  NMPosition.h
//  inmapper
//
//  Created by Guilherme M. Trein on 9/26/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface NMPosition : NSObject

@property(nonatomic) double x;
@property(nonatomic) double y;
@property(nonatomic) double z;
@property(nonatomic) double heading;

- (id)initWithAcceleration:(CMAcceleration)acceleration heading:(double)heading;

- (NSDictionary *)jsonValue;

@end
