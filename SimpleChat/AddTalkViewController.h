//
//  AddTalkViewController.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/07/19.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTalkViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *images;
    NSArray *talks;
    NSArray *_userDatas;
}

@end
