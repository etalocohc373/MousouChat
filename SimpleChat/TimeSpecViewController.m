//
//  TimeSpecViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/12/14.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "TimeSpecViewController.h"
#import "KeywordData.h"

@interface TimeSpecViewController ()

@end

@implementation TimeSpecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *d = [NSDate dateWithTimeIntervalSinceNow:60 * 5];
    [datePicker setDate:d animated:NO];
    [self dateChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)dateChanged{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
   /*
    if([store boolForKey:@"editKeyword"]){
        NSArray *talks = [store objectForKey:@"talks"];
        NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
        NSData *data = (NSData *)[store objectForKey:key];
        NSMutableArray *_keywordDatas = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
        
        KeywordData *keywordData = [_keywordDatas objectAtIndex:[store integerForKey:@"selecteduser"]];
        keywordData.sendDate = datePicker.date;
        data = [NSKeyedArchiver archivedDataWithRootObject:_keywordDatas];
        [store setObject:data forKey:key];
    }else{*/
    
    /*if([datePicker.date compare:[NSDate date]] != NSOrderedDescending){
        [self showError];
        
        NSDate *d = [NSDate dateWithTimeIntervalSinceNow:60 * 5];
        [datePicker setDate:d animated:YES];
    }*/
    
    [store setObject:datePicker.date forKey:@"keywordDate"];
    [store synchronize];
}

-(IBAction)repeatChanged{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    /*if([store boolForKey:@"editKeyword"]){
        NSArray *talks = [store objectForKey:@"talks"];
        NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
        NSData *data = (NSData *)[store objectForKey:key];
        NSMutableArray *_keywordDatas = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
        
        KeywordData *keywordData = [_keywordDatas objectAtIndex:[store integerForKey:@"selecteduser"]];
        keywordData.doRepeat = doRepeat.on;
        data = [NSKeyedArchiver archivedDataWithRootObject:_keywordDatas];
        [store setObject:data forKey:key];
    }else{*/
    [store setBool:doRepeat.on forKey:@"keywordDoRepeat"];
    [store synchronize];
}

/*-(void)showError{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"設定時刻が不適切です" message:@"現在時刻より後にしてください" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}*/


@end
