//
//  Item+Create.h
//  ReFresh
//
//  Created by Dianne Na on 5/25/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "Item.h"

@interface Item (Create)

+ (Item *)itemWithInfo:(NSDictionary *)itemDictionary
        inManagedObjectContext:(NSManagedObjectContext *)context;

//- (BOOL)isUser;


@end
