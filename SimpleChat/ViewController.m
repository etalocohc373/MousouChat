//
//  ViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/05/05.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "ViewController.h"

#import <AudioToolbox/AudioServices.h>

#import "TalkTableViewCell.h"
#import "WSCoachMarksView.h"
#import "UserData.h"
#import "KeywordData.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].applicationFrame.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self back];
    
    NSLog(@"%@", self);
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    NSArray *mar3 = [store objectForKey:@"talks"];
    
    talks = [NSMutableArray array];
    if(mar3) talks = [mar3 mutableCopy];
    
    mar3 = [store objectForKey:@"talkimages"];
    
    if([store integerForKey:@"addtalk"]){
        NSData *data = (NSData *)[store objectForKey:@"userDatas"];
        _userDatas = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        
        UserData *userData = [_userDatas objectAtIndex:[store integerForKey:@"addtalk"] - 1];
        
        [talks addObject:userData.name];
        [images addObject:userData.image];
        [store setInteger:0 forKey:@"addtalk"];
        [store setObject:talks forKey:@"talks"];
        [store setObject:images forKey:@"talkimages"];
    }else{
        images = [NSMutableArray array];
        if(mar3) images = [mar3 mutableCopy];
    }
    
    [store setFloat:0.0 forKey:@"kidokuDelay"];
    
    [store synchronize];
    [tv reloadData];
    
    notReadRows = [NSMutableArray array];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"notReadRows"])
        notReadRows = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"notReadRows"]];
    
    tv.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

/*- (void) handleTap:(UITapGestureRecognizer *)tap {
 if (!_chatController) _chatController = [ChatController new];
 _chatController.delegate = self;
 _chatController.opponentImg = [UIImage imageNamed:@"tempUser.png"];
 [self presentViewController:_chatController animated:YES completion:nil];
 }*/

