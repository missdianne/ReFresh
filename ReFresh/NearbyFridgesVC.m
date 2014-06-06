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
    
//
  
    // Do any additional setup after loading the view.
}



-(void)viewDidAppear:(BOOL)animated
{
    CLLocationCoordinate2D  point1;
    point1.latitude = 37.4260719;
    point1.longitude = -122.1522775;
    
    MKPointAnnotation *pointA = [[MKPointAnnotation alloc] init];
    pointA.coordinate = point1;
    pointA.title = @"dianne";
    [self.map addAnnotation:pointA];
    
    
    //37.4224761,-122.1463721
    CLLocationCoordinate2D  point2;
    point2.latitude = 37.4224761;
    point2.longitude = -122.1463721;
    
    MKPointAnnotation *pointB = [[MKPointAnnotation alloc] init];
    pointB.coordinate = point2;
    pointB.title = @"taylor";
    [self.map addAnnotation:pointB];
    
    
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(pointA.coordinate, 800,800);
    [self.map setRegion:[self.map regionThatFits:region] animated:YES];
    
    ReFreshDatabase *rdb = [ReFreshDatabase sharedDefaultReFreshDatabase];
    if (rdb.managedObjectContext) {
        self.managedObjectContext = rdb.managedObjectContext;
        [self fetchFridgewithName: @"dianne"];
        
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
    [self.otherFridge reloadData];
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
    if ([view.annotation.title  isEqual: @"dianne"])
    {
        [self.itemsInFridge removeAllObjects];
        [self fetchFridgewithName:@"dianne"];
        [self.otherFridge reloadData];
        self.otherFridge.backgroundColor =  [UIColor colorWithRed:255/255.0f green:221/255.0f blue:9/255.0f alpha:1.0f];
    }
    if ([view.annotation.title  isEqual: @"taylor"])
    {
        [self.itemsInFridge removeAllObjects];
        [self fetchFridgewithName:@"taylor"];
        [self.otherFridge reloadData];
        self.otherFridge.backgroundColor = [UIColor colorWithRed:124/255.0f green:179/255.0f blue:219/255.0f alpha:1.0f];

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
    return cell;
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
