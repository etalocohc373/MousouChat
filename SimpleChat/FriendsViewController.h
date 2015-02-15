//
//  FriendsViewController.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/07/19.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"
#import "RNBlurModalView.h"
#import "ChatController.h"

@interface FriendsViewController : UITableViewController<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UIBarButtonItem *editBtn;
    NSMutableArray *talks;
    
    NSMutableArray *searchArray;
    NSMutableArray *searchArrayIntros;
    NSMutableArray *searchArrayImg;
    
    NSMutableArray *_userDatas;
    
    NSIndexPath *deletepath;
    NSIndexPath *editPath;
    
    RNBlurModalView *modal;
    
    BOOL searching;
}

@property (strong, nonatomic) ChatController * chatController;

@end
