//
//  PassValueDelegate.h
//  TabBarDemo
//
//  Created by Chuanzhou Yi on 2/14/14.
//  Copyright (c) 2014 Chuanzhou Yi. All rights reserved.
//
#import <Foundation/Foundation.h>
@protocol PassValueDelegate <NSObject>
-(void)setValue:(NSDictionary *)dict;
@end
@interface PassValueDelegate : NSObject
@end