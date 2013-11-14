//
//  NMDataStore.m
//  inmapper
//
//  Created by Guilherme M. Trein on 11/13/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMDataStore.h"
#import <CoreData/CoreData.h>
#import "NMAppDelegate.h"
#import "NMToPosition.h"
#import "NMPosition.h"

@interface NMDataStore ()
@property(nonatomic, weak) NSManagedObjectContext *context;
@end

@implementation NMDataStore

- (id)init {
    self = [super init];
    if (self) {
        self.context = [NMAppDelegate sharedManagedContext];
    }
    return self;
}

- (void)save:(NMToPosition *)position withToken:(NSString *)token {
    NMPosition *managedPosition = (NMPosition *) [NSEntityDescription insertNewObjectForEntityForName:@"Position"
                                                                               inManagedObjectContext:self.context];
    NSError *error;
    [managedPosition setFrom:position withToken:token];
    
    NSLog(@"Persisting position %@.", position);
    if (![self.context save:&error]) {
        NSLog(@"Error persisting position %@ : %@.", position, error.description);
    }
}

- (NSArray *)findAll:(NSString *)token {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Position" inManagedObjectContext:self.context];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // Define how we will sort the records
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    
    // Define predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"token = %@", token];
    [request setPredicate:predicate];
    
    // Fetch the records and handle an error
    NSError *error;
    NSLog(@"Fetching positions for token %@.", token);
    NSMutableArray *mutableFetchResults = [[self.context executeFetchRequest:request error:&error] mutableCopy];
    
    if (!mutableFetchResults) {
        NSLog(@"Error fetching positions of token %@ : %@.", token, error.description);
    }
    NSLog(@"Found positions %@.", mutableFetchResults);
    return [NSArray arrayWithArray:mutableFetchResults];
}

- (void)removeAll:(NSString *)token {
    
}

@end
