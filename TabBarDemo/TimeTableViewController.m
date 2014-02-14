//
//  TimeTableViewController.m
//  TabBarDemo
//
//  Created by Chuanzhou Yi on 2/14/14.
//  Copyright (c) 2014 Chuanzhou Yi. All rights reserved.
//

#import "TimeTableViewController.h"

@interface TimeTableViewController ()

@end

@implementation TimeTableViewController

@synthesize firstStation, lastStation, startStation, arriveStation, startTime, arriveTime,
            useTime, KM;

@synthesize dict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)pressBack:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.trainCode.text = [self.dict objectForKey:@"TrainCode"];
    self.firstStation.text = [self.dict objectForKey:@"FirstStation"];
    self.lastStation.text = [self.dict objectForKey:@"LastStation"];
    self.startStation.text = [self.dict objectForKey:@"StartStation"];
    self.arriveStation.text = [self.dict objectForKey:@"ArriveStation"];
    self.startTime.text = [self.dict objectForKey:@"StartTime"];
    self.arriveTime.text = [self.dict objectForKey:@"ArriveTime"];
    self.useTime.text = [self.dict objectForKey:@"UseDate"];
    self.KM.text = [self.dict objectForKey:@"KM"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
