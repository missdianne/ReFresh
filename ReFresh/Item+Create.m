//
//  Item+Create.m
//  ReFresh
//
//  Created by Dianne Na on 5/25/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "Item+Create.h"
#import "NutritionGroup+Create.h"
#import "Fridge+Create.h"

@implementation Item (Create)

+ (Item *)itemWithInfo:(NSDictionary *)itemDictionary
inManagedObjectContext:(NSManagedObjectContext *)context
{
    Item *item = nil;
    
    NSString *unique = [itemDictionary valueForKeyPath:@"name"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error || !matches || ([matches count] > 1)) {
        // handle error
    } else if (![matches count]) {
        item = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                              inManagedObjectContext:context];
      //  photo.unique = unique;
        item.name = [itemDictionary valueForKeyPath:@"name"];
        item.servingSize = [itemDictionary valueForKeyPath: @"servingSize"];
        item.servingType = [itemDictionary valueForKeyPath:@"servingType"];
        
        item.dateOpen = [itemDictionary valueForKeyPath:@"dateOpen"];
        
        //add time
        
        NSString *nutriGroupName = [itemDictionary valueForKeyPath:@"NutritionGroup"];        
        item.belongTo = [NutritionGroup nutritionGroupWithName: nutriGroupName inManagedObjectContext: context];
        item.myNG = nutriGroupName;
        
        
        NSString *fridge = [itemDictionary valueForKey:@"includedIn"];
        item.includedIn = [Fridge itemWithInfo:fridge inManagedObjectContext:context];
    
        
        //set expiration based on type of food
        
        if ([item.belongTo.name  isEqual: @"fruit"])
        {
            NSNumber *addFreshTime = @(60*60*24*7);
            item.dateExpire = @([item.dateOpen intValue]+ [addFreshTime intValue]);
           // item.active = 0; //true

        }
        else if ([item.belongTo.name isEqual: @"protein"])
        {
            NSNumber *addFreshTime = @(60*60*24*2);
            item.dateExpire = @([item.dateOpen intValue]+ [addFreshTime intValue]);
            //item.active = 0; //true

        }
        else if ([item.belongTo.name isEqual: @"veggie"])
        {
            NSNumber *addFreshTime = @(60*60*24*10);
            item.dateExpire = @([item.dateOpen intValue]+ [addFreshTime intValue]);
        //    item.active = 0; //true
        } else if ([item.belongTo.name isEqual: @"dairy"])
        {
            NSNumber *addFreshTime = @(60*60*24*7);
            item.dateExpire = @([item.dateOpen intValue]+ [addFreshTime intValue]);
         
         //   item.active = 0; //true
        }

        
        } else {
        item = [matches firstObject];
    }
    NSLog(@"added item: %@", item.name);
    return item;

}



@end
