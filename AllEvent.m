//
//  AllEvent.m
//  iOSOsuEventsApp
//
//  Created by Rohan Patil on 3/24/12.
//  Copyright (c) 2012 The Ohio State University. All rights reserved.
//

#import "AllEvent.h"
#import "Event.h"
#import "EventsCell.h"
#import "AppManager.h"

@implementation AllEvent

@synthesize mainTable,eventsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppManager *sharedManager = [AppManager sharedManager];
    NSURL *getAllEvents = [NSURL URLWithString:[sharedManager getUrlForKey:@"getAllEvents"]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:getAllEvents];
    [request startSynchronous];
    NSString *response = [request responseString];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:   NSUTF8StringEncoding] options:kNilOptions error:&error];
    NSDictionary *resultObj = [json objectForKey:@"result"];
    
    NSArray *data = [resultObj objectForKey:@"data"];
    NSMutableArray *eventsTempArr = [[NSMutableArray alloc]init];
    for(NSDictionary *eventDetails in data)
    {
        int eventId =[[eventDetails objectForKey:@"event_id"] intValue];
        NSString *eventName = [eventDetails objectForKey:@"name"];
        NSString *location = [eventDetails objectForKey:@"location"];
        NSString *category = [eventDetails objectForKey:@"category"];
        NSDate *startDate = [eventDetails objectForKey:@"start_date"];
        NSDate *endDate = [eventDetails objectForKey:@"end_date"];
        Event *tempEvent = [[Event alloc] init];
        tempEvent.eventId=[NSString stringWithFormat:@"%d",eventId];
        tempEvent.eventName=eventName;
        tempEvent.category=category;
        tempEvent.location=location;
        tempEvent.endDate=endDate;
        tempEvent.startDate=startDate;
        [eventsTempArr addObject:tempEvent];
    }
    [self setEventsArray:eventsTempArr];
    [eventsTempArr release];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
//    
//    // Configure the cell...
//    cell.textLabel.text = [self.eventsArray objectAtIndex:indexPath.row];
//    return cell;
//    
//    
//    
//    
//    
//}


-(EventsCell* )tableView:(UITableView *)tableViewLocal cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    Event *eventForCell = [[self eventsArray] objectAtIndex:[indexPath row]];
	
    
    
    static NSString *cellIdenti = @"MyCell";
    EventsCell *cell = [mainTable dequeueReusableCellWithIdentifier:cellIdenti];
    if (cell == nil)
    {  
        //cell = [[EventsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdenti];
        
        NSArray *tli = [[NSBundle mainBundle] loadNibNamed:@"EventsCell" owner:self options:nil];
        for(id curObj in tli){
            if([curObj isKindOfClass:[UITableViewCell class]]){
                cell = curObj;
                break;
            }
        }
    }
    cell.locationLable.text=eventForCell.location;
    cell.eventTitle.text=eventForCell.eventName;
    cell.catLable.text=eventForCell.category;
    cell.eventId.text=eventForCell.eventId;
    cell.eventId.hidden=YES;
    cell.inView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellback2.png"]];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EventsCell *cell =(EventsCell *) [mainTable cellForRowAtIndexPath:indexPath];
    
   
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.eventsArray count];
}


@end
