//
//  FriendsViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/07/19.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "FriendsViewController.h"

#import "FriendsCell.h"
#import "CustomAlertView.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

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
    
    //[self reset];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:0.227 green:0.114 blue:0.369 alpha:1.0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.227 green:0.114 blue:0.369 alpha:1.0];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    searchArray = [NSMutableArray array];
    searchArrayIntros = [NSMutableArray array];
    searchArrayImg = [NSMutableArray array];
    
    self.tableView.sectionHeaderHeight = 23;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    talks = [NSMutableArray array];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"talks"]){
        talks = [[NSUserDefaults standardUserDefaults] objectForKey:@"talks"];
        self.navigationController.tabBarController.selectedIndex = 1;
    }
    
    UINib *nib = [UINib nibWithNibName:@"FriendsCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    NSArray *mar3 = [store objectForKey:@"users"];
    
    if(mar3){
        users = [NSMutableArray array];
        users = [mar3 mutableCopy];
    }else{
        users = [NSMutableArray arrayWithObjects:@"まっすー", nil];
        [store setObject:users forKey:@"users"];
    }
    
    mar3 = [NSArray arrayWithArray:[store objectForKey:@"pimages"]];
    
    if([mar3 count]){
        images = [NSMutableArray array];
        images = [mar3 mutableCopy];
    }else{
        NSData *pngData = [[NSData alloc] initWithData:UIImagePNGRepresentation([UIImage imageNamed:@"massu.jpg"])];
        
        images = [NSMutableArray arrayWithObjects:pngData, nil];
        [store setObject:images forKey:@"pimages"];
    }
    
    mar3 = [NSArray arrayWithArray:[store objectForKey:@"intros"]];
    
    if([mar3 count]){
        intros = [NSMutableArray array];
        intros = [mar3 mutableCopy];
    }else{
        intros = [NSMutableArray arrayWithObjects:@"こんにちは！", nil];
        [store setObject:intros forKey:@"intros"];
    }
    
    mar3 = [NSArray arrayWithArray:[store objectForKey:@"talks"]];
    
    talks = [NSMutableArray array];
    if(mar3){
        talks = [mar3 mutableCopy];
    }
    
    [store setFloat:0.1 forKey:@"kidokuDelay"];
    
    if(users.count > 1) editBtn.enabled = YES;
    else editBtn.enabled = NO;
    
    [store synchronize];
    
    [self.tableView reloadData];
    
    [self createNavTitle:[NSString stringWithFormat:@"友だち (%lu人)", (unsigned long)users.count]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 1:
            if(!searching) return [users count];
            else return [searchArray count];
            break;
            
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    /*//重複ラベルの消去
    for (UILabel *subview in [cell.contentView subviews]) [subview removeFromSuperview];
    for (UIImageView *img in [cell.contentView subviews]) [img removeFromSuperview];
    //ここまで*/
    
    // Configure the cell...
    switch (indexPath.section) {
        case 1:
            if (!searching){
                cell.nameLabel.text = [users objectAtIndex:indexPath.row];
                cell.introLabel.text = [intros objectAtIndex:indexPath.row];
                cell.profileImageView.image = [[UIImage alloc] initWithData:[images objectAtIndex:indexPath.row]];
            }else{
                cell.nameLabel.text = [searchArray objectAtIndex:indexPath.row];
                cell.introLabel.text = [searchArrayIntros objectAtIndex:indexPath.row];
                cell.profileImageView.image = [[UIImage alloc] initWithData:[searchArrayImg objectAtIndex:indexPath.row]];
            }
            break;
            
        default:
            [self createProfile];
            
            cell.nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"myname"];
            cell.introLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"aboutme"];
            cell.profileImageView.image = [[UIImage alloc] initWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"myimage"]];
            break;
    }
    
    if([cell.introLabel.text lengthOfBytesUsingEncoding:NSShiftJISStringEncoding] < 16) cell.introLabel.textAlignment = NSTextAlignmentRight;
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
    if (self.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 23)];
    headerView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
    tableView.sectionHeaderHeight = headerView.frame.size.height;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.frame.size.width - 10, 23)];
    
    NSString *title = [NSString stringWithFormat:@"友だち (%lu)", (unsigned long)users.count];
    switch (section) {
        case 0:
            label.text = @"プロフィール";
            break;
            
        default:
            label.text = title;
            break;
    }
    
    label.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN W6" size:11.5];
    label.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    
    [headerView addSubview:label];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
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
        deletepath = indexPath;
        [self showAlert:@"本当にフレンドを削除しますか？" message:@"一度削除すると元には戻りません"];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)showAlert:(NSString *)title message:(NSString *)text{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:text delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"削除", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            if([talks indexOfObject:[users objectAtIndex:deletepath.row]] != NSNotFound){
                [talks removeObjectAtIndex:[talks indexOfObject:[users objectAtIndex:deletepath.row]]];
                [[NSUserDefaults standardUserDefaults] setObject:talks forKey:@"talks"];
                
                NSString *key = [NSString stringWithFormat:@"keywords%@", [users objectAtIndex:deletepath.row]];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:key];
                
                key = [NSString stringWithFormat:@"replies%@", [users objectAtIndex:deletepath.row]];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:key];
            }
            
            [users removeObjectAtIndex:deletepath.row];
            [[NSUserDefaults standardUserDefaults] setObject:users forKey:@"users"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tableView deleteRowsAtIndexPaths:@[deletepath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    editPath = indexPath;
    
#warning Change this to see a custom view
    RNBlurModalView *modal;
    
    UIView *view = [self setUpAlertViewForIndexPath:indexPath];
    
    modal = [[RNBlurModalView alloc] initWithView:view];
    modal.dismissButtonRight = YES;
    
    [modal show];
}

-(UIView *)setUpAlertViewForIndexPath:(NSIndexPath *)indexPath{
    UIImage *profileImage;
    NSString *name;
    NSString *intro;
    
    if(indexPath.section){
        profileImage = [UIImage imageWithData:[images objectAtIndex:indexPath.row]];
        name = [users objectAtIndex:indexPath.row];
        intro = [intros objectAtIndex:indexPath.row];
    }else{
        profileImage = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"myimage"]];
        name = [[NSUserDefaults standardUserDefaults] objectForKey:@"myname"];
        intro = [[NSUserDefaults standardUserDefaults] objectForKey:@"aboutme"];
    }
    
    UINib *nib = [UINib nibWithNibName:@"CustomAlertView" bundle:nil];
    CustomAlertView *view = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    view.layer.cornerRadius = 5.f;
    view.layer.borderColor = [UIColor colorWithRed:0.592 green:0.435 blue:0.776 alpha:1.0].CGColor;
    //view.layer.borderWidth = 2.f;
    
    view.profileImgView.layer.cornerRadius = 15.0;
    view.profileImgView.layer.borderWidth = 1.0;
    view.profileImgView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    view.profileImgView.layer.masksToBounds = YES;
    [view.profileImgView setImage:profileImage];
    
    view.nameLabel.text = name;
    [view.nameLabel sizeToFit];
    
    view.introLabel.numberOfLines = 2;
    view.introLabel.text = intro;
    [view.introLabel sizeToFit];
    
    CALayer *rightBorder = [CALayer layer];
    rightBorder.borderColor = [[UIColor colorWithRed:0.592 green:0.435 blue:0.776 alpha:1.0] CGColor];
    rightBorder.borderWidth = 1.f;
    rightBorder.frame = CGRectMake(-2, 1, CGRectGetWidth(view.talkBtn.frame)+2, CGRectGetHeight(view.talkBtn.frame)+1);
    [view.talkBtn.layer addSublayer:rightBorder];
    [view.talkBtn addTarget:self action:@selector(jumpToTalk) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *leftBorder = [CALayer layer];
    leftBorder.borderColor = [[UIColor colorWithRed:0.592 green:0.435 blue:0.776 alpha:1.0] CGColor];
    leftBorder.borderWidth = 1.f;
    leftBorder.frame = CGRectMake(-1, 1, CGRectGetWidth(view.editBtn.frame)+2, CGRectGetHeight(view.editBtn.frame)+1);
    [view.editBtn.layer addSublayer:leftBorder];
    [view.editBtn addTarget:self action:@selector(editProfile) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

-(void)jumpToTalk{
    if([talks containsObject:[users objectAtIndex:editPath.row]]){
        NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
        
        [store setInteger:editPath.row forKey:@"selecteduser"];
        
        NSMutableArray *notReadRows = [NSMutableArray arrayWithArray:[store objectForKey:@"notReadRows"]];
        
        if([notReadRows containsObject:[talks objectAtIndex:(int)editPath.row]]){
            [notReadRows removeObject:[talks objectAtIndex:(int)editPath.row]];
            [store setObject:notReadRows forKey:@"notReadRows"];
        }
        
        [store synchronize];
        
        if (!_chatController) _chatController = [ChatController new];
        _chatController.delegate = (id<ChatControllerDelegate>)self;
        _chatController.opponentImg = [[UIImage alloc] initWithData:[images objectAtIndex:editPath.row]];
        
        _chatController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:_chatController animated:YES];
    }
}

-(void)editProfile{
    if(!editPath.section) [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"editMain"];
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"editMain"];
        [[NSUserDefaults standardUserDefaults] setInteger:editPath.row forKey:@"editUserNum"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIViewController *viewcon = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    [self presentViewController:viewcon animated:YES completion:nil];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar showsCancelButton];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    for (int i = 0; i < users.count; i++) {
        NSRange range = [[users objectAtIndex:i] rangeOfString:searchBar.text];
        if (range.location != NSNotFound) {
            [searchArray addObject:[users objectAtIndex:i]];
            [searchArrayIntros addObject:[intros objectAtIndex:i]];
            [searchArrayImg addObject:[images objectAtIndex:i]];
        }
    }
    searching = YES;
    [self.tableView reloadData];
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    
    searching = NO;
    [self.tableView reloadData];
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

-(void)createNavTitle:(NSString *)title{
    UILabel* tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    tLabel.text = title;
    tLabel.textColor = [UIColor whiteColor];
    tLabel.backgroundColor = [UIColor clearColor];
    tLabel.textAlignment = NSTextAlignmentCenter;
    tLabel.adjustsFontSizeToFitWidth = YES;
    tLabel.font = [UIFont fontWithName:@"KozGoPro-Medium" size:18];
    
    self.navigationItem.titleView = tLabel;
}

-(void)createProfile{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    
    if(![store objectForKey:@"myimage"]){
        NSData *pngData = [[NSData alloc] initWithData:UIImagePNGRepresentation([UIImage imageNamed:@"pimage.png"])];
        [store setObject:pngData forKey:@"myimage"];
    }
    if(![store objectForKey:@"myname"]) [store setObject:@"Hoge" forKey:@"myname"];
    if(![store objectForKey:@"aboutme"]) [store setObject:@"Hello World!" forKey:@"aboutme"];
    
    [store synchronize];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)reset{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

@end
