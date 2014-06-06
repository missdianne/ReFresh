//
//  NearbyFridgesVC.m
//  ReFresh
//
//  Created by Dianne Na on 6/5/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "NearbyFridgesVC.h"

@interface NearbyFridgesVC ()
@property (nonatomic, strong) NSArray *itemsInFridge;


@end

@implementation NearbyFridgesVC
@synthesize map;
@synthesize otherFridge;

-(void) updateMapViewAnnotations
{
    [self.map removeAnnotations:self.map.annotations];
    
    [self.map addAnnotations: self.itemsInFridge];
    [self.map showAnnotations:self.itemsInFridge animated:YES];
    
}

-(void)setFridge:(Fridge *)fridge
{
    _fridge = fridge;
    self.title = fridge.name;
    self.itemsInFridge = nil;
    [self updateMapViewAnnotations];
}

-(NSArray *) itemsInFridge
{
    if (!_itemsInFridge)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: @"Item"];
        request.predicate = [NSPredicate predicateWithFormat: @"includedIn = %@", self.fridge];
        _itemsInFridge = [self.fridge.managedObjectContext executeFetchRequest:request error:NULL];
    }
    return _itemsInFridge;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.map.delegate = self;
    // Do any additional setup after loading the view.
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.map setRegion:[self.map regionThatFits:region] animated:YES];
    
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    point1.coordinate = userLocation.coordinate;
    point1.title = @"Dianne's Fridge";
    
    
  //  point1.subtitle = @"";
    /*
    MKPointAnnotation *point2 = [[MKPointAnnotation alloc] init];
    point2.coordinate.longitude = userLocation.coordinate.longitude- 100;
    point2.coordinate.latitude = userLocation.coordinate.latitude-50;
    point2.title = @"Taylor's Fridge";
    point2.subtitle = @"I'm here!!!";

    point2.
     */
    
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog (@"annotation selected");
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
    

    cell.textLabel.text= @"working!";
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
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
