//
//  ForthViewController.h
//  TabBarDemo
//
//  Created by Chuanzhou Yi on 2/13/14.
//  Copyright (c) 2014 Chuanzhou Yi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
//#import "SBJson4.h"

@interface ForthViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>{
    IBOutlet UITableView *table;
    IBOutlet UITextField *txtFrom;
    IBOutlet UITextField *txtTo;
}

@property (nonatomic, retain) UITableView *table;
@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) NSMutableArray *listData;
@property (nonatomic, retain) NSString *currDescription;
@property (nonatomic, retain) NSMutableDictionary *dict;
- (IBAction)search:(id)sender;
@end