- (UIStoryboard *)getStoryBoard
{
    return self.storyboard;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back{
    /*UIEdgeInsets insets = self.tableView.contentInset;
     insets.top += 64;
     self.tableView.contentInset = insets;*/
    store = [NSUserDefaults standardUserDefaults];
    
    [tv registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    tv.delegate = self;
    tv.dataSource = self;
    tv.rowHeight = 70.f;
    [tv setSeparatorInset:UIEdgeInsetsZero];
    tv.bounces = NO;
    //tv.separatorColor = [UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:1.0];
    tv.separatorColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.227 green:0.114 blue:0.369 alpha:1.0];
    
    searchArray = [NSMutableArray array];
    searchArrayImg = [NSMutableArray array];
    
    searchBar = [[UISearchBar alloc] init];
    searchBar.barTintColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
    searchBar.placeholder = @"トークを検索";
    searchBar.delegate = self;
    [searchBar sizeToFit];
    //tv.tableHeaderView = searchBar;
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    
    [self createNavTitle:@"トーク"];
    
    UINib *nib = [UINib nibWithNibName:@"TalkTableViewCell" bundle:nil];
    [tv registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    [self.searchDisplayController.searchResultsTableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    if([self isFirstRun]) [self activateTutorial];
}

-(IBAction)edit{
    if(tv.editing) [tv setEditing:NO animated:YES];
    else [tv setEditing:YES animated:YES];
}


#pragma mark CHAT CONTROLLER DELEGATE

- (void) chatController:(ChatController *)chatController didSendMessage:(NSMutableDictionary *)message {
    // Messages come prepackaged with the contents of the message and a timestamp in milliseconds
    NSLog(@"Message Contents: %@", message[kMessageContent]);
    NSLog(@"Timestamp: %@", message[kMessageTimestamp]);
    
    // Evaluate or add to the message here for example, if we wanted to assign the current userId:
    message[@"sentByUserId"] = @"currentUserId";
    
    [store setBool:YES forKey:@"nothenshin"];
    
    //現在日時の取得
    NSDate *now = [NSDate date];
    message[@"daySent"] = now;
    //ここまで
    
    //既読遅れ
    float kidokuDelay = arc4random()% 5 + 5;
    NSLog(@"delay: %.0f", kidokuDelay);
    
    [store setFloat:kidokuDelay forKey:@"kidokuDelay"];
    [store synchronize];
    //ここまで
    
    message[kMessageRuntimeSentBy] = @"0";
    
    // Must add message to controller for it to show
    [_chatController addNewMessage:message];
    
    NSString *str = message[@"content"];
    
    NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
    _keywordDatas = [NSArray array];
    if([store objectForKey:key]){
        NSData *data = (NSData *)[store objectForKey:key];
        _keywordDatas = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    //キーワード判定
    if(_keywordDatas.count != 0){
        for (int i = 0; i < _keywordDatas.count; i++) {
            KeywordData *keywordData = [_keywordDatas objectAtIndex:i];
            
            NSRange range = [str rangeOfString:keywordData.keyword];
            if (range.location != NSNotFound) {
                float delay = arc4random()% 5 + 5;
                
                NSString *reply = ((KeywordData *)[_keywordDatas objectAtIndex:i]).reply;
                [self performSelector:@selector(henshin:) withObject:reply afterDelay:delay + kidokuDelay];
                
                hantei = i;
                
                NSString *str = [NSString stringWithFormat:@"%@: %@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]], keywordData.reply];
                
                [self localNotify:str withDelay:delay + [store floatForKey:@"kidokuDelay"]];
                
                break;
            }
        }
    }//ここまで
}

-(void)henshin:(NSString *)reply{//返信させる
    NSString *str = reply;

    [store setBool:YES forKey:@"henshin"];
    [store synchronize];
    
    NSMutableDictionary * newMessageOb = [NSMutableDictionary new];
    newMessageOb[kMessageContent] = str;
    newMessageOb[kMessageTimestamp] = [NSString stringWithFormat:@"%f",[[NSDate new] timeIntervalSince1970] * 1000];;
    
    newMessageOb[@"sentByUserId"] = @"currentUserId";
    
    newMessageOb[kMessageRuntimeSentBy] = @"1";
    
    //現在日時の取得
    NSDate *now = [NSDate date];
    
    newMessageOb[@"daySent"] = now;
    //ここまで
    
    NSMutableDictionary * attributes = [NSMutableDictionary new];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:15.0f];
    attributes[NSStrokeColorAttributeName] = [UIColor darkTextColor];
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithString:[newMessageOb objectForKey:kMessageContent]
                                                                   attributes:attributes];
    
    // Here's the maximum width we'll allow our outline to be // 260 so it's offset
    
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(260 - 22, 100000)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        context:nil];
    
    newMessageOb[kMessageSize] = [NSValue valueWithCGSize:rect.size];
    
    [_chatController addNewMessage:newMessageOb];
    
    /*if(talks.count > 1 && [store integerForKey:@"selecteduser"]){
        if(![[store objectForKey:@"controllerOpen"] isEqualToString:[talks objectAtIndex:(int)[store integerForKey:@"selecteduser"]]]){
            alert = YES;
            alertRow = (int)[store integerForKey:@"selecteduser"];
        }
        //[tv moveRowAtIndexPath:[NSIndexPath indexPathForRow:alertRow inSection:0] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        NSString *hoge = [talks objectAtIndex:0];
        [talks replaceObjectAtIndex:0 withObject:[talks objectAtIndex:alertRow]];
        [talks removeObjectAtIndex:alertRow];
        [talks insertObject:hoge atIndex:1];
        [store setObject:talks forKey:@"talks"];
        
        [notReadRows addObject:[talks objectAtIndex:0]];
        [store setObject:notReadRows forKey:@"notReadRows"];
        
        [store synchronize];
        
        [tv reloadData];
    }
    //}*/
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(!searching) return [talks count];
    else return [searchArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TalkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"TalkTableViewCell" owner:self options:nil];
        for(id oneObject in xib){
            if([oneObject isKindOfClass:[TalkTableViewCell class]]){
                cell = (TalkTableViewCell *) oneObject;
            }
        }
    }
    
    /*//重複ラベルの消去
     for (UILabel *subview in [cell.contentView subviews]) [subview removeFromSuperview];
     
     for (UIImageView *img in [cell.contentView subviews]) [img removeFromSuperview];
     //ここまで*/
    
    // Configure the cell...
    //アイコンバッジ作成
    UIImageView *alertImg = [[UIImageView alloc] initWithFrame:CGRectMake(280, 22.5, 25, 25)];
    alertImg.image = [UIImage imageNamed:@"badge_1.png"];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if(alert && !indexPath.row){
        [cell.contentView addSubview:alertImg];
        AudioServicesPlaySystemSound(1000);
        alert = NO;
    }else if(!searching && [notReadRows containsObject:[talks objectAtIndex:indexPath.row]]) [cell.contentView addSubview:alertImg];
    else if(searching && [notReadRows containsObject:[searchArray objectAtIndex:indexPath.row]]) [cell.contentView addSubview:alertImg];
    else [alertImg removeFromSuperview];
    //ここまで
    
    UIImage *hoge;
    NSString *key;
    
    
    if(!searching){//検索中でない
        cell.nameLabel.text = [talks objectAtIndex:indexPath.row];//トーク相手
        
        key = [NSString stringWithFormat:@"message%@", [talks objectAtIndex:indexPath.row]];
        
        hoge = [[UIImage alloc] initWithData:[images objectAtIndex:indexPath.row]];//トプ画
    }else{//検索中
        cell.nameLabel.text = [searchArray objectAtIndex:indexPath.row];
        
        key = [NSString stringWithFormat:@"message%@", [searchArray objectAtIndex:indexPath.row]];
        
        hoge = [[UIImage alloc] initWithData:[searchArrayImg objectAtIndex:indexPath.row]];
    }
    
    NSArray *hogeArray = [NSArray array];
    if([store objectForKey:key]) hogeArray = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[store objectForKey:key]]];
    
    ///最新トーク取得
    NSDictionary *dic = [NSDictionary new];
    
    if(hogeArray.count != 0) dic = [[NSDictionary alloc] initWithDictionary:[hogeArray objectAtIndex:hogeArray.count - 1]];
    
    cell.introLabel.text = dic[@"content"];
    
    if(!cell.introLabel.text) cell.introLabel.text = @"トーク内容がまだありません";
    
    //日付比較
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"MM/dd";
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc]init];
    df2.dateFormat = @"HH:mm";
    
    if ([[df stringFromDate:dic[@"daySent"]] isEqualToString:[df stringFromDate:[NSDate date]]]) cell.timeLabel.text = [df2 stringFromDate:dic[@"daySent"]];
    else cell.timeLabel.text = [df stringFromDate:dic[@"daySent"]];
    //ここまで
    ///ここまで
    
    cell.profileImgView.image = hoge;
    
    return cell;
}


