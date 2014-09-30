//
//  EditProfileViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/07/20.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"editprof"]) {
        case 0:
            self.title = @"名前";
            break;
            
        default:
            self.title = @"自己紹介";
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)done{
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"editprof"]) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setObject:tf.text forKey:@"myname"];
            break;
            
        default:
            [[NSUserDefaults standardUserDefaults] setObject:tf.text forKey:@"aboutme"];
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
