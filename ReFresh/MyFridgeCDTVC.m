//
//  MyFridgeCDTVC.m
//  ReFresh
//
//  Created by Dianne Na on 5/25/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "MyFridgeCDTVC.h"
#import "Item.h"
#import "NutritionGroup.h"
#import "ReFreshDatabase.h"
#import "ReFreshAppDelegate.h"
#import "FridgeAnimationVC.h"

@interface MyFridgeCDTVC () <UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *fetchedItems;
@property (nonatomic, strong) NSMutableArray *fetchedNGs;
@property (nonatomic) Boolean toDelete;
@property (strong, nonatomic) EKEventStore *eventStore;
@end

@implementation MyFridgeCDTVC

-(EKEventStore *) eventStore
{
    if (!_eventStore) _eventStore = [[EKEventStore alloc]init];
    return _eventStore;
}

-(NSArray *) fetchedItems
{
    if (!_fetchedItems)
    {
        _fetchedItems = [[NSArray alloc]init];
    }
    return _fetchedItems;
}

-(NSMutableArray *) fetchedNGs
{
    if (!_fetchedNGs)
    {
        _fetchedNGs = [[NSMutableArray alloc] init];
    }
    return _fetchedNGs;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
  //  [Item userInManagedObjectContext:self.managedObjectContext];
    [self setupFetchedResultsController];
}


- (void)setupFetchedResultsController
{
    if (self.managedObjectContext) {
   //     NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NutritionGroup"];
          NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
        request.predicate = [NSPredicate predicateWithFormat:@"includedIn.name == %@", @"dianne"]; // this means ALL items
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                  ascending:YES
                                                                   selector:@selector(localizedStandardCompare:)]];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
   //     self.fetchedResultsController.delegate = self;
        self.fetchedItems = [self.fetchedResultsController fetchedObjects];
              
        self.fetchedNGs = [self listNGs: self.fetchedItems];
    } else {
        self.fetchedResultsController = nil;
    }
   // self.fetchedNGs = [[self.fetchedResultsController fetchedObjects] mutableCopy];
   // NSLog(@"fetched complete list %@", self.fetchedNGs);
}

-(NSMutableArray *) listNGs: (NSArray *) fetchedItems
{
    self.fetchedNGs = nil;
    for (Item* item in fetchedItems)
    {
        if (![self.fetchedNGs containsObject: item.belongTo])
        {
            [self.fetchedNGs addObject:item.belongTo];
        }
    }
    return self.fetchedNGs;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = nil;
  //  [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ice.png"]]];
    self.toDelete = FALSE;
    
    // Do any additional setup after loading the view.
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    ReFreshDatabase *refreshdb = [ReFreshDatabase sharedDefaultReFreshDatabase];
    if (refreshdb.managedObjectContext) {
        self.managedObjectContext = refreshdb.managedObjectContext;
        //   NSLog(@"my context is: %@", self.managedObjectContext);
    } else {
        id observer = [[NSNotificationCenter defaultCenter] addObserverForName:ReFreshDatabaseAvailable
                                                                        object:refreshdb
                                                                         queue:[NSOperationQueue mainQueue]
                                                                    usingBlock:^(NSNotification *note) {
                                                                        self.managedObjectContext = refreshdb.managedObjectContext;
                                                                        [[NSNotificationCenter defaultCenter] removeObserver:observer];
                                                                    }];
    }
    
    
    
   // [self loadLogin];
    
    
     [self.tableView reloadData];
    
}


-(void) loadLogin
{
    FridgeAnimationVC *favc = [[FridgeAnimationVC alloc]init];
    [favc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:favc animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
//    return [self.fetchedItems count] ;
   // NSLog(@"num of section in table %i", [self.fetchedNGs count]);
  //  return [self.fetchedNGs count];
    return 1;
}

/*
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionHeader
{
  //  NutritionGroup *ng = [self.fetchedResultsController.fetchedObjects objectAtIndex:sectionHeader];
    
    //NutritionGroup *ng = [self.fetchedNGs objectAtIndex: sectionHeader];
    //NSLog (@"section header %@", ng.name);
   // return ng.name;
//    return [sectionInfo name];
    NutritionGroup *ng = [self.fetchedNGs objectAtIndex:sectionHeader];
    return ng.name;
}
 */

//returns a diff number based on the number of cities in that country
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsController.fetchedObjects count];
}

