//
//  LoginVC.h
//  ReFresh
//
//  Created by Dianne Na on 7/23/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController <UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *doneButtone;



-(IBAction)cancel:(id)sender;
-(IBAction) done:(id)sender;

@end
