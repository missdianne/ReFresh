//
//  YummlyFetcher.m
//  ReFresh
//
//  Created by Dianne Na on 5/29/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "YummlyFetcher.h"

#define API_ID @"f07720c0"
#define API_KEY @"de9f4695af39dbd11289180b33e149dc"

@implementation YummlyFetcher




+ (NSURL *)URLforRecipes:(NSArray *)ingredients maxResults:(int)maxResults
{
    NSString *ingreString = [ingredients componentsJoinedByString:@"&allowedIngredient[]="];
 //   NSLog(@"ingredients searched %@", ingreString);
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://api.yummly.com/v1/api/recipes?_app_id=%@&_app_key=%@&maxResult=%i&allowedIngredient[]=%@&requirePictures=true", API_ID, API_KEY, maxResults, ingreString]];
}

+ (NSURL *)URLofRecipe: (NSDictionary *)recipe
{
    NSString *recipeID = [recipe valueForKey:RECIPE_ID];
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://www.yummly.com/recipe/%@", recipeID]];
}




@end
