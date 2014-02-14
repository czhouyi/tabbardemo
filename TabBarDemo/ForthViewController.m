//
//  ForthViewController.m
//  TabBarDemo
//
//  Created by Chuanzhou Yi on 2/13/14.
//  Copyright (c) 2014 Chuanzhou Yi. All rights reserved.
//

#import "ForthViewController.h"
#import "TimeTableViewController.h"

@interface ForthViewController ()

@end

@implementation ForthViewController
@synthesize webData;
@synthesize listData, dict;
@synthesize currDescription;
@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    //UIAlertViewStyleDefault 默认风格，无输入框
    //UIAlertViewStyleSecureTextInput 带一个密码输入框
    //UIAlertViewStylePlainTextInput 带一个文本输入框
    //UIAlertViewLoginAndPasswordInput 带一个文本输入框，一个密码输入框
    [alert show];
}

-(void)search:(id)sender
{
    [txtFrom resignFirstResponder];
    [txtTo resignFirstResponder];
    if ([txtFrom.text length] == 0 || [txtTo.text length] == 0) {
        NSString *string = [NSString stringWithFormat:@"出发和目的地不能为空"];
        
        [self showAlert:string];
        return;
    }
    if ([txtFrom.text isEqualToString:txtTo.text]) {
        NSString *string = [NSString stringWithFormat:@"出发和目的地不能相同"];
        
        [self showAlert:string];
        return;
    }
    self.listData = [[NSMutableArray alloc]init];
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getStationAndTimeByStationName xmlns=\"http://WebXml.com.cn/\">\n"
                             "<StartStation>%@</StartStation>\n"
                             "<ArriveStation>%@</ArriveStation>\n"
                             "<UserID></UserID>\n"
                             "</getStationAndTimeByStationName>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n" , @"上海", @"北京"];//txtFrom.text, txtTo.text];
    
    NSURL *url = [NSURL URLWithString:@"http://www.webxml.com.cn/WebServices/TrainTimeWebService.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://WebXml.com.cn/getStationAndTimeByStationName" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    //[theConnection start];
    
    if( theConnection )
    {
        self.webData = [NSMutableData data];
        NSLog(@"Problem");
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR with theConenction");
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"DONE. Received Bytes: %d", [webData length]);
    NSString *theXML = [[NSString alloc] initWithBytes:
                        [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    NSData *myData = [theXML dataUsingEncoding:NSUTF8StringEncoding];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:myData];
    
    // Don't forget to set the delegate!
    xmlParser.delegate = self;
    
    // Run the parser
    BOOL parsingResult = [xmlParser parse];
    
    if ([self.listData count] == 0) {
        NSString *string = [NSString stringWithFormat:@"未查询到结果，请重新填写出发和目的地"];
        
        [self showAlert:string];
    }
    
    [table reloadData];
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currDescription = elementName;
    if([elementName isEqual: @"TimeTable"]){
        self.dict = [NSMutableDictionary dictionaryWithCapacity:10];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.dict) {
        [self.dict setObject:string forKey:self.currDescription];
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqual: @"TimeTable"]){
        NSDictionary *fixdict = [[NSDictionary alloc] initWithDictionary:self.dict];
        [self.listData addObject:fixdict];
        
        [fixdict release];
        self.dict = nil;
    }
    //textFieldResult.text = curDescription;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    NSDictionary *curdict = [self.listData objectAtIndex:row];
    
    static NSString *TimeTableIdentifier = @"TimeTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TimeTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TimeTableIdentifier];
    }
    
    // Configure the cell...
    cell.text = [curdict objectForKey:@"TrainCode"];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@%@~%@%@",
                                   [curdict objectForKey:@"StartTime"],[curdict objectForKey:@"StartStation"],
                                   [curdict objectForKey:@"ArriveTime"],[curdict objectForKey:@"ArriveStation"]]];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:12];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[search resignFirstResponder];
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"TimeTableSegueIdentifier" sender:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isMemberOfClass:[NSIndexPath class]]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        NSUInteger row = [indexPath row];
        
        NSDictionary *curdict = [self.listData objectAtIndex:row];
        TimeTableViewController *timeTableViewController = [segue destinationViewController];
        
        if ([timeTableViewController respondsToSelector:@selector(setDict:)]) {
            [timeTableViewController setValue:curdict forKey:@"dict"];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
