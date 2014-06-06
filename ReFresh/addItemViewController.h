//
//  addItemViewController.h
//  ReFresh
//
//  Created by Dianne Na on 5/26/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "Item+Create.h"
#import "NutritionGroup.h"


@interface addItemViewController : UIViewController <UITextFieldDelegate>

#define DONE_ADDING_PHOTO_UNWIND_SEGUE_IDENTIFER @"Done Adding Photo"

@property (nonatomic, strong) Item* addedItem;


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
