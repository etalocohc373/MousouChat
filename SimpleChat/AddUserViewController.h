//
//  AddUserViewController.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/05/05.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import "CoreImageHelper.h"

@interface AddUserViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIActionSheetDelegate>{
    IBOutlet UITextField *tf;
    IBOutlet UITextView *tv;
    IBOutlet UIBarButtonItem *done;
    IBOutlet UIImageView *imgView;
}

@end
