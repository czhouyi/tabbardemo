//
//  ContactViewController.m
//  TabBarDemo
//
//  Created by Chuanzhou Yi on 2/11/14.
//  Copyright (c) 2014 Chuanzhou Yi. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController
@synthesize nameField;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)pressOK:(id)sender
{
    NSMutableDictionary *newdict = [[NSMutableDictionary alloc]initWithDictionary:self.dict];
    [newdict setObject:nameField.text forKey:@"name"];
    [self.delegate setValue:newdict];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    nameField.text = [dict objectForKey:@"name"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
