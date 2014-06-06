//
//  IngredientCollectionViewCell.m
//  ReFresh
//
//  Created by Dianne Na on 5/30/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "IngredientCollectionViewCell.h"




@implementation IngredientCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      //  self.backgroundColor = [UIColor grayColor];
     /*   UIView *bgView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        bgView.backgroundColor = [UIColor blueColor];
        bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
        bgView.layer.borderWidth = 4;
        self.selectedBackgroundView = bgView;
      */
        self.backgroundView.layer.cornerRadius = 5;
        self.backgroundView.layer.masksToBounds = YES;
    }
    return self;
}



-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    /*
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        bgView.backgroundColor = [UIColor blueColor];
        bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
        bgView.layer.borderWidth = 4;
        self.selectedBackgroundView = bgView;
    }
     */
    return self;
}

-(Item *)ingredient {
    if (!_ingredient)
    {
        _ingredient = [[Item alloc]init];
    }
    return _ingredient;
}

-(UIImageView *) imageView{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

-(UILabel *) name
{
    if(!_name)
    {
        _name = [[UILabel alloc]init];
    }
    return _name;
}

-(void) updateColor
{
    if (self.ingredient)
    {
        NSString *ng = self.ingredient.myNG;
        if ([ng isEqualToString:@"fruit"])
        {
            self.backgroundColor = [UIColor orangeColor];
        }
        else if([ng isEqualToString:@"dairy"])
        {
            self.backgroundColor = [UIColor redColor];
        }
        else if([ng isEqualToString:@"veggie"])
        {
            self.backgroundColor = [UIColor greenColor];
        }
        else if([ng isEqualToString:@"protein"])
        {
            self.backgroundColor = [UIColor blueColor];
        }
    }
}

-(void) updateImagefor:(Item *)ingredient
{
    if (self.ingredient)
    {
   //     NSString *ng = self.ingredient.myNG;
        if (!self.ingredient.photo){
        NSString *pngString = [NSString stringWithFormat:@"%@.png", self.ingredient.name];
      //  NSLog (@"png string is %@", pngString);
        self.imageView.image = [UIImage imageNamed:pngString];
        self.name.text = self.ingredient.name;
            //NSLog(@"image is %@", self.imageView.image);
        }
        else {
            self.imageView.image = [UIImage imageWithData:ingredient.photo];
            self.name.text = self.ingredient.name;
        }
      
    }
}



@end
