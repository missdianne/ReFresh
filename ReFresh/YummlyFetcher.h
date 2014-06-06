//
//  YummlyFetcher.h
//  ReFresh
//
//  Created by Dianne Na on 5/29/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>
// key paths to photos or places at top-level of Flickr results
#define RECIPE_RATING @"rating"
#define RECIPE_NAME @"recipeName"
#define RECIPE_THUMBNAIL_IMAGE @"smallImageUrls"
#define RECIPE_ID @"id"







@interface YummlyFetcher : NSObject

+ (NSURL *)URLforRecipes:(NSArray *)ingredients maxResults:(int)maxResults;
+ (NSURL *)URLofRecipe: (NSDictionary *)recipe;
//+ (NSString *) nameOfRecipe: (NSDictionary *) recipe;
//+(NSString *) ratingOfRecipe: (NSDictionary *) recipe;
//+ (NSData *) imageOfRecipe: (NSDictionary *) recipe;
//+(NSString *) idOfRecipe: (NSDictionary *) recipe;
@end
