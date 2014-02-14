//
//  SecondViewController.m
//  TabBarDemo
//
//  Created by Chuanzhou Yi on 2/7/14.
//  Copyright (c) 2014 Chuanzhou Yi. All rights reserved.
//

#import "SecondViewController.h"
#import "NSDictionary-MutableDeepCopy.h"
#import "ContactViewController.h"

#define DBNAME  @"contact.sqlite"
#define TABLENAME   @"contact"
#define NAME    @"name"

@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize names;
@synthesize keys;
@synthesize table;
@synthesize search;
@synthesize allNames;

-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作数据失败!");
    }
}

-(void)resetSearch
{
    self.names = [self.allNames mutableDeepCopy];
    NSMutableArray *keyArray = [[NSMutableArray alloc]init];
    [keyArray addObjectsFromArray:[[self.allNames allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    self.keys = keyArray;
    
}

-(void)handleSearchForTerm:(NSString *)searchTerm
{
    NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
    [self resetSearch];
    
    for (NSString *key in self.keys) {
        NSMutableArray *array = [names valueForKey:key];
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        for (NSDictionary *contact in array) {
            if ([[contact objectForKey:@"name"] rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location == NSNotFound) {
                [toRemove addObject:contact];
            }
        }
        
        if ([array count] == [toRemove count]) {
            [sectionsToRemove addObject:key];
        }
        
        [array removeObjectsInArray:toRemove];
    }
    [self.keys removeObjectsInArray:sectionsToRemove];
    [table reloadData];
}

- (void)loadDataFromSqlite
{
    NSString *sqlQuery = @"SELECT id, name FROM contact";
    sqlite3_stmt * statement;
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
    
    // 查询该表所有数据，加载到mutableDict里
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int key = sqlite3_column_int(statement, 0);
            NSString *keyStr = [NSString stringWithFormat:@"%d", key];
            
            char *name = (char*)sqlite3_column_text(statement, 1);
            NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
            NSDictionary *contact = [[NSDictionary alloc]initWithObjectsAndKeys:keyStr, @"id", nsNameStr, @"name", nil];
            
            NSString *firstChar = [[nsNameStr substringToIndex:1] uppercaseString];
            
            if ([mutableDict objectForKey:firstChar]) {
                NSMutableArray *arrays = [mutableDict objectForKey:firstChar];
                [arrays addObject:contact];
            } else {
                NSMutableArray *arrays = [[NSMutableArray alloc]init];
                [mutableDict setObject:arrays forKey:firstChar];
                [arrays addObject:contact];
            }
        }
    }
    
    //NSString *path = [[NSBundle mainBundle]pathForResource:@"sortednames" ofType:@"plist"];
    //NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:mutableDict];
    self.allNames = dict;
}

- (void)viewDidLoad
{
    //    [super viewDidLoad];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS contact (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)";
    [self execSql:sqlCreateTable];
    
    [self loadDataFromSqlite];
    
    [self resetSearch];
    search.autocapitalizationType = UITextAutocapitalizationTypeNone;
    search.autocorrectionType = UITextAutocorrectionTypeNo;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [keys count] > 0?[keys count] : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if ([keys count] == 0) {
        return 0;
    }
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    return [nameSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    
    static NSString *ContactCellIdentifier = @"ContactCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContactCellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [[nameSection objectAtIndex:row] objectForKey:@"name"];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([keys count] == 0) {
        return @"";
    }
    NSString *key = [keys objectAtIndex:section];
    return key;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [search resignFirstResponder];
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ContactSegueIdentifier" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
//    if (scrollView.contentOffset.y > 0) {
//        search.hidden = YES;
//    } else {
//        search.hidden = NO;
//    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue isMemberOfClass:[IBCellFlipSegue class]])
//    {
//        IBCellFlipSegue *cellFlipSegue = (IBCellFlipSegue *)segue;
//        cellFlipSegue.selectedCell = sender;
//        cellFlipSegue.flipAxis = FlipAxisVertical;
//    }
    if ([sender isMemberOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [table indexPathForCell:cell];
        NSUInteger section = [indexPath section];
        NSUInteger row = [indexPath row];
        
        NSString *key = [keys objectAtIndex:section];
        NSArray *nameSection = [names objectForKey:key];
        ContactViewController *contactViewController = [segue destinationViewController];
        contactViewController.delegate = self;
        
        if ([contactViewController respondsToSelector:@selector(setDict:)]) {
            [contactViewController setValue:[nameSection objectAtIndex:row] forKey:@"dict"];
        }
        
    } else {
        ContactViewController *contactViewController = [segue destinationViewController];
        contactViewController.delegate = self;
    }
}

-(void)setValue:(NSDictionary *)dict
{
    if ([[dict objectForKey:@"id"] length] == 0) {
        NSString *sql = [NSString stringWithFormat:
                         @"INSERT INTO %@ (%@) VALUES ('%@')",
                         TABLENAME, NAME, [dict objectForKey:@"name"]];
        [self execSql:sql];
    } else {
        NSString *sql = [NSString stringWithFormat:
                         @"update %@ set %@='%@' where id='%@'",
                         TABLENAME, NAME, [dict objectForKey:@"name"], [dict objectForKey:@"id"]];
        [self execSql:sql];
    }
    [self loadDataFromSqlite];
    [self resetSearch];
    [table reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0) {
        [self resetSearch];
        [table reloadData];
        return;
    }
    [self handleSearchForTerm:searchText];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    search.text = @"";
    [self resetSearch];
    [table reloadData];
    [searchBar resignFirstResponder];
//    searchBar.hidden = YES;
}


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return keys;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = [searchBar text];
    [self handleSearchForTerm:searchTerm];
}

@end
