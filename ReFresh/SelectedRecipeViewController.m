//
//  SelectedRecipeViewController.m
//  ReFresh
//
//  Created by Dianne Na on 5/31/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "SelectedRecipeViewController.h"

@interface SelectedRecipeViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *viewWeb;

@end

@implementation SelectedRecipeViewController


- (void)viewDidLoad
{
   // [super viewDidLoad];
    [super viewDidLoad];
    if (self.fullURL)
    {
     //   NSURL *url = [NSURL URLWithString:self.fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.fullURL];
        [_viewWeb loadRequest:requestObj];
        NSLog(@"website loaded");
    }
    // Do any additional setup after loading the view.
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
