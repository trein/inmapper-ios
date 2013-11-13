//
//  NMDataStore.h
//  inmapper
//
//  Created by Guilherme M. Trein on 11/13/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NMPosition;

@interface NMDataStore : NSObject

- (void)save:(NMPosition *)position;
- (NSArray *)findAll;

@end
