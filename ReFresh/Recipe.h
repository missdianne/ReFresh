//
//  Recipe.h
//  ReFresh
//
//  Created by Dianne Na on 6/6/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * ingredient;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSData * thumbNail;

@end
