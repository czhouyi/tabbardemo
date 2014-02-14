//
//  ContactViewController.h
//  TabBarDemo
//
//  Created by Chuanzhou Yi on 2/11/14.
//  Copyright (c) 2014 Chuanzhou Yi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface ContactViewController : UIViewController
{

    IBOutlet UITextField *nameField;
}

@property (nonatomic, retain) NSDictionary *dict;
@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) NSObject<PassValueDelegate> *delegate;

-(IBAction)pressBack:(id)sender;
-(IBAction)pressOK:(id)sender;

@end
