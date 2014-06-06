//
//  NutritionGroup+Create.h
//  ReFresh
//
//  Created by Dianne Na on 5/25/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "NutritionGroup.h"

@interface NutritionGroup (Create)


+ (NutritionGroup *)nutritionGroupWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NutritionGroup *)userInManagedObjectContext:(NSManagedObjectContext *)context;
@end
