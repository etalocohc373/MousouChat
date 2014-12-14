//
//  TimeSpecViewController.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/12/14.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeSpecViewController : UITableViewController<UITableViewDataSource>{
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UISwitch *doRepeat;
}

@end
