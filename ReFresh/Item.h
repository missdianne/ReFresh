//
//  Item.h
//  ReFresh
//
//  Created by Dianne Na on 6/5/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Fridge, NutritionGroup;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * nearExpire;
@property (nonatomic, retain) NSNumber * dateExpire;
@property (nonatomic, retain) NSNumber * dateOpen;
@property (nonatomic, retain) NSString * myNG;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSNumber * servingSize;
@property (nonatomic, retain) NSString * servingType;
@property (nonatomic, retain) NutritionGroup *belongTo;
@property (nonatomic, retain) Fridge *includedIn;

@end
