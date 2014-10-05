//
//  SettingViewController.h
//  TextSample
//
//  Created by Minami Sophia Aramaki on 2013/10/20.
//  Copyright (c) 2013年 Minami Sophia Aramaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol SettingViewControllerDelegate;

@interface SettingViewController : UITableViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITextField *tf2;
    IBOutlet UIBarButtonItem *done;
    
    NSMutableArray *keyword;
    NSMutableArray *reply;
    NSArray *talks;
    
    int kaisu;
}

@property(weak,nonatomic) IBOutlet UITextField *tf;
@property(weak,nonatomic) id<SettingViewControllerDelegate> delegate;

@end

@protocol SettingViewControllerDelegate <NSObject>

-(void)settingViewControllerDidFinish:(SettingViewController *)controller item:(NSString *)item;

@end