#pragma mark - Table View Data Source

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [talks removeObjectAtIndex:indexPath.row];
        [store setObject:talks forKey:@"talks"];
        
        NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:indexPath.row]];
        [store setObject:nil forKey:key];
        
        [store synchronize];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [store setInteger:indexPath.row forKey:@"selecteduser"];
    
    if([notReadRows containsObject:[talks objectAtIndex:(int)indexPath.row]]){
        [notReadRows removeObject:[talks objectAtIndex:(int)indexPath.row]];
        [store setObject:notReadRows forKey:@"notReadRows"];
    }
    
    [store synchronize];
    
    if (!_chatController) _chatController = [ChatController new];
    _chatController.delegate = self;
    _chatController.opponentImg = [[UIImage alloc] initWithData:[images objectAtIndex:indexPath.row]];
    
    _chatController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:_chatController animated:YES];
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

-(void)searchBarTextDidBeginEditing:(UISearchBar *)search{
    [search showsCancelButton];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)search{
    for (int i = 0; i < _userDatas.count; i++) {
        NSRange range = [[talks objectAtIndex:i] rangeOfString:search.text];
        if (range.location != NSNotFound) {
            [searchArray addObject:[talks objectAtIndex:i]];
            [searchArrayImg addObject:[images objectAtIndex:i]];
        }
    }
    searching = YES;
    [tv reloadData];
    
    search.showsCancelButton = NO;
    [search resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)search{
    search.text = @"";
    
    searching = NO;
    [tv reloadData];
    
    search.showsCancelButton = NO;
    [search resignFirstResponder];
}

-(void)createNavTitle:(NSString *)title{
    UILabel* tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    tLabel.text = title;
    tLabel.textColor = [UIColor whiteColor];
    tLabel.backgroundColor = [UIColor clearColor];
    tLabel.textAlignment = NSTextAlignmentCenter;
    tLabel.adjustsFontSizeToFitWidth = YES;
    tLabel.font = [UIFont fontWithName:@"MS ゴシック" size:17];
    self.navigationItem.titleView = tLabel;
}

- (BOOL)isFirstRun
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *hoge = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"didRunArray"]];
    
    if ([hoge containsObject:@"ViewController"]) return NO;
    
    [hoge addObject:@"ViewController"];
    
    [userDefaults setObject:hoge forKey:@"didRunArray"];
    [userDefaults synchronize];
    
    return YES;
}

-(void)activateTutorial{
    NSArray *coachMarks = @[
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{271, 22},{40, 40}}],
                                @"caption": @"トークを追加"
                                }
                            ];
    WSCoachMarksView *coachMarksView = [[WSCoachMarksView alloc] initWithFrame:self.tabBarController.view.bounds coachMarks:coachMarks];
    [self.tabBarController.view addSubview:coachMarksView];
    [coachMarksView start];
}

@end
