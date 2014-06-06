//
//  IngredientCollectionViewCell.h
//  ReFresh
//
//  Created by Dianne Na on 5/30/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
@interface IngredientCollectionViewCell : UICollectionViewCell


@property (nonatomic, strong) Item *ingredient;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *name;
-(void) updateColor;
-(void) updateImagefor: (Item *)ingredient ;
@end
