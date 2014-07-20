//
//  MasterViewController.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/05/04.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MasterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *tv;
    IBOutlet UIToolbar *tb;
    
    UIBarButtonItem *back;
    
    NSMutableDictionary *keyword;
    NSArray *talks;
    
    int rows;
    
    BOOL editing;
}

@end
