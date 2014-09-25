//
//  FriendsViewController.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/07/19.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"

@interface FriendsViewController : UITableViewController<UISearchBarDelegate>{
    IBOutlet UIBarButtonItem *editBtn;
    
    NSMutableArray *users;
    NSMutableArray *images;
    NSMutableArray *talks;
    NSMutableArray *searchArray;
    NSMutableArray *searchArrayImg;
    
    NSIndexPath *deletepath;
    
    BOOL searching;
}

@end
