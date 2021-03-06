//
//  SettingViewController.m
//  TextSample
//
//  Created by Minami Sophia Aramaki on 2013/10/20.
//  Copyright (c) 2013年 Minami Sophia Aramaki. All rights reserved.
//

#import "SettingViewController.h"
#import "TimeSpecViewController.h"
#import "ChatController.h"
#import "NavigationBarTextColor.h"
#import "KeywordData.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize tf;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    edit = [store boolForKey:@"editKeyword"];
    
    [store setBool:NO forKey:@"editKeyword"];
    [store synchronize];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.allowsSelection = NO;
        
    [tf becomeFirstResponder];
    
    talks = [NSArray arrayWithArray:[store objectForKey:@"talks"]];
    
    _keywordDatas = [NSMutableArray array];
    
    NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
    if([store objectForKey:key]){
        NSData *data = (NSData *)[store objectForKey:key];
        _keywordDatas = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    }
    
    [NavigationBarTextColor setNavigationTitleColor:self.navigationItem withString:@"キーワード追加"];
    
    if(edit){
        KeywordData *keywordData = [[KeywordData alloc] init];
        if(_keywordDatas.count) keywordData = [_keywordDatas objectAtIndex:[store integerForKey:@"selectedrow"]];
        
        [NavigationBarTextColor setNavigationTitleColor:self.navigationItem withString:@"キーワード編集"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"MM-dd HH:mm";
        
        tf.text = keywordData.keyword;
        tf2.text = keywordData.reply;
        timeLabel.text = [df stringFromDate:keywordData.sendDate];
        timeSpec.on = keywordData.setTime;
        
        tf.enabled = !timeSpec.on;
        
        [store setObject:keywordData.sendDate forKey:@"keywordDate"];
        [store setBool:keywordData.doRepeat forKey:@"keywordDoRepeat"];
        [store synchronize];
    }
    
    /*[keyword removeAllObjects];
    [word removeAllObjects];
    
    [store setObject:keyword forKey:@"keywords"];
    [store setObject:word forKey:@"words"];
    [store synchronize];*/
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    
    KeywordData *keywordData = [[KeywordData alloc] init];
    if(_keywordDatas.count) keywordData = [_keywordDatas objectAtIndex:[store integerForKey:@"selectedrow"]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM-dd HH:mm";
    
    
    if(keywordData.sendDate) timeLabel.text = [df stringFromDate:keywordData.sendDate];
    else if([store objectForKey:@"keywordDate"]) timeLabel.text = [df stringFromDate:[store objectForKey:@"keywordDate"]];
    else timeLabel.text = @"";
    
    [self timeSpecChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 30;
            break;
            
        default:
            return 20;
            break;
    }
}

/*-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index: %@", indexPath);
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:2]])
        return indexPath;
    else
        return indexPath;
}*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 3){
        TimeSpecViewController *secondVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"time"];
        [self.navigationController pushViewController:secondVC animated:YES];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}*/

-(IBAction)timeSpecChanged{
    if(timeSpec.on && [timeLabel.text isEqualToString:@""]) done.enabled = NO;
    else[self hantei];
    
    tf.enabled = !timeSpec.on;
}

-(IBAction)dainyu{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];

    BOOL chofuku = NO;
    
    for (int i = 0; i < _keywordDatas.count; i++) {
        KeywordData *keywordData = [_keywordDatas objectAtIndex:i];
        if([keywordData.keyword isEqualToString:tf.text]) chofuku = YES;
    }
    
    if(edit){
        if(chofuku && ![tf.text isEqualToString:((KeywordData *)[_keywordDatas objectAtIndex:[store integerForKey:@"selectedrow"]]).keyword]){
            NSLog(@"keyworddata: %@", [_keywordDatas objectAtIndex:[store integerForKey:@"selectedrow"]]);
            [self showError];
        }else{
            int editRow = (int)[store integerForKey:@"selectedrow"];
            
            KeywordData *keywordData = [_keywordDatas objectAtIndex:editRow];
            
            BOOL setTime = keywordData.setTime;
            NSDate *sendDate = keywordData.sendDate;
            
            keywordData.keyword = tf.text;
            keywordData.reply = tf2.text;
            keywordData.sendDate = [store objectForKey:@"keywordDate"];
            keywordData.doRepeat = [store objectForKey:@"keywordDoRepeat"];
            keywordData.setTime = timeSpec.on;
            
            [_keywordDatas replaceObjectAtIndex:editRow withObject:keywordData];
            NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_keywordDatas];
            [store setObject:data forKey:key];
            
            [store setBool:NO forKey:@"editKeyword"];
            [store synchronize];
            
            ChatController *hoge;
            if(setTime && !timeSpec.on){
                [ChatController cancelPreviousPerformRequestsWithTarget:hoge selector:@selector(henshin:) object:nil];
            }
            
            if(!setTime && timeSpec.on){
                [self setDicForKeywordData:keywordData];
            }
            
            if(sendDate != keywordData.sendDate && timeSpec.on){
                [ChatController cancelPreviousPerformRequestsWithTarget:hoge selector:@selector(henshin:) object:nil];
                [self setDicForKeywordData:keywordData];
            }
            
            [self back];
        }
    }else{
        if(!chofuku){
            KeywordData *keywordData = [[KeywordData alloc] init];
            
            keywordData.keyword = tf.text;
            keywordData.reply = tf2.text;
            keywordData.sendDate = [store objectForKey:@"keywordDate"];
            keywordData.doRepeat = [store objectForKey:@"keywordDoRepeat"];
            keywordData.setTime = timeSpec.on;
            
            [store setObject:nil forKey:@"keywordDate"];
            [store setBool:NO forKey:@"keywordDoRepeat"];
            
            [_keywordDatas addObject:keywordData];
            
            NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_keywordDatas];
            [store setObject:data forKey:key];
            
            [self setDicForKeywordData:keywordData];
            
            [store synchronize];
            
            [self back];
        }else{
            [self showError];
        }
    }
    
    [store removeObjectForKey:@"keywordDate"];
    [store removeObjectForKey:@"keywordDoRepeat"];
    [store synchronize];
}

