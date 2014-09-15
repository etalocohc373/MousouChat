//
//  ViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/05/05.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "ViewController.h"

#import <AudioToolbox/AudioServices.h>

#define SCREEN_HEIGHT [UIScreen mainScreen].applicationFrame.size.height

@interface ViewController ()

@end

@implementation ViewController

/*- (id)initWithStyle:(UITableViewStyle)style
 {
 self = [super initWithStyle:style];
 if (self) {
 // Custom initialization
 }
 return self;
 }*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self back];
    
    /*NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
     [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];*/
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    NSArray *mar3 = [store objectForKey:@"talks"];
    
    talks = [NSMutableArray array];
    if(mar3) talks = [mar3 mutableCopy];
    
    users = [NSArray arrayWithArray:[store objectForKey:@"users"]];
    
    userimages = [NSArray arrayWithArray:[store objectForKey:@"pimages"]];
    
    mar3 = [store objectForKey:@"talkimages"];
    
    if([store integerForKey:@"addtalk"]){
        [talks addObject:[users objectAtIndex:[store integerForKey:@"addtalk"] - 1]];
        [images addObject:[userimages objectAtIndex:[store integerForKey:@"addtalk"] - 1]];
        [store setInteger:0 forKey:@"addtalk"];
        [store setObject:talks forKey:@"talks"];
        [store setObject:images forKey:@"talkimages"];
    }else{
        images = [NSMutableArray array];
        if(mar3) images = [mar3 mutableCopy];
    }
    
    [store setFloat:0.1 forKey:@"kidokuDelay"];
    
    [store synchronize];
    [tv reloadData];
    
    notReadRows = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"notReadRows"]];
    if(!notReadRows) notReadRows = [NSMutableArray array];
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
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [tv registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    tv.delegate = self;
    tv.dataSource = self;
    
    tv.rowHeight = 70.0;
    
    self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
    
    searchArray = [NSMutableArray array];
    searchArrayImg = [NSMutableArray array];
    
    searchBar = [[UISearchBar alloc] init];
    searchBar.barTintColor = [UIColor purpleColor];
    searchBar.placeholder = @"トークを検索";
    searchBar.delegate = self;
    [searchBar sizeToFit];
    
    tv.tableHeaderView = searchBar;
}


#pragma mark CHAT CONTROLLER DELEGATE

