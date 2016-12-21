//
//  LoginVC.m
//  ReFresh
//
//  Created by Dianne Na on 7/23/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "LoginVC.h"

#import <Parse/Parse.h>

@interface LoginVC ()
-(void) processFieldEntries;
-(BOOL) shouldEnableDoneButton;
@end

@implementation LoginVC

@synthesize doneButtone;
@synthesize password;
@synthesize name;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChanged:) name:UITextFieldTextDidChangeNotification objecct: name];

    doneButtone.enabled = YES;
}

-(void) viewDidAppear:(BOOL)animated
{
    name.delegate = self;
    password.delegate = self;
    [name becomeFirstResponder];
    [super viewDidAppear:animated];
}




#pragma mark UITextFieldDelegate

// dismisses the keyboard when the Return key is pressed

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UITextFieldDelegate

- (BOOL)shouldEnableDoneButton {
	BOOL enableDoneButton = NO;
	if (name.text != nil &&
		name.text.length > 0 &&
		password.text != nil &&
		password.text.length > 0 ){
		enableDoneButton = YES;
	}
	return enableDoneButton;
}

- (IBAction)done:(id)sender {
	[name resignFirstResponder];
	[password resignFirstResponder];
    doneButtone.enabled = YES;
    NSLog(@"a");
	[self processFieldEntries];
}

- (IBAction)cancel:(id)sender {
//	[self.presentingViewController dismissModalViewControllerAnimated:YES];
}

-(void) processFieldEntries
{
    NSString *username = name.text;
    NSString *passwordString = password.text;
    
    //error checking
    if (username.length ==0 ||passwordString.length ==0)
    {
    }
    
    
    //if no errors
    doneButtone = NO;
    //make a view to indicate entry is being added
    
    
    //add new user to Parse
    PFUser *parseUser = [PFUser user];
    parseUser.username = username;
    parseUser.password = passwordString;
    
    [parseUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (error) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
			[alertView show];
			doneButtone.enabled = [self shouldEnableDoneButton];
		//	[activityView.activityIndicator stopAnimating];
		//	[activityView removeFromSuperview];
			// Bring the keyboard back up, because they'll probably need to change something.
			[name becomeFirstResponder];
			return;
		}
        if (succeeded)
        {
            [self alert:[NSString stringWithFormat:@"signup successful"]];
            [self goToFirstView];

        }
        
    }];
   
 }

-(void) goToFirstView
{
    //UIViewController *vc = [self parentViewController];
    [self dismissViewControllerAnimated:true completion:nil];
  //  [vc dismissViewControllerAnimated:true completion:nil];
}


- (void)alert:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"ReFresh--My Fridge" message:msg
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:@"Yes", nil] show];
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