-(void)setDicForKeywordData:(KeywordData *)keywordData{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    
    NSString *userName = [talks objectAtIndex:[store integerForKey:@"selecteduser"]];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if([store objectForKey:@"unsentDic"]) dic = [store objectForKey:@"unsentDic"];
    
    NSMutableArray *mar = [NSMutableArray array];
    if([dic objectForKey:userName]) mar = [[dic objectForKey:userName] mutableCopy];
    
    NSString *str = [NSString stringWithFormat:@"%@: %@", userName, keywordData.reply];
    
    if(keywordData.setTime){
        [self localNotify:str withDelay:[keywordData.sendDate timeIntervalSinceDate:[NSDate date]]];
        
        NSDictionary *timeDic = [NSDictionary dictionaryWithObject:keywordData.sendDate forKey:keywordData.reply];
        [mar addObject:timeDic];
        
        [dic setObject:mar forKey:userName];
        [store setObject:dic forKey:@"unsentDic"];
    }else if([dic objectForKey:userName]){
        [self cancelNotification:str];
        
        NSDictionary *timeDic = [NSDictionary dictionaryWithObject:keywordData.sendDate forKey:keywordData.reply];
        [mar removeObjectAtIndex:[mar indexOfObject:timeDic]];
        
        [dic setObject:mar forKey:userName];
        [store setObject:dic forKey:@"unsentDic"];
    }
    
    [store synchronize];
}

-(IBAction)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)hantei{
    if(![tf.text isEqualToString:@""] && ![tf2.text isEqualToString:@""]) done.enabled = YES;
    else done.enabled = NO;
}

-(void)showError{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"キーワードが重複しています" message:@"キーワードを変更してください" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)localNotify:(NSString *)message withDelay:(float)delay{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:delay];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = message;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    // 通知の登録
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)cancelNotification:(NSString *)notificationID
{
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *row in notificationArray) {
        if([[row.userInfo valueForKey:@"EventKey"] isEqualToString:notificationID]) {
            [[UIApplication sharedApplication] cancelLocalNotification:row];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 23)];
    headerView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.945 alpha:1.0];
    tableView.sectionHeaderHeight = headerView.frame.size.height;
    //235 235 241
    
    UILabel *label;
    switch (section) {
        case 0:
            label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, headerView.frame.size.width - 10, 23)];
            label.text = @"キーワード";
            break;
            
        case 1:
            label = [[UILabel alloc] initWithFrame:CGRectMake(12, -2, headerView.frame.size.width - 12, 23)];
            label.text = @"返答";
            break;
            
        default:
            break;
    }
    
    
    label.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN" size:12.5];
    label.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    
    [headerView addSubview:label];
    
    return headerView;
}

@end
