//
//  ReFreshDatabase.m
//  ReFresh
//
//  Created by Dianne Na on 5/25/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "ReFreshDatabase.h"
#import "Item+Create.h"
#import "Fridge+Create.h"
//#import "Item+create.h"



@interface ReFreshDatabase()
@property (nonatomic, readwrite, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *fridges;
@end

@implementation ReFreshDatabase


-(NSMutableArray *)fridges
{
    if (!_fridges)
    {
        _fridges = [[NSMutableArray alloc] init];
    }
    return _fridges;
}



+ (ReFreshDatabase *)sharedDefaultReFreshDatabase
{
    return [self sharedReFreshDatabaseWithName:@"ReFreshDatabase_DEFAULT"];
}



+ (ReFreshDatabase *)sharedReFreshDatabaseWithName:(NSString *)name
{
    //NSLog(@"c");
    static NSMutableDictionary *databases = nil;
    if (!databases) databases = [[NSMutableDictionary alloc] init];
    
    ReFreshDatabase *database = nil;
    
    if ([name length]) {
        database = databases[name];
        if (!database) {
            database = [[self alloc] initWithName:name];
            databases[name] = database;
        }
    }
    
    return database;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ReFreshDatabaseAvailable
                                                        object:self];
}

- (instancetype)initWithName:(NSString *)name
{
 //   NSLog(@"d");
    self = [super init];
    if (self) {
        if ([name length]) {
            NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                 inDomains:NSUserDomainMask] firstObject];
            url = [url URLByAppendingPathComponent:name];

            UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
         //   NSLog(@"a url: %@", url);
            if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
                [document openWithCompletionHandler:^(BOOL success) {
                    if (success) self.managedObjectContext = document.managedObjectContext;
               //     NSLog(@"opened file");
                }];
            } else {
                [document saveToURL:url
                   forSaveOperation:UIDocumentSaveForCreating
                  completionHandler:^(BOOL success) {
                      if (success) {
                          self.managedObjectContext = document.managedObjectContext;
                       //   NSLog(@"z");
                          [self fetch];
                      }
                      
                  }];
            }
        } else {
            self = nil;
        }
    }
    return self;
}


- (void)fetch
{
    [self fetchWithCompletionHandler:nil];
}

