//
//  ThirdViewController.h
//  TabBarDemo
//
//  Created by Chuanzhou Yi on 2/7/14.
//  Copyright (c) 2014 Chuanzhou Yi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdViewController : UIViewController<UIWebViewDelegate> {
    IBOutlet UIWebView *webView;
    IBOutlet UITextField *textField;
    IBOutlet UIButton *goBack;
    IBOutlet UIButton *goForward;
    UIActivityIndicatorView *activityIndicatorView;
}

- (IBAction)buttonPress:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)goForward:(id)sender;
- (void)loadWebPageWithString:(NSString*)urlString;

@end
