//
//  NearbyFridgesVC.h
//  ReFresh
//
//  Created by Dianne Na on 6/5/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NearbyFridgesVC : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *map;

@end