//tester method
- (void)fetchWithCompletionHandler:(void (^)(BOOL success))completionHandler
{
    if (self.managedObjectContext) {
            dispatch_queue_t fetchQueue = dispatch_queue_create("ReFreshDatabase fetch", NULL);
            dispatch_async(fetchQueue, ^{
                BOOL failure = YES;
            //    NSLog(@"e");
                NSArray *items = [self test];
                NSArray *fridges = [self addFridgesWithLocation];
                if (items)
                {
                    failure = NO;
                    [self.managedObjectContext performBlock: ^{
                        for (NSDictionary *itemDictionary in items)
                        {
                            [Item itemWithInfo:itemDictionary inManagedObjectContext:self.managedObjectContext];
                        }
                        
                        for (NSDictionary *fridge in fridges)
                        {
                            [Fridge fridgeWithInfo:fridge inManagedContext:self.managedObjectContext];
                        }
                        
                        
                        if (completionHandler) dispatch_async(dispatch_get_main_queue(), ^{
                            completionHandler(YES);
                        });
                    }];
                }
                if (failure && completionHandler) dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(NO);
                    
            });
        });
                          
    } else {
        if (completionHandler) dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(NO);
        });
    }
}

                           
-(NSArray *) test
{
    NSMutableArray *testArray = [[NSMutableArray alloc]init];
    
   // NSDate *today = [[NSDate alloc]init];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSNumber *n = [NSNumber numberWithDouble:now];
       
    NSDictionary *carrot = @{@"name": @"carrots", @"servingSize": @1, @"servingType": @"oz", @"dateOpen": n, @"NutritionGroup": @"veggie", @"nearExpire": @0, @"includedIn": @"dianne"};
    NSDictionary *peaches = @{@"name": @"peaches", @"servingSize": @1, @"servingType": @"gallon", @"dateOpen": n, @"NutritionGroup": @"fruit", @"nearExpire": @0, @"includedIn": @"dianne"};
    NSDictionary *swiss = @{@"name": @"swiss", @"servingSize": @1, @"servingType": @"oz", @"dateOpen": n, @"NutritionGroup":@"dairy", @"nearExpire": @0, @"includedIn": @"dianne"};
    NSDictionary *kale = @{@"name": @"kale", @"servingSize": @1, @"servingType": @"lb", @"dateOpen": n, @"NutritionGroup": @"veggie", @"nearExpire": @0, @"includedIn": @"dianne"};
    NSDictionary *salmon = @{@"name": @"salmon", @"servingSize": @.5, @"servingType": @"lb", @"dateOpen": n, @"NutritionGroup": @"protein", @"nearExpire": @0, @"includedIn": @"dianne"};
    NSDictionary *peas = @{@"name": @"peas", @"servingSize": @6, @"servingType": @"oz", @"dateOpen": n, @"NutritionGroup": @"veggie", @"nearExpire": @0, @"includedIn": @"dianne"};
     NSDictionary *basil = @{@"name": @"basil", @"servingSize": @4, @"servingType": @"oz", @"dateOpen": n, @"NutritionGroup": @"veggie", @"nearExpire": @0, @"includedIn": @"dianne"};
    NSDictionary *tomatoes = @{@"name": @"tomatoes", @"servingSize": @3, @"servingType": @"lb", @"dateOpen": n, @"NutritionGroup": @"veggie", @"nearExpire": @0, @"includedIn": @"dianne"};
    NSDictionary *broccoli = @{@"name": @"broccoli", @"servingSize": @1, @"servingType": @"lb", @"dateOpen": n, @"NutritionGroup": @"veggie", @"nearExpire": @0, @"includedIn": @"dianne"};
     NSDictionary *chicken = @{@"name": @"chicken", @"servingSize": @.3, @"servingType": @"lb", @"dateOpen": n, @"NutritionGroup": @"protein", @"nearExpire": @0, @"includedIn": @"dianne"};
      NSDictionary *milk = @{@"name": @"milk", @"servingSize": @2, @"servingType": @"gallon", @"dateOpen": n, @"NutritionGroup": @"dairy", @"nearExpire": @0, @"includedIn": @"dianne"};
    
    
    
     NSDictionary *cherries = @{@"name": @"cherries", @"servingSize": @1.5, @"servingType": @"lb", @"dateOpen": n, @"NutritionGroup": @"fruit", @"nearExpire": @0, @"includedIn": @"taylor"};
        NSDictionary *watermelon = @{@"name": @"watermelon", @"servingSize": @5, @"servingType": @"lb", @"dateOpen": n, @"NutritionGroup": @"fruit", @"nearExpire": @0, @"includedIn": @"taylor"};
    
    
    [testArray addObject:carrot];
    [testArray addObject:swiss];
    [testArray addObject:kale];
    [testArray addObject:salmon];
    [testArray addObject:peaches];
    [testArray addObject: peas];
    [testArray addObject:basil];
    [testArray addObject: tomatoes];
    [testArray addObject:broccoli];
    [testArray addObject:chicken];
    [testArray addObject:milk];
    [testArray addObject:cherries];
    [testArray addObject:watermelon];
   // NSLog (@"test array: %@", testArray);
    return testArray;
}

-(NSArray *)addFridgesWithLocation
{
    NSMutableArray *testFridge = [[NSMutableArray alloc]init];
   
    NSDictionary *dianne = @{@"name": @"dianne", @"latitude": @37.4260719, @"longitude": @-122.1522775};
    NSDictionary *taylor =  @{@"name": @"taylor", @"latitude": @37.4224761, @"longitude": @-122.1463721};
    
    [testFridge addObject:dianne];
    [testFridge addObject:taylor];
    return testFridge;
    
    
}



/*
- (void)fetchWithCompletionHandler:(void (^)(BOOL success))completionHandler
{
    if (self.managedObjectContext) {
        dispatch_queue_t fetchQueue = dispatch_queue_create("ReFreshDatabase fetch", NULL);
        dispatch_async(fetchQueue, ^{
            BOOL failure = YES;
            NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
            if (url) {
                UIApplication *application = [UIApplication sharedApplication];
                application.networkActivityIndicatorVisible = YES;
                NSData *jsonResults = [NSData dataWithContentsOfURL:url];
                application.networkActivityIndicatorVisible = NO;
                if (jsonResults) {
                    NSError *error;
                    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                                        options:0
                                                                                          error:&error];
                    if (!error) {
                        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
                        if (photos) {
                            failure = NO;
                            [self.managedObjectContext performBlock:^{
                                // load up the Core Data database
                                for (NSDictionary *photoDictionary in photos) {
                                    [Photo photoWithFlickrInfo:photoDictionary
                                        inManagedObjectContext:self.managedObjectContext];
                                }
                                if (completionHandler) dispatch_async(dispatch_get_main_queue(), ^{
                                    completionHandler(YES);
                                });
                            }];
                        }
                    }
                }
            }
            if (failure && completionHandler) dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(NO);
            });
        });
    } else {
        if (completionHandler) dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(NO);
        });
    }
}
 */
 



@end
