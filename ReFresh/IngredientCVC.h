//
//  IngredientCVC.h
//  ReFresh
//
//  Created by Dianne Na on 5/30/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IngredientCollectionViewCell.h"
#import "Item.h"


@interface IngredientCVC : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
