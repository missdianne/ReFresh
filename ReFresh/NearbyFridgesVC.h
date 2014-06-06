//
//  NearbyFridgesVC.h
//  ReFresh
//
//  Created by Dianne Na on 6/5/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Fridge+Create.h"

@interface NearbyFridgesVC : UIViewController <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) Fridge *fridge;
@property (strong, nonatomic) IBOutlet UITableView *otherFridge;


@end
