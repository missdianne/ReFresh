//
//  Fridge+Annotation.m
//  ReFresh
//
//  Created by Dianne Na on 6/6/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "Fridge+Annotation.h"


@implementation Fridge (Annotation)



-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    
    return coordinate;
    
}




@end
