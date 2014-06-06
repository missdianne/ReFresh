//
//  MyFridgeCDTVC.h
//  ReFresh
//
//  Created by Dianne Na on 5/25/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import <EventKit/EventKit.h>


@interface MyFridgeCDTVC : CoreDataTableViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSString *fridgeName;


@end
