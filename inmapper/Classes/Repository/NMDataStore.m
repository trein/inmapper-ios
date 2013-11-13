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
#import "NMPosition.h"
#import "Position.h"

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

- (void)save:(NMPosition *)position {
    Position *managedPosition = (Position *) [NSEntityDescription insertNewObjectForEntityForName:@"Position"
                                                                        inManagedObjectContext:self.context];
    [managedPosition setFrom:position];
    
    NSError *error;
    if (![self.context save:&error]) {
        //This is a serious error saying the record
        //could not be saved. Advise the user to
        //try again or restart the application.
    }
}

- (NSArray *)findAll {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Position" inManagedObjectContext:self.context];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // Define how we will sort the records
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
//    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//    [request setSortDescriptors:sortDescriptors];
    // Fetch the records and handle an error
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[self.context executeFetchRequest:request error:&error] mutableCopy];
    
    if (!mutableFetchResults) {
        // Handle the error.
        // This is a serious error and should advise the user to restart the application
    }
    // Save our fetched data to an array
    // Convert to NSPosition.
    return [NSArray arrayWithArray:mutableFetchResults];
}

@end