- (void) chatController:(ChatController *)chatController didSendMessage:(NSMutableDictionary *)message {
    // Messages come prepackaged with the contents of the message and a timestamp in milliseconds
    NSLog(@"Message Contents: %@", message[kMessageContent]);
    NSLog(@"Timestamp: %@", message[kMessageTimestamp]);
    
    // Evaluate or add to the message here for example, if we wanted to assign the current userId:
    message[@"sentByUserId"] = @"currentUserId";
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"nothenshin"];
    
    //既読遅れ
    float kidokuDelay = arc4random()% 5 + 5;
    NSLog(@"delay: %.0f", kidokuDelay);
    
    [[NSUserDefaults standardUserDefaults] setFloat:kidokuDelay forKey:@"kidokuDelay"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    message[kMessageRuntimeSentBy] = @"0";
    
    // Must add message to controller for it to show
    [_chatController addNewMessage:message];
    
    NSString *str = message[@"content"];
    
    NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selecteduser"]]];
    keyword = [NSDictionary new];
    if([[NSUserDefaults standardUserDefaults] objectForKey:key]) keyword = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    //キーワード判定
    if([keyword count] != 0){
        NSArray *hoge = [NSArray arrayWithArray:[keyword allKeys]];
        for (int i = 0; i < [keyword count]; i++) {
            NSRange range = [str rangeOfString:[hoge objectAtIndex:i]];
            if (range.location != NSNotFound) {
                float delay = arc4random()% 5 + 5;
                
                [self performSelector:@selector(henshin) withObject:nil afterDelay:delay + kidokuDelay];
                
                hantei = i;
                
                NSArray *hoge = [NSArray arrayWithArray:[keyword allKeys]];
                NSString *str = [NSString stringWithFormat:@"%@: %@", [talks objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selecteduser"]], [keyword objectForKey:[hoge objectAtIndex:hantei]]];
                
                [self localNotify:str withDelay:delay + [[NSUserDefaults standardUserDefaults] floatForKey:@"kidokuDelay"]];
                
                break;
            }
        }
    }
}


-(void)henshin{//返信させる
    NSArray *hoge = [NSArray arrayWithArray:[keyword allKeys]];
    NSString *str = [keyword objectForKey:[hoge objectAtIndex:hantei]];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"henshin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary * newMessageOb = [NSMutableDictionary new];
    newMessageOb[kMessageContent] = str;
    newMessageOb[kMessageTimestamp] = [NSString stringWithFormat:@"%f",[[NSDate new] timeIntervalSince1970] * 1000];;
    
    newMessageOb[@"sentByUserId"] = @"currentUserId";
    
    newMessageOb[kMessageRuntimeSentBy] = @"1";
    
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
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"controllerOpen"]){
        alert = YES;
        alertRow = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"selecteduser"];
        [tv reloadData];
        
        [notReadRows addObject:[NSNumber numberWithInt:alertRow]];
        [[NSUserDefaults standardUserDefaults] setObject:notReadRows forKey:@"notReadRows"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    for (UILabel *subview in [cell.contentView subviews]) [subview removeFromSuperview];
    
    for (UIImageView *img in [cell.contentView subviews]) [img removeFromSuperview];
    
    // Configure the cell...
    
    UIImageView *alertImg = [[UIImageView alloc] initWithFrame:CGRectMake(280, 22.5, 25, 25)];
    alertImg.image = [UIImage imageNamed:@"badge_1.png"];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if(alert && indexPath.row == alertRow){
        [cell.contentView addSubview:alertImg];
        AudioServicesPlaySystemSound(1000);
    }else if([notReadRows containsObject:[NSNumber numberWithInt:indexPath.row]]){
        [cell.contentView addSubview:alertImg];
    }else cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    alert = NO;
    
    UIImage *hoge;
    NSString *key;
    
    UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 200, 30)];
    mainLabel.font = [UIFont systemFontOfSize:18];
    
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, 200, 30)];
    subLabel.textColor = [UIColor lightGrayColor];
    subLabel.font = [UIFont systemFontOfSize:15];
    
    if(!searching){//検索中でない
        mainLabel.text = [talks objectAtIndex:indexPath.row];//トーク相手
        
        key = [NSString stringWithFormat:@"message%@", [talks objectAtIndex:indexPath.row]];
        
        hoge = [[UIImage alloc] initWithData:[images objectAtIndex:indexPath.row]];//トプ画
    }else{//検索中
        mainLabel.text = [searchArray objectAtIndex:indexPath.row];
        
        key = [NSString stringWithFormat:@"message%@", [searchArray objectAtIndex:indexPath.row]];
        
        hoge = [[UIImage alloc] initWithData:[searchArrayImg objectAtIndex:indexPath.row]];
    }
    
    NSArray *hogeArray = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:key]]];
    
    NSDictionary *dic;
    
    if(hogeArray.count != 0) dic = [[NSDictionary alloc] initWithDictionary:[hogeArray objectAtIndex:hogeArray.count - 1]];
    
    subLabel.text = dic[@"content"];
    if(!subLabel.text) subLabel.text = @"トーク内容がまだありません";
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    imgView.image = hoge;
    
    [cell.contentView addSubview:mainLabel];
    [cell.contentView addSubview:subLabel];
    [cell.contentView addSubview:imgView];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [talks removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:talks forKey:@"talks"];
        
        NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:indexPath.row]];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary new] forKey:key];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    
    [store setInteger:indexPath.row forKey:@"selecteduser"];
    
    if([notReadRows containsObject:[NSNumber numberWithInt:indexPath.row]]){
        [notReadRows removeObject:[NSNumber numberWithInt:indexPath.row]];
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
    for (int i = 0; i < users.count; i++) {
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

@end
