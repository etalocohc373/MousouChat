//
//  ViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/05/05.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "ViewController.h"
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
    if(mar3){
        talks = [mar3 mutableCopy];
    }
    
    users = [NSArray arrayWithArray:[store objectForKey:@"users"]];
    
    userimages = [NSArray arrayWithArray:[store objectForKey:@"pimages"]];
    
    if([store integerForKey:@"addtalk"]){
        [talks addObject:[users objectAtIndex:[store integerForKey:@"addtalk"] - 1]];
        [images addObject:[userimages objectAtIndex:[store integerForKey:@"addtalk"] - 1]];
        [store setInteger:0 forKey:@"addtalk"];
        [store setObject:talks forKey:@"talks"];
    }else{images = [NSMutableArray array];
        if(mar3){
            images = [mar3 mutableCopy];
        }
    }
    
    mar3 = [store objectForKey:@"talkimages"];
    
    [store synchronize];
    [tv reloadData];
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
    
    NSLog(@"%@",keyword);
}


#pragma mark CHAT CONTROLLER DELEGATE

- (void) chatController:(ChatController *)chatController didSendMessage:(NSMutableDictionary *)message {
    // Messages come prepackaged with the contents of the message and a timestamp in milliseconds
    NSLog(@"Message Contents: %@", message[kMessageContent]);
    NSLog(@"Timestamp: %@", message[kMessageTimestamp]);
    
    // Evaluate or add to the message here for example, if we wanted to assign the current userId:
    message[@"sentByUserId"] = @"currentUserId";
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"nothenshin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Must add message to controller for it to show
    [_chatController addNewMessage:message];
    
    NSString *str = message[@"content"];
    
    NSString *key = [NSString stringWithFormat:@"keywords%d", [[NSUserDefaults standardUserDefaults] integerForKey:@"selecteduser"]];
    keyword = [NSDictionary new];
    if([[NSUserDefaults standardUserDefaults] objectForKey:key]) keyword = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    NSLog(@"%@", keyword);
    
    if([keyword count] != 0){
        NSArray *hoge = [NSArray arrayWithArray:[keyword allKeys]];
        for (int i = 0; i < [keyword count]; i++) {
            NSRange range = [str rangeOfString:[hoge objectAtIndex:i]];
            if (range.location != NSNotFound) {
                [self performSelector:@selector(henshin) withObject:nil afterDelay:arc4random()%1+1];
                hantei = i;
                break;
            }
        }
    }
}

-(void)henshin{
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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [talks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [talks objectAtIndex:indexPath.row];
    cell.imageView.image = [[UIImage alloc] initWithData:[images objectAtIndex:indexPath.row]];
    
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
    [store synchronize];
    
    if (!_chatController) _chatController = [ChatController new];
    _chatController.delegate = self;
    _chatController.opponentImg = [[UIImage alloc] initWithData:[images objectAtIndex:indexPath.row]];
    
    _chatController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:_chatController animated:YES];
    //[self presentViewController:_chatController animated:YES completion:nil];
    
    NSLog(@"selectedrow: %d", indexPath.row);
}


#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *dvc = (UIViewController *)[segue destinationViewController];
    dvc.hidesBottomBarWhenPushed = YES;
}
*/

@end
