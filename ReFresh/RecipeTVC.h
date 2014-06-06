//
//  RecipeTVC.h
//  ReFresh
//
//  Created by Dianne Na on 5/29/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YummlyFetcher.h"
@interface RecipeTVC : UITableViewController
@property (nonatomic, strong) NSArray *resultRecipes;
@property (nonatomic, strong) NSArray *includedIngredients;
//-(NSMutableArray *) allRecipes: (NSArray *) recipesPL;
@end
