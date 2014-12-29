//
//  EditFriendViewController.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/09/18.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditFriendViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UIBarButtonItem *deleteBtn;
    
    NSMutableArray *_userDatas;
    NSMutableArray *talks;
    NSMutableArray *selectedRow;
}

@end
