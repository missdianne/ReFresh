//
//  NearbyFridgesVC.m
//  ReFresh
//
//  Created by Dianne Na on 6/5/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "NearbyFridgesVC.h"
#import "ReFreshDatabase.h"

@interface NearbyFridgesVC () 
@property (nonatomic, strong) NSMutableArray *itemsInFridge;
@property (nonatomic, strong) NSMutableArray *allFridges;

@end

@implementation NearbyFridgesVC
@synthesize map;
@synthesize otherFridge;

/*
-(void) updateMapViewAnnotations
{
    [self.map removeAnnotations:self.map.annotations];
    [self.map addAnnotations: self.itemsInFridge];
    [self.map showAnnotations:self.itemsInFridge animated:YES];
}
 */

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    // sleep(10);
    //  [self fetchFridge];
}

-(NSMutableArray *)allFridges{
    if (!_allFridges)
    {
        _allFridges = [[NSMutableArray alloc]init];
    }
    return _allFridges;
}

-(void)setFridge:(Fridge *)fridge
{
    _fridge = fridge;
    self.title = fridge.name;
    self.itemsInFridge = nil;
  //  [self updateMapViewAnnotations];
}

-(NSMutableArray *) itemsInFridge
{
    if (!_itemsInFridge)
    {
        _itemsInFridge = [[NSMutableArray alloc]init];
    }
    return _itemsInFridge;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.map.delegate = self;
    [self.view addSubview:self.map];
    self.otherFridge.delegate = self;
    [self.view addSubview:self.otherFridge];
    self.allFridges  = nil;
//
  
    // Do any additional setup after loading the view.
}



-(void)viewDidAppear:(BOOL)animated
{

    
    ReFreshDatabase *rdb = [ReFreshDatabase sharedDefaultReFreshDatabase];
    if (rdb.managedObjectContext) {
        self.managedObjectContext = rdb.managedObjectContext;
        [self setupFridges];
        Fridge *first = [self.allFridges firstObject];
        [self fetchFridgewithName: first.name];
        
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
    if (self.allFridges)
    {
        Fridge *first = [self.allFridges firstObject];
        CLLocationCoordinate2D  point2;
        point2.latitude = (CLLocationDegrees)[first.latitude doubleValue];
        point2.longitude = (CLLocationDegrees) [first.longitude doubleValue];
        
        MKPointAnnotation *pointB = [[MKPointAnnotation alloc] init];
        pointB.coordinate = point2;
        pointB.title = first.name;
        [self.map addAnnotation:pointB];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(pointB.coordinate, 800,800);
        [self.map setRegion:[self.map regionThatFits:region] animated:YES];
    }
    [self.otherFridge reloadData];
}


-(void)setupFridges
{
    if(self.managedObjectContext)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Fridge"];
        
        request.predicate = nil; //all fridges
        request.sortDescriptors = [NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey:@"name" ascending: YES]];
        NSError *error = nil;
        NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
        for (Fridge *fridge in results)
        {
            [self.allFridges addObject:fridge];
            CLLocationCoordinate2D  point2;
            point2.latitude = (CLLocationDegrees)[fridge.latitude doubleValue];
            point2.longitude = (CLLocationDegrees) [fridge.longitude doubleValue];
            
            MKPointAnnotation *pointB = [[MKPointAnnotation alloc] init];
            pointB.coordinate = point2;
            pointB.title = fridge.name;
            [self.map addAnnotation:pointB];
         //   NSLog (@"NEARBY FRIDGES------add current fridge %@  to location %f", pointB.title, pointB.coordinate.latitude);

        }
    }
    else{
        self.fetchedResultsController = nil;
    }
}

-(void) fetchFridgewithName: (NSString *)name
{
    if (self.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
        
        request.predicate = [NSPredicate predicateWithFormat:@"includedIn.name == %@", name]; // for my fridge
        
        request.sortDescriptors = [NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey:@"name" ascending: YES]];
        NSError *error = nil;
        NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
        [self addItemsToFridge: results];
       } else {
        self.fetchedResultsController = nil;
    }
}


-(void) addItemsToFridge: (NSArray *) results
{
    for (Item *item in results)
    {
        [self.itemsInFridge addObject:item];
    }
}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
        [self.itemsInFridge removeAllObjects];
        [self fetchFridgewithName:view.annotation.title];
        [self.otherFridge reloadData];
    
        if ([view.annotation.title  isEqual: @"dianne"])
        {
        self.otherFridge.backgroundColor= [UIColor colorWithRed:255/255.0f green:233/255.0f blue:98/255.0f alpha:1.0f];
        }
        else{
        self.otherFridge.backgroundColor = [UIColor colorWithRed:101/255.0f green:197/255.0f blue:241/255.0f alpha:1.0f];
        }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"shared fridge contents"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];

    Item *item = [self.itemsInFridge objectAtIndex:indexPath.row];
    cell.textLabel.text= item.name ;
    
    /*UIButton *borrow = [[UIButton alloc]initWithFrame:CGRectMake(5,5,40,40)];
        borrow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [borrow setTitle:@"Borrow" forState:UIControlStateNormal];
    borrow.backgroundColor = [UIColor blackColor];
    [cell addSubview:borrow];
    [tableView cellForRowAtIndexPath:indexPath].accessoryView = borrow;
    
    cell.accessoryView = borrow;
     */
    //  NSLog(@"button is %@t,superview is %@", borrow.titleLabel, borrow.superview);

    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
       Item *item = [self.itemsInFridge objectAtIndex:indexPath.row];
    NSString *msg = [NSString stringWithFormat:@"borrowing %@ ", item.name];
                     
    [[[UIAlertView alloc] initWithTitle:@"ReFresh--borrow"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.itemsInFridge count];
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
