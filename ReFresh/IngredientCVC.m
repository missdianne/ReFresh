//
//  IngredientCVC.m
//  ReFresh
//
//  Created by Dianne Na on 5/30/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "IngredientCVC.h"
#import "Item.h"
#import "ReFreshDatabase.h"
#import "RecipeTVC.h"

@interface IngredientCVC ()
@property (strong, nonatomic) NSMutableArray *fridge;
@property (strong, nonatomic) NSMutableArray *selectedIngredients;
@property (nonatomic) Boolean shareEnabled;
@end

@implementation IngredientCVC

@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
    }
    return self;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
   // sleep(10);
  //  [self fetchFridge];
}


-(NSMutableArray *) fridge {
    if(!_fridge) {
        _fridge = [[NSMutableArray alloc] init];
    }
    return _fridge;
}

-(NSMutableArray *) selectedIngredients
{
    if (!_selectedIngredients)
    {
        _selectedIngredients = [[NSMutableArray alloc]init];
    }
    return _selectedIngredients;
}

// OPTIONAL: Number of sections
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSLog(@"set num of sections");
    return 1; //default
}

// REQUIRED: Number of items in section. (Number of thumbnails)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSLog(@"set num of items in section %i", [self.fridge count]);
    return [self.fridge count];
    
}

// REQUIRED: Set up each cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Cells that goes off screen are enqueued into a reuse pool
    // The method below looks for reuseable cell
    
   // NSLog(@"z");
    IngredientCollectionViewCell *myCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"IngredientCell" forIndexPath:indexPath];
    
    //    myCell = [[IngredientCollectionViewCell alloc] init];
    // IndexPath specifies the section and row of a cell. Here, row is equivalent to the index.
    // Set the image of the cell.
    
    myCell.ingredient = [self.fridge objectAtIndex:indexPath.row];
   // [myCell updateColor];
    [myCell updateImagefor: myCell.ingredient];
    myCell.name.text = myCell.ingredient.name;
   // myCell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"photo-frame-selected.png"]];
    
  //  myCell.backgroundColor = [UIColor greenColor];
    return myCell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected");
    if (self.shareEnabled) {
        Item *anIngredient = [self.fridge objectAtIndex:indexPath.row];
        UICollectionViewCell *selectedCell = [self.collectionView cellForItemAtIndexPath:indexPath];
        
        selectedCell.backgroundColor = [UIColor colorWithRed:242/255.0f green:244/255.0f blue:102/255.0f alpha:1.0f];

        //   IngredientCollectionViewCell *myCell = collectionView
        NSString *selectedIngredientName = anIngredient.name;
        
        [self.selectedIngredients addObject:selectedIngredientName];
        
        NSLog(@"added %@ to recipe getter", selectedIngredientName);
        NSLog(@" all ingredients to be searched %@", [self.selectedIngredients componentsJoinedByString:@","]);
    }
}


-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
        NSLog(@"deselected");
    if (self.shareEnabled) {
        Item *anIngredient = [self.fridge objectAtIndex:indexPath.row];
        NSString *selectedIngredientName = anIngredient.name;
        UICollectionViewCell *deselectedCell = [self.collectionView cellForItemAtIndexPath:indexPath];
        deselectedCell.backgroundColor = nil;
        [self.selectedIngredients removeObject:selectedIngredientName];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self.collectionView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ice.png"]]];
    // Do any additional setup after loading the view.
   // [self fetchFridge];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.fridge = nil;
    self.shareEnabled = TRUE;
    self.selectedIngredients = nil;
    [super viewDidAppear:animated];
    [self.collectionView setAllowsMultipleSelection:YES];
    ReFreshDatabase *rdb = [ReFreshDatabase sharedDefaultReFreshDatabase];
    NSLog(@"rdb managed context: %@", rdb.managedObjectContext);
    if (rdb.managedObjectContext) {
        self.managedObjectContext = rdb.managedObjectContext;
        NSLog(@"my context is: %@", self.managedObjectContext);
        sleep(3);
        [self fetchFridge];
        
    } else {
        id observer = [[NSNotificationCenter defaultCenter] addObserverForName:ReFreshDatabaseAvailable
                                                                        object: rdb
                                                                         queue:[NSOperationQueue mainQueue]
                                                                    usingBlock:^(NSNotification *note) {
                                                                        self.managedObjectContext = rdb.managedObjectContext;
                                                                        [[NSNotificationCenter defaultCenter] removeObserver:observer];
                                                                    }];
        //[self fetchFridge];
        
    }
    [self.collectionView reloadData];
  //  NSLog(@"has managedcontext and fetched fridged");

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [self fetchFridge];
  //  [self.collectionView reloadData];
}



//get all current items in the database
-(void) fetchFridge
{
    if (self.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
        
        NSLog(@"fetching all saved ingredients with request");
        request.predicate = nil;
        
        request.sortDescriptors = [NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey:@"name" ascending: YES]];
        NSError *error = nil;
        NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    //    NSLog (@"results array is %@", results);
        [self addItemsToFridge: results];

     //   [request setFetchBatchSize:20];
        // NSLog(@"Set saved photos batch size");
        
       
 /*       self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
        //self.fetchedResultsController.delegate = self;
        
        NSLog(@"fetchedResultsController is %@", self.fetchedResultsController);
  */
            //   [self.collectionView reloadData];
    } else {
        self.fetchedResultsController = nil;
        NSLog(@"no fetched managedcontext");
    }
  //  NSLog(@"fetched object (fetchFridge) %@", self.fetchedResultsController.fetchedObjects);
}



-(void) addItemsToFridge: (NSArray *) results
{
  //  NSLog(@"fetched object %@", self.fetchedResultsController.fetchedObjects);
//    NSLog(@"fetchedResultsController (addItemsToFridge) is %@", self.fetchedResultsController);
  
    for (Item *item in results)
    {
        [self.fridge addObject:item];
        NSLog(@"ingredient to be used: %@", item.name);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"getRecipe"])
    {
        if ([segue.destinationViewController isKindOfClass:[RecipeTVC class]])
        {
            [self prepareRecipeTVC: segue.destinationViewController toDisplay: self.selectedIngredients];
        }
    }
}

-(void) prepareRecipeTVC: (RecipeTVC *)rtvc toDisplay: (NSArray *)ingredients
{
    rtvc.includedIngredients = ingredients;
    
}

@end
