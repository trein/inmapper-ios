//
//  NMCommunicationQueue.h
//  inmapper
//
//  Created by Guilherme M. Trein on 10/17/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMToPosition.h"

@interface NMCommunicationQueue : NSObject

- (id)initWithBlock:(void (^)(NSArray *events))block;

- (void)start;

- (void)stop;

- (void)appendEvent:(id)event;

@end
