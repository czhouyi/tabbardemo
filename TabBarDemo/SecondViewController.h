//
//  SecondViewController.h
//  TabBarDemo
//
//  Created by Chuanzhou Yi on 2/7/14.
//  Copyright (c) 2014 Chuanzhou Yi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "PassValueDelegate.h"

@interface SecondViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, PassValueDelegate>
{
    IBOutlet UITableView *table;
    IBOutlet UISearchBar *search;
    NSDictionary *allNames;
    NSMutableDictionary *names;
    NSMutableArray *keys;
    sqlite3 *db;
}

@property (nonatomic, retain) UITableView *table;
@property (nonatomic, retain) UISearchBar *search;
@property (nonatomic, retain) NSDictionary *allNames;
@property (nonatomic, retain) NSMutableDictionary *names;
@property (nonatomic, retain) NSMutableArray *keys;

- (void) resetSearch;

- (void) handleSearchForTerm:(NSString *) searchTerm;

-(void)execSql:(NSString *)sql;


@end
