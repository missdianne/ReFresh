//
//  addItemViewController.m
//  ReFresh
//
//  Created by Dianne Na on 5/26/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "addItemViewController.h"
#import "ReFreshDatabase.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface addItemViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *servingSizeField;
@property (strong, nonatomic) EKEventStore *eventStore;
@property (weak, nonatomic) IBOutlet UISegmentedControl *servingTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *dateOpenField;
@property (strong, nonatomic) IBOutlet UIImageView *NutritionGroup1;
@property (nonatomic, strong) NSArray* listOfNGs;
@property (nonatomic) NSString *currentNG;;

@end

@implementation addItemViewController


#pragma mark - Properties

// lazy instantiation


-(EKEventStore *) eventStore
{
    if (!_eventStore) _eventStore = [[EKEventStore alloc]init];
    return _eventStore;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self veggieView];
    
    self.currentNG = @"veggies";
        NSLog(@"swipe recognizers begin");
    // Do any additional setup after loading the view.
    UISwipeGestureRecognizer *swipeleft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRecognized:)];
    
    [swipeleft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeleft];
    
    
    UISwipeGestureRecognizer *swiperight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRecognized:)];
    [swiperight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swiperight];

    UISwipeGestureRecognizer *swipeup = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRecognized:)];
    [swipeup setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeup];

    
    UISwipeGestureRecognizer *swipedown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRecognized:)];
    [swipedown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipedown];
    
    _nameField.delegate = self;
    _servingSizeField.delegate = self;
    _dateOpenField.delegate = self;
}

-(void) swipeRecognized: (UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction ==UISwipeGestureRecognizerDirectionLeft)
    {
        [self veggieView];
        NSLog(@"swiped left");
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self fruitView];
        NSLog (@"swiped right");
    }
    if (swipe.direction ==UISwipeGestureRecognizerDirectionUp)
    {
        [self dairyView];
        NSLog(@"swiped up");
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown)
    {
        [self proteinView];
        NSLog(@" swiped down");
    }
    
    
}

-(void) dairyView
{
    
    UIImageView *newView = [[UIImageView alloc]init];
    CGFloat height = CGRectGetHeight(self.NutritionGroup1.superview.bounds);
    CGFloat width = CGRectGetWidth(self.NutritionGroup1.superview.bounds);
    newView.frame    = CGRectMake(100,400, width, height);
    
    newView.image = [UIImage imageNamed: @"dairy.png"];
   // [newView addSubview:newImage];
    
    self.NutritionGroup1.image = [UIImage imageNamed: @"dairy.png"];
    self.view.backgroundColor = [UIColor colorWithRed:189/255.0f green:242/255.0f blue:253/255.0f alpha:1.0f];
    self.servingTypeSegmentedControl.selectedSegmentIndex = 1;
    self.currentNG = @"dairy";
}

-(void)veggieView
{
    self.NutritionGroup1.image = [UIImage imageNamed: @"veggies.png"];
    self.view.backgroundColor = [UIColor colorWithRed:69/255.0f green:183/255.0f blue:121/255.0f alpha:1.0f];
       self.servingTypeSegmentedControl.selectedSegmentIndex = 2;
    self.currentNG = @"veggie";
}

-(void)fruitView
{
    self.NutritionGroup1.image = [UIImage imageNamed: @"fruits1.png"];
    self.view.backgroundColor = [UIColor colorWithRed:221/255.0f green:204/255.0f blue:11/255.0f alpha:1.0f];
       self.servingTypeSegmentedControl.selectedSegmentIndex = 3;
    self.currentNG = @"fruit";
}

-(void)proteinView
{
    self.NutritionGroup1.image = [UIImage imageNamed:@"protein.png"];
    self.view.backgroundColor = [UIColor colorWithRed:153/255.0f green:43/255.0f blue:119/255.0f alpha:1.0f];
       self.servingTypeSegmentedControl.selectedSegmentIndex = 2;
    self.currentNG = @"protein";
}


-(NSArray *) listOfNGs {
    if (!_listOfNGs)
    {
        _listOfNGs =[[NSArray alloc]initWithObjects:@"dairy",@"protein", @"fruits", @"veggies", nil];
    }
    return _listOfNGs;
}



- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

-(void) addItem
{
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        NSLog (@"time now: %f", now);
        
        NSNumber *n = [NSNumber numberWithDouble:now];
        NSLog (@"time now: %@", n);

      //  NSNumber *n = [NSNumber num self.dateOpenField.text;
        NSInteger selected = self.servingTypeSegmentedControl.selectedSegmentIndex;
        NSString *servingTypeString = [self addServingType: selected];

    // convert image into NSData and save it
    
    NSData *photo =  UIImagePNGRepresentation(self.NutritionGroup1.image);
    
        NSDictionary *itemDictionary = @{@"name": self.nameField.text, @"servingSize": [NSNumber numberWithFloat:[self.servingSizeField.text floatValue]], @"servingType": servingTypeString, @"dateOpen": n, @"NutritionGroup": self.currentNG, @"photo": photo};
        
        
        Item *item = [Item itemWithInfo:itemDictionary inManagedObjectContext: self.managedObjectContext];
        
        NSLog (@"item: %@ has been saved", item.name);
    [self addReminderEventForItem:item];
    
}


