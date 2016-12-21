//
//  FridgeAnimationVC.h
//  ReFresh
//
//  Created by Dianne Na on 6/5/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFridgeCDTVC.h"

@interface FridgeAnimationVC : UIViewController <UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *password;


@end
