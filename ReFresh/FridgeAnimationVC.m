//
//  FridgeAnimationVC.m
//  ReFresh
//
//  Created by Dianne Na on 6/5/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "FridgeAnimationVC.h"

@interface FridgeAnimationVC () 
@property (weak, nonatomic) IBOutlet UIImageView *fridgeTop;
@property (weak, nonatomic) IBOutlet UIImageView *fridgeBottom;

@property (strong, nonatomic) IBOutlet UIImageView *lemon;

@end

@implementation FridgeAnimationVC
@synthesize password;
@synthesize name;



- (void)viewDidLoad
{
    [super viewDidLoad];

}


-(void) viewDidAppear:(BOOL)animated
{
    _name.delegate = self;
    _password.delegate = self;
    
    self.lemon.frame = CGRectMake(50, -250, CGRectGetWidth(self.lemon.bounds), CGRectGetHeight(self.lemon.bounds));
    
    CGFloat topWidth = CGRectGetWidth(self.fridgeTop.bounds);
    CGFloat topHeight = CGRectGetHeight(self.fridgeTop.bounds);
    
    [UIView animateWithDuration:.75
                          delay:.5
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.fridgeTop.frame = CGRectMake(self.fridgeTop.frame.origin.x+400, self.fridgeTop.frame.origin.y, topWidth, topHeight);     
                     }
                     completion:^(BOOL finished){
                    }];
    
    
    CGFloat bottomWidth = CGRectGetWidth(self.fridgeBottom.bounds);
    CGFloat bottomHeight = CGRectGetHeight(self.fridgeBottom.bounds);
    
    [UIView animateWithDuration:.75
                          delay:.75
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.fridgeBottom.frame = CGRectMake(self.fridgeBottom.frame.origin.x-400, self.fridgeBottom.frame.origin.y, bottomWidth, bottomHeight);
                         
                     }
                     completion:^(BOOL finished){
                       
                     }];
    
    [UIView animateWithDuration:1
                          delay:1.5
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.lemon.frame = CGRectMake(self.lemon.frame.origin.x, self.lemon.frame.origin.y+320,CGRectGetWidth(self.lemon.bounds), CGRectGetHeight(self.lemon.bounds));
                         
                     }
                     completion:^(BOOL finished){
                     }];
    
}
    // Do any additional setup after loading the view.


- (IBAction)logIn:(UIButton *)sender {
   
}

#pragma mark UITextFieldDelegate

// dismisses the keyboard when the Return key is pressed

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == name) {
		[password becomeFirstResponder];
	}
	if (textField == password) {
		[passwordField resignFirstResponder];
	}
    
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