- (IBAction)takePhoto:(UIButton *)sender {
    UIImagePickerController *uiipc = [[UIImagePickerController alloc]init];
    uiipc.delegate = self;
    uiipc.mediaTypes = @[(NSString *)kUTTypeImage];
    uiipc.sourceType = UIImagePickerControllerSourceTypeCamera|UIImagePickerControllerSourceTypePhotoLibrary;
    uiipc.allowsEditing = YES;
    [self presentViewController:uiipc animated:YES completion:NULL];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image)
    {
        image = info[UIImagePickerControllerEditedImage];
    }
    self.NutritionGroup1.image = image;
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (IBAction)createItem:(UIButton *)sender {
    NSLog(@"creating new item in database");
    if ([self checkItem]){
        [self addItem];
        [self alert:@"Your new item has been added and created in the Reminder list"];
    }
}

-(Boolean) checkItem
{
    if (![self.nameField.text length]) {
        [self alert:@"Title is required."];
        return FALSE;
    }
    else if (![self.servingSizeField.text length]) {
        [self alert:@"Serving Size is required."];
        return FALSE;
    }
    else {
        return TRUE;
    }

}



// prevent Unwinding if we can't create a valid Photo

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:DONE_ADDING_PHOTO_UNWIND_SEGUE_IDENTIFER]) {
        if (![self.nameField.text length]) {
            [self alert:@"Title is required."];
            return NO;
        }
        if (![self.servingSizeField.text length]) {
            [self alert:@"Serving Size is required."];
            return NO;
        } else if (!self.servingTypeSegmentedControl.selectedSegmentIndex) {
            [self alert:@"Can't figure out where you are!"];
            return NO;
        }
         else {
            return YES;
        }
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

- (void)alert:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"Add Item to Fridge"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
}



-(NSString *) addServingType: (NSInteger) selected
{
    NSString *servType = nil;
    switch (selected) {
        case 0:
            return servType = @"oz";
            break;
        case 1:
            return servType = @"gallon";
        case 2:
            return servType = @"lb";
        case 3:
            return servType = @"piece(s)";
        default:
            @throw [NSException exceptionWithName:@"unkonwnFileFormat"
                                           reason:[NSString stringWithFormat:@"need to enter serving type"]
                                         userInfo:nil];
            break;
    }
}

-(NSString *) presetExpToToday
{
    NSDate *expr = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:expr];

    return dateString;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    ReFreshDatabase   *refreshdb = [ReFreshDatabase sharedDefaultReFreshDatabase];
    if (refreshdb.managedObjectContext) {
        self.managedObjectContext = refreshdb.managedObjectContext;
      //  [self setupFetchedResultsControllerOfSavedPhoto];
    } else {
        id observer = [[NSNotificationCenter defaultCenter] addObserverForName: ReFreshDatabaseAvailable
                                                                        object:refreshdb
                                                                         queue:[NSOperationQueue mainQueue]
                                                                    usingBlock:^(NSNotification *note) {
                                                                        self.managedObjectContext = refreshdb.managedObjectContext;
                                                                        [[NSNotificationCenter defaultCenter] removeObserver:observer];
                                                                    }];
    }
    
}

#pragma mark EventKit

-(void) addReminderEventForItem: (Item *) item
{
   // EKEventStore *eventStore = [[EKEventStore alloc]init];
    
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
            myReminder.title  = [NSString stringWithFormat:@"%@ expires on  %@", item.name, item.dateExpire];
         //   myReminder.calendar  = [self.eventStore defaultCalendarForNewReminders];
                
                myReminder.calendar = calendar;
            NSLog(@"saving in calendar: %@", myReminder.calendar.title);
                
                NSError *error = nil;
                [self.eventStore saveReminder:myReminder commit:YES error:&error];
                
 //           myReminder.startDateComponents = [[NSDate alloc] init];
            
           /* NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM/dd/yyyy"];
            NSString *dateString = [dateFormat stringFromDate:expr];
            NSLog (@"new reminder set for %@ aka %@", dateString, expr);
                
         
            myReminder.dueDateComponents  = expr;
         */
          //      NSTimeInterval interval = 60* -60;
//                EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:interval];
                EKAlarm *alarm = [[EKAlarm alloc]init];
                
                NSTimeInterval seconds = [item.dateExpire doubleValue];
                NSDate *expr = [NSDate dateWithTimeIntervalSince1970:seconds];
                
                [alarm setAbsoluteDate:expr];
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




#pragma mark UITextFieldDelegate

// dismisses the keyboard when the Return key is pressed

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