-(NSMutableArray *) getItemsInNG: (NSArray *)fetchedItems from: (NutritionGroup *)ng
{
    NSMutableArray *itemsInNG = [[NSMutableArray alloc]init];
    for (Item *item in fetchedItems)
    {
        if (item.belongTo == ng)
        {
            [itemsInNG addObject:item];
        }
    }
    return itemsInNG;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Food Item"];
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ of %@", item.servingSize, item.servingType,item.name];
    
    NSTimeInterval seconds = [item.dateExpire doubleValue];
   // NSLog (@"seconds to expiration %f", seconds);
    
    NSDate *expr = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:expr];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"expires %@", dateString];
    

   // NSLog(@"date: %@", dateString);
    
    NSDate *now = [NSDate date];
   // NSNumber *nowTime = [NSNumber numberWithDouble:now];
 //   NSNumber *nearExpiration = @(60*60*24*4);
 //   NSNumber *daysToExpir = @([item.dateExpire doubleValue] - now);


    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:expr];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate: now];
    
    if ([comp1 day]-2   <= [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year]  == [comp2 year])
    {
        cell.backgroundColor = [UIColor colorWithRed:255/255.0f green:181/255.0f blue:201/255.0f alpha:1.0f];
        if (item.nearExpire ==0){
          [self addReminderEventForItem:item];
        item.nearExpire = [NSNumber numberWithInt:1];
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    return cell;
}



-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *delItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.managedObjectContext deleteObject:delItem];
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
 


}

- (void)alert:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"ReFresh--My Fridge" message:msg
                               delegate:self
                      cancelButtonTitle:@"No"
                      otherButtonTitles:@"Yes", nil] show];
}


#pragma mark EventKit

-(void) addReminderEventForItem: (Item *) item
{
    if ([self.eventStore respondsToSelector: @selector(requestAccessToEntityType:completion:)]){
        [self.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error){
            if (granted){
                //code for when user allows access to calendar
                //EKEvent *myEvent  = [EKEvent reminderWithEventStore:eventStore];
                
                NSArray *calendars = [self.eventStore calendarsForEntityType:EKEntityTypeReminder];
                
                for (EKCalendar *calendar in calendars)
                {
                    NSLog(@"Calendar = %@", calendar.title);
                }
                
                EKCalendar *calendar = [calendars lastObject];
                EKReminder *myReminder = [EKReminder reminderWithEventStore: self.eventStore];
                
                NSLog (@"***new reminder added for %@", item.name);
                
                NSTimeInterval seconds = [item.dateExpire doubleValue];
                
                NSDate *expr = [NSDate dateWithTimeIntervalSince1970:seconds];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MM/dd/yyyy"];
                NSString *dateString = [dateFormat stringFromDate:expr];

                
                myReminder.title  = [NSString stringWithFormat:@"%@ expires on  %@", item.name, dateString];
                //   myReminder.calendar  = [self.eventStore defaultCalendarForNewReminders];
                
                myReminder.calendar = calendar;
              
                
                NSError *error = nil;
                [self.eventStore saveReminder:myReminder commit:YES error:&error];
                
                  NSLog(@"saving in calendar: %@", myReminder.calendar.title);
             
                NSTimeInterval timeInterval = 100;
                NSDate *alarmDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
                EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:alarmDate];
                [myReminder addAlarm:alarm];
                
                NSLog(@"added alert");
                
                //  [myReminder setCalendar:[eventStore defaultCalendarForNewEvents]];
                //               [self performCalendarActivity: eventStore];
            }
            else {
                NSLog(@" user did not want reminder added");
            }
        }];
    } else {
        //code for iOS <6.0
        NSLog(@" older version of iOS");
    }
    NSLog(@"end of eventkit reached");
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


@end
