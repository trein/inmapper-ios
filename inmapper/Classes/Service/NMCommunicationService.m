//
//  NMCommunicationService.m
//  inmapper
//
//  Created by Guilherme M. Trein on 10/17/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMCommunicationService.h"
#import "NMConstants.h"
#import "NMMobilePositions.h"
#import "NMCommunicationQueue.h"
#import "NMLocationService.h"
#import "NMRequestDispatcher.h"

@interface NMCommunicationService ()
@property(nonatomic, weak) NSString *UUID;
@property(nonatomic, weak) NSString *roomID;
@property(nonatomic, strong) NMLocationService *locator;
@property(nonatomic, strong) NMCommunicationQueue *queue;
@property(nonatomic, strong) NMRequestDispatcher *dispatcher;
@end

@implementation NMCommunicationService

+ (NMCommunicationService *)sharedInstance {
    static NMCommunicationService *sharedInstance;
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [NMCommunicationService new];
        }
    }
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.locator = [NMLocationService sharedInstance];
        self.queue = [[NMCommunicationQueue alloc] initWithBlock:[self createProcessingBlock]];
        self.dispatcher = [NMRequestDispatcher new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEvent:) name:kNMSensorUpdate object:nil];
    }
    return self;
}
                      
- (void (^)(NSArray *events))createProcessingBlock {
    return ^ void (NSArray *events) {
        NSLog(@"Calling dispatcher to process batch request");
        
        [self.dispatcher dispatchBatch:[self newPositions:events]];
    };
}

- (NMMobilePositions *)newPositions:(NSArray *)positions {
    return [[NMMobilePositions alloc] initWithUUID:self.UUID roomID:self.roomID postision:positions];
}

- (void)receiveEvent:(NSNotification *)notification {
    NSLog(@"Received event on communication service %@", notification);
    NMPosition *position = notification.object;
    
    [self.queue appendEvent:position];
}

- (void)startCommunication {
    self.UUID = [self.dispatcher requestUUID];
    self.roomID = @"";
    [self.queue start];
}

- (void)stopCommunication {
    [self.queue stop];
}

@end
