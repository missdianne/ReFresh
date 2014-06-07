//
//  Fridge+Create.m
//  ReFresh
//
//  Created by Dianne Na on 6/5/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "Fridge+Create.h"

@implementation Fridge (Create)

+ (Fridge *)itemWithInfo:(NSString *)name
  inManagedObjectContext:(NSManagedObjectContext *)context
{
    Fridge *fridge = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Fridge"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error || !matches || ([matches count] > 1)) {
        // handle error
    } else if (![matches count]) {
        fridge = [NSEntityDescription insertNewObjectForEntityForName:@"Fridge"
                                             inManagedObjectContext:context];
        fridge.name = name;
    
    }
        else {
            fridge = [matches firstObject];
        }
        return fridge;
}



+(Fridge *) fridgeWithInfo: (NSDictionary *)fridgeDictionary inManagedContext: (NSManagedObjectContext *) context
{
    NSString *name = [fridgeDictionary valueForKeyPath:@"name"];
    Fridge *fridge = [self itemWithInfo:name inManagedObjectContext:context];
    fridge.latitude = [fridgeDictionary valueForKeyPath:@"latitude"];
    fridge.longitude = [fridgeDictionary valueForKeyPath:@"longitude"];
   
    
    
    return fridge;
    
}


@end
