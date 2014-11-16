//
//  ViewController.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/05/05.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ChatController.h"


@interface ViewController : UIViewController <ChatControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    IBOutlet UITableView *tv;
    UISearchBar *searchBar;
    
    int hantei;
    int alertRow;
    
    BOOL searching;
    BOOL alert;
    
    NSArray *users;
    NSArray *userimages;
    
    NSMutableArray *searchArray;
    NSMutableArray *searchArrayImg;
    
    NSMutableArray *notReadRows;
    NSMutableArray *talks;
    NSMutableArray *images;
    
    NSArray *keyword;
    NSArray *reply;
    
    NSUserDefaults *store;
}

@property (strong, nonatomic) ChatController * chatController;

/*!
 To set the background
 */
@property (strong, nonatomic) UIImageView * backgroundImg;

@end
