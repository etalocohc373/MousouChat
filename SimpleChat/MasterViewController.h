//
//  MasterViewController.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/05/04.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CustomToolBar.h"

@interface MasterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{
    IBOutlet UITableView *tv;
    CustomToolBar *customBar;
    
    UIBarButtonItem *back;
    
    NSMutableArray *keyword;
    NSMutableArray *reply;
    NSArray *talks;
    NSArray *_cellDataArray;
    
    NSIndexPath *sharePath;
    
    int rows;
    
    BOOL editing;
}

@end
