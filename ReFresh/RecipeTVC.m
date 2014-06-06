//
//  RecipeTVC.m
//  ReFresh
//
//  Created by Dianne Na on 5/29/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "RecipeTVC.h"
#import "SelectedRecipeViewController.h"

@interface RecipeTVC ()

@end

@implementation RecipeTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSArray *)includedIngredients
{
    if(!_includedIngredients)
    {
        _includedIngredients = [[NSArray alloc]init];
    }
    return _includedIngredients;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  //  [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ice.png"]]];
    [self fetchRecipes];
  
    
    //   NSArray *basil =[[NSArray alloc]initWithObjects:@"basil", nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) fetchRecipes
{
    
    NSURL *url = [YummlyFetcher URLforRecipes:self.includedIngredients maxResults:50];
    NSLog(@"url is %@", url);
    [self.refreshControl beginRefreshing];
  
    dispatch_queue_t fetchQueue = dispatch_queue_create("recipe search fetch", NULL);
    dispatch_async(fetchQueue, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
       // NSLog(@"jsonresults is %@", jsonResults);
        NSError *jsonError;
        NSDictionary *propertyListResults = jsonResults ? [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                                          options: NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                                                                            error:&jsonError] : nil;
        
        if (jsonError)
        {
            NSLog(@" error: %@", jsonError.localizedDescription);
        }
        NSArray *recipes = [propertyListResults valueForKeyPath: @"matches"];
        
        
         NSLog(@"propertyList results: %@", propertyListResults);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.resultRecipes = recipes;
            NSLog(@"Array length %lu", (unsigned long)[recipes count]);
            [self.tableView reloadData];
            //NSLog(@"all places%@", self.places);
        });
    });

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"num of results returned %lu", (unsigned long)[self.resultRecipes count]);
    return [self.resultRecipes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"B");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Recipe" forIndexPath:indexPath];
    
    NSDictionary *arecipe = [self.resultRecipes objectAtIndex:indexPath.row];

    cell.textLabel.text = [arecipe valueForKeyPath:RECIPE_NAME];
  //  NSLog (@"cell text %@", cell.textLabel.text);
    NSData *thumbData = [self thumbNailPhoto:arecipe];
    NSLog (@"numbnail data is %@", thumbData);
    if (thumbData)
    {
        UIImage *cellImage = [UIImage imageWithData: thumbData];
        cell.imageView.image = cellImage;
        NSLog(@"there is image in the cell");
    }

    NSNumber *ratingNum = [arecipe valueForKeyPath:RECIPE_RATING];
    NSLog(@"rating is %@", ratingNum);
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"recipe rating: %@", ratingNum];
    cell.detailTextLabel.textColor = [UIColor orangeColor];
    
    return cell;
}

-(NSData*) thumbNailPhoto: (NSDictionary *)arecipe
{
    NSString *thumNail = [[arecipe valueForKey:RECIPE_THUMBNAIL_IMAGE] firstObject];
    
    NSURL *thumbnailURL = [[NSURL alloc]initWithString:thumNail];
    
    __block NSData *image = nil;
    NSLog(@"thumbnail URL is %@", thumbnailURL);

    if (thumbnailURL)
    {
        NSURLRequest *request = [NSURLRequest requestWithURL: thumbnailURL ];
        // another configuration option is backgroundSessionConfiguration (multitasking API required though)
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        // create the session without specifying a queue to run completion handler on (thus, not main queue)
        // we also don't specify a delegate (since completion handler is all we need)
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                        completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
                                                            // this handler is not executing on the main queue, so we can't do UI directly here
                                                            if (!error) {
                                                                if ([request.URL isEqual:thumbnailURL]) {
                                                                    // UIImage is an exception to the "can't do UI here"
                                                                    image = [NSData dataWithContentsOfURL:localfile];
                                                                    
                                                                    // but calling "self.image =" is definitely not an exception to that!
                                                                    // so we must dispatch this back to the main queue
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                     //   [self.tableView reloadData];
                                                                       // NSLog(@"raw thumbnail image %@", image);
                                                                        
                                                                    });
                                                                }
                                                            }
                                                        }];
        [task resume]; // don't forget that all NSURLSession tasks start out suspended!
    }
    return image;
}


#pragma mark - UITableViewDelegate



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath)
        {
            if ([segue.identifier isEqualToString:@"toRecipeWebsite"])
            {
                if ([segue.destinationViewController isKindOfClass:[SelectedRecipeViewController class]]) {
                    NSDictionary *arecipe = [self.resultRecipes objectAtIndex:indexPath.row];
                    [self prepareSelectedRecipeViewController: segue.destinationViewController toDisplayRecipe: arecipe];
                }
            }
        }
    }
}

-(void) prepareSelectedRecipeViewController: (SelectedRecipeViewController *)srvc toDisplayRecipe: (NSDictionary *) arecipe
{
    srvc.fullURL = [YummlyFetcher URLofRecipe:arecipe];
    NSLog(@"taking you to website %@", srvc.fullURL);
}


@end
