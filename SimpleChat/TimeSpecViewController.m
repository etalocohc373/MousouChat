//
//  TimeSpecViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/12/14.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "TimeSpecViewController.h"

@interface TimeSpecViewController ()

@end

@implementation TimeSpecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dateChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)dateChanged{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    //[store setObject:<#(id)#> forKey:@"timeSpec"];
}

-(void)showError{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"設定時刻が不適切です" message:@"現在時刻より後にしてください" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


@end
