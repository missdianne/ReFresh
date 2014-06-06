//
//  ReFreshDatabase.h
//  ReFresh
//
//  Created by Dianne Na on 5/25/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ReFreshDatabaseAvailable @"ReFreshDatabaseAvailable"


@interface ReFreshDatabase : NSObject


+(ReFreshDatabase *)sharedDefaultReFreshDatabase;
+(ReFreshDatabase *)sharedReFreshDatabaseWithName:(NSString *)name;


@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

- (void)fetch;
- (void)fetchWithCompletionHandler:(void (^)(BOOL success))completionHandler;



@end
