//
//  FriendsViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/07/19.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "FriendsViewController.h"

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    //重複ラベルの消去
    for (UILabel *subview in [cell.contentView subviews]) [subview removeFromSuperview];
    for (UIImageView *img in [cell.contentView subviews]) [img removeFromSuperview];
    //ここまで
    
    // Configure the cell...
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 6.5, 250, 33)];
    nameLabel.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN W6" size:17];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 6.5, 100, 37)];
    detailLabel.numberOfLines = 2;
    detailLabel.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN W6" size:12];
    detailLabel.textColor = [UIColor lightGrayColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    switch (indexPath.section) {
        case 1:
            if (!searching){
                nameLabel.text = [users objectAtIndex:indexPath.row];
                detailLabel.text = [intros objectAtIndex:indexPath.row];
                imageView.image = [[UIImage alloc] initWithData:[images objectAtIndex:indexPath.row]];
            }else{
                nameLabel.text = [searchArray objectAtIndex:indexPath.row];
                detailLabel.text = [searchArrayIntros objectAtIndex:indexPath.row];
                imageView.image = [[UIImage alloc] initWithData:[searchArrayImg objectAtIndex:indexPath.row]];
            }
            break;
            
        default:
            [self createProfile];
            
            nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"myname"];
            detailLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"aboutme"];
            imageView.image = [[UIImage alloc] initWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"myimage"]];
            break;
    }
    
    if([detailLabel.text lengthOfBytesUsingEncoding:NSShiftJISStringEncoding] < 16) detailLabel.textAlignment = NSTextAlignmentRight;
    
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:detailLabel];
    [cell.contentView addSubview:imageView];
    
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
    
    UIView *view = [self setUpAlertView:indexPath];
    
    modal = [[RNBlurModalView alloc] initWithView:view];
    modal.dismissButtonRight = YES;
    [modal show];
}

-(UIView *)setUpAlertView:(NSIndexPath *)indexPath{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 140)];
    view.backgroundColor = [UIColor colorWithRed:0.859 green:0.792 blue:0.937 alpha:1.0];
    view.layer.cornerRadius = 5.f;
    view.layer.borderColor = [UIColor colorWithRed:0.592 green:0.435 blue:0.776 alpha:1.0].CGColor;
    view.layer.borderWidth = 2.f;
    
    UIImageView *profileImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 80, 80)];
    profileImgView.image = [UIImage imageWithData:[images objectAtIndex:indexPath.row]];
    profileImgView.layer.cornerRadius = 10.0;
    profileImgView.layer.borderWidth = 1.0;
    profileImgView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    [view addSubview:profileImgView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 180, 30)];
    nameLabel.text = [users objectAtIndex:indexPath.row];
    nameLabel.font = [UIFont fontWithName:@"KozGoPro-Medium" size:18];
    [nameLabel sizeToFit];
    [view addSubview:nameLabel];
    
    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, nameLabel.frame.origin.y + nameLabel.frame.size.height + 10, 160, 60)];
    aboutLabel.numberOfLines = 0;
    aboutLabel.text = [intros objectAtIndex:indexPath.row];
    aboutLabel.font = [UIFont fontWithName:@"KozGoPro-Medium" size:16];
    aboutLabel.textColor = [UIColor grayColor];
    [aboutLabel sizeToFit];
    [view addSubview:aboutLabel];
    
    UIButton *talk = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, view.frame.size.width / 2, 40)];
    [talk setTitle:@"トーク" forState:UIControlStateNormal];
    [talk setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    talk.titleLabel.font = [UIFont fontWithName:@"KozGoPro-Medium" size:18];
    [talk addTarget:self action:@selector(editProfile) forControlEvents:UIControlEventTouchUpInside];
    talk.layer.borderWidth = 1.f;
    talk.layer.borderColor = [[UIColor colorWithRed:0.592 green:0.435 blue:0.776 alpha:1.0] CGColor];
    [view addSubview:talk];
    
    UIButton *edit = [[UIButton alloc] initWithFrame:CGRectMake(140, 100, view.frame.size.width / 2, 40)];
    [edit setTitle:@"編集" forState:UIControlStateNormal];
    [edit setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    edit.titleLabel.font = [UIFont fontWithName:@"KozGoPro-Medium" size:18];
    [edit addTarget:self action:@selector(editProfile) forControlEvents:UIControlEventTouchUpInside];
    edit.layer.borderWidth = 1.f;
    edit.layer.borderColor = [[UIColor colorWithRed:0.592 green:0.435 blue:0.776 alpha:1.0] CGColor];
    [view addSubview:edit];
    
    return view;
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


#pragma mark - Alert Custom

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if(alertView.tag == 1){
        // アラートの表示サイズを設定
        CGRect alertFrame = CGRectMake(0, 0, 600, 162);
        alertView.frame = alertFrame;
        
        // アラートの表示位置を設定(アラート表示サイズを変更すると位置がずれるため)
        CGPoint alertPoint = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        alertView.center = alertPoint;
        
        
        // 変数初期化
        NSInteger uiLabelNum = 0;      // ラベル表示回数カウント用
        NSInteger uiButtonNum = 0;     // ボタン表示回数カウント用
        
        // アラート上のオブジェクトの位置を修正(アラート表示サイズを変更すると位置がずれるため)
        for (UIView *view in alertView.subviews) {
            
            // ラベル
            if ([view isKindOfClass:NSClassFromString(@"UILabel")]){
                // ラベルのサイズを設定
                view.frame = CGRectMake(0, 0, 370, 43);
                
                /* 表示位置設定 */
                
                // タイトル
                if (!uiLabelNum) view.center = CGPointMake(alertView.frame.size.width / 2.0, 23);
                // メッセージ
                else view.center = CGPointMake(alertView.frame.size.width / 2.0, 61);
                
                uiLabelNum++;  // インクリメント
            }
            
            // ボタン
            if ([view isKindOfClass:NSClassFromString(@"UIThreePartButton")] ||     // iOS4用
                [view isKindOfClass:NSClassFromString(@"UIAlertButton")])           // iOS5用
            {
                // ボタンのサイズを設定
                view.frame = CGRectMake(0, 0, 127, 43);
                
                /* 表示位置設定 */
                
                // 「いいえ」ボタン
                if (!uiButtonNum) view.center = CGPointMake(alertView.frame.size.width / 2.0 - 67, 122);
                // 「はい」ボタン
                else view.center = CGPointMake(alertView.frame.size.width / 2.0 + 67, 122);
                
                uiButtonNum++;  // インクリメント
            }
        }
    }
}

@end
