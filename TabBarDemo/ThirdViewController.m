//
//  ThirdViewController.m
//  TabBarDemo
//
//  Created by Chuanzhou Yi on 2/7/14.
//  Copyright (c) 2014 Chuanzhou Yi. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadWebPageWithString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

-(IBAction)buttonPress:(id)sender
{
    [textField resignFirstResponder];
    if ([textField.text length] > 0 && ![textField.text hasPrefix:@"http://"]) {
        NSMutableString *text = [NSMutableString stringWithString:@"http://"];
        [text appendString:textField.text];
        [textField setText:text];
    }
    [self loadWebPageWithString:textField.text];
    
}

- (void)goBack:(id)sender
{
    if ([webView canGoBack]) {
        [webView goBack];
    }
}

-(void)goForward:(id)sender
{
    if ([webView canGoForward]) {
        [webView goForward];
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicatorView startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicatorView stopAnimating];
    NSString *currentURL = webView.request.URL.absoluteString;
    [textField setText:currentURL];
    [goForward setEnabled:[webView canGoForward]];
    [goBack setEnabled:[webView canGoBack]];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([error code] == NSURLErrorCancelled) {
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
    [alertView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicatorView setCenter:self.view.center];
    [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:activityIndicatorView];
    textField.text = @"http://www.baidu.com";
    [self buttonPress:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
