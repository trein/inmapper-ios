//
//  NMCommunicationService.h
//  inmapper
//
//  Created by Guilherme M. Trein on 10/17/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMCommunicationService : NSObject

+ (NMCommunicationService *)sharedInstance;

- (void)startCommunication;
- (void)stopCommunication;

@end
