//
//  NMToPosition.h
//  inmapper
//
//  Created by Guilherme M. Trein on 9/26/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface NMToPosition : NSObject

@property(nonatomic, strong) NSNumber * x;
@property(nonatomic, strong) NSNumber * y;
@property(nonatomic, strong) NSNumber * z;
@property(nonatomic, strong) NSNumber * heading;

- (id)initWithAcceleration:(CMAcceleration)acceleration heading:(double)heading;

@end
