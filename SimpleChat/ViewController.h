//
//  ViewController.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/05/05.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChatController.h"

@interface ViewController : UIViewController <ChatControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    IBOutlet UITableView *tv;
    
    NSArray *users;
    NSMutableArray *talks;
    NSMutableArray *images;
    NSArray *userimages;
    NSDictionary *keyword;
    
    int hantei;
    
    BOOL searching;
    
    NSMutableArray *searchArray;
    NSMutableArray *searchArrayImg;
}

@property (strong, nonatomic) ChatController * chatController;

/*!
 To set the background
 */
@property (strong, nonatomic) UIImageView * backgroundImg;

@end
