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
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 325, 320, 162)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.minimumDate = [NSDate date];
    
    [self.view addSubview:datePicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


@end
