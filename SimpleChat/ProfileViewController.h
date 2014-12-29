//
//  ProfileViewController.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/05/06.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

#import "CoreImageHelper.h"
#import "EditProfileViewController.h"

@interface ProfileViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIImageView *imgView;
    IBOutlet UILabel *name;
    IBOutlet UILabel *about;
    
    NSMutableArray *_userDatas;
}

@end
