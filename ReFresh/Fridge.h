//
//  Fridge.h
//  ReFresh
//
//  Created by Dianne Na on 6/6/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Fridge : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSSet *has;
@end

@interface Fridge (CoreDataGeneratedAccessors)

- (void)addHasObject:(Item *)value;
- (void)removeHasObject:(Item *)value;
- (void)addHas:(NSSet *)values;
- (void)removeHas:(NSSet *)values;

@end
