//
//  AllEvent.h
//  iOSOsuEventsApp
//
//  Created by Rohan Patil on 3/24/12.
//  Copyright (c) 2012 The Ohio State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface AllEvent : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *eventsArray;
    UITableView *mainTable;
}

@property (nonatomic,retain) IBOutlet UITableView *mainTable;

@property (nonatomic,retain) NSMutableArray *eventsArray;

@end
