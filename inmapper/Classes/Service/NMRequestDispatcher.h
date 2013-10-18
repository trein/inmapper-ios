//
//  NMRequestDispatcher.h
//  inmapper
//
//  Created by Guilherme M. Trein on 9/26/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMSession.h"

@interface NMRequestDispatcher : NSObject

- (void)requestUUID:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))callback;

- (void)dispatchBatch:(NSDictionary *)sessionChunk;

@end
