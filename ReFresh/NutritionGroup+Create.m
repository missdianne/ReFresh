//
//  NutritionGroup+Create.m
//  ReFresh
//
//  Created by Dianne Na on 5/25/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "NutritionGroup+Create.h"

@implementation NutritionGroup (Create)



+ (NutritionGroup *)userInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [self nutritionGroupWithName:@" My Nutrition Group    "
               inManagedObjectContext:context];
}

- (BOOL)isUser
{
    return (self == [[self class] userInManagedObjectContext:self.managedObjectContext]);
}

+ (NutritionGroup *)nutritionGroupWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    NutritionGroup *group = nil;
    
    if ([name length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NutritionGroup"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (error || !matches || ([matches count] > 1)) {
            // handle error
        } else if (![matches count]) {
            group = [NSEntityDescription insertNewObjectForEntityForName:@"NutritionGroup"
                                                         inManagedObjectContext:context];
            group.name = name;
        } else {
            group = [matches lastObject];
        }
    }
    
    return group;
}

@end
