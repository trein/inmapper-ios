//
//  NMRequestDispatcher.h
//  inmapper
//
//  Created by Guilherme M. Trein on 9/26/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMMobilePositions.h"

@interface NMRequestDispatcher : NSObject

- (NSString *)requestUUID;
- (void)dispatchBatch:(NMMobilePositions *)positions;

@end
