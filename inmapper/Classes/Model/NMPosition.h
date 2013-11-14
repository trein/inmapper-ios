//
//  NMPosition.h
//  inmapper
//
//  Created by Guilherme M. Trein on 11/13/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NMToPosition;
@interface NMPosition : NSManagedObject

@property(nonatomic, strong) NSString *token;
@property(nonatomic, strong) NSNumber *x;
@property(nonatomic, strong) NSNumber *y;
@property(nonatomic, strong) NSNumber *z;
@property(nonatomic, strong) NSNumber *heading;
@property(nonatomic, strong) NSDate *createdAt;

- (void)setFrom:(NMToPosition *)position withToken:(NSString *)token;
- (NSDictionary *)jsonValue;

@end
