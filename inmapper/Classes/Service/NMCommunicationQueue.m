//
//  NMCommunicationQueue.m
//  inmapper
//
//  Created by Guilherme M. Trein on 10/17/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMCommunicationQueue.h"
#import "NMConstants.h"

@interface NMCommunicationQueue ()

@property(nonatomic, weak) void (^block) (NSArray *events);
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) NSMutableArray *events;
@property(nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation NMCommunicationQueue

- (id)initWithBlock:(void (^)(NSArray *events))block {
    self = [super init];
    if (nil != self) {
        self.block = block;
        self.events = [NSMutableArray new];
        self.lock = [NSRecursiveLock new];
    }
    return self;
}

- (void)start {
    NSLog(@"Starting events processing");
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kCommunicationQueueInterval target:self selector:@selector(postEvents:) userInfo:nil repeats:YES];
}

- (void)stop {
    NSLog(@"Stoping events processing");
    [self.timer invalidate];
}

- (void)appendEvent:(id)position {
    if (self.timer.isValid) {
        [self.lock lock];
        [self.events addObject:position];
        [self.lock unlock];
    }
}

- (void)postEvents:(NSTimer *)timer {
    [self.lock lock];
    
    NSLog(@"Posting %d events in queue", self.events.count);
    self.block([NSArray arrayWithArray:self.events]);
    [self.events removeAllObjects];
    
    [self.lock unlock];
}

@end
