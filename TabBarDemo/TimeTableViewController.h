//
//  TimeTableViewController.h
//  TabBarDemo
//
//  Created by Chuanzhou Yi on 2/14/14.
//  Copyright (c) 2014 Chuanzhou Yi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeTableViewController : UIViewController
{
    IBOutlet UITextField *trainCode;
    IBOutlet UITextField *firstStation;
    IBOutlet UITextField *lastStation;
    IBOutlet UITextField *startStation;
    IBOutlet UITextField *arriveStation;
    IBOutlet UITextField *startTime;
    IBOutlet UITextField *arriveTime;
    IBOutlet UITextField *useTime;
    IBOutlet UITextField *KM;
}

@property (nonatomic, retain) UITextField *trainCode;
@property (nonatomic, retain) UITextField *firstStation;
@property (nonatomic, retain) UITextField *lastStation;
@property (nonatomic, retain) UITextField *startStation;
@property (nonatomic, retain) UITextField *arriveStation;
@property (nonatomic, retain) UITextField *startTime;
@property (nonatomic, retain) UITextField *arriveTime;
@property (nonatomic, retain) UITextField *useTime;
@property (nonatomic, retain) UITextField *KM;

@property (nonatomic, retain) NSDictionary *dict;

- (IBAction)pressBack:(id)sender;

@end
