//
//  NMDataStore.h
//  inmapper
//
//  Created by Guilherme M. Trein on 11/13/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NMToPosition;

@interface NMDataStore : NSObject

- (void)save:(NMToPosition *)position withToken:(NSString *)token;
- (NSArray *)findAll:(NSString *)token;
- (void)removeAll:(NSString *)token;

@end
