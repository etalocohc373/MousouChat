//
//  FriendsViewController.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/07/19.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"

@interface FriendsViewController : UITableViewController<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UIBarButtonItem *editBtn;
    
    NSMutableArray *users;
    NSMutableArray *images;
    NSMutableArray *intros;
    NSMutableArray *talks;
    
    NSMutableArray *searchArray;
    NSMutableArray *searchArrayIntros;
    NSMutableArray *searchArrayImg;
    
    NSIndexPath *deletepath;
    
    BOOL searching;
}

@end
