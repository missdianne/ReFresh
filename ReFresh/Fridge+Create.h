//
//  Fridge+Create.h
//  ReFresh
//
//  Created by Dianne Na on 6/5/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "Fridge.h"

@interface Fridge (Create)


+ (Fridge *)itemWithInfo:(NSString *)name
inManagedObjectContext:(NSManagedObjectContext *)context;

+(Fridge *) fridgeWithInfo: (NSDictionary *)fridgeDictionary inManagedContext: (NSManagedObjectContext *) context;


@end
