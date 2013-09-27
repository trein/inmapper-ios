//
//  NMLocationService.h
//  inmapper
//
//  Created by Guilherme M. Trein on 9/27/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@class NMPosition;
@protocol NMLocationServiceDelegate;
@interface NMLocationService : NSObject<CLLocationManagerDelegate>

@property(nonatomic) id <NMLocationServiceDelegate> delegate;

- (void)sendData;
- (NMPosition *)lastAvailablePosition;

@end


@class NMLocationService;
@protocol NMLocationServiceDelegate <NSObject>

- (void)service:(NMLocationService *)service didUpdatePosition:(NMPosition *)position;

@end

