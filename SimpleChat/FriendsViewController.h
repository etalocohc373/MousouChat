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
    NSMutableArray *users;
    NSMutableArray *images;
    NSMutableArray *talks;
    
    NSIndexPath *deletepath;
    
    BOOL searching;
    
    NSMutableArray *searchArray;
    NSMutableArray *searchArrayImg;
}

@end
