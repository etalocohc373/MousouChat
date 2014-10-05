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
    
    self.tabBarController.tabBar.barTintColor = [UIColor purpleColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    searchArray = [NSMutableArray array];
    searchArrayIntros = [NSMutableArray array];
    searchArrayImg = [NSMutableArray array];
    
    self.tableView.sectionHeaderHeight = 19;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
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
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 250, 33)];
    nameLabel.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN W6" size:17];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 3, 100, 37)];
    detailLabel.numberOfLines = 2;
    detailLabel.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN W6" size:12];
    detailLabel.textColor = [UIColor lightGrayColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 43, 43)];
    
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 19)];
    headerView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    tableView.sectionHeaderHeight = headerView.frame.size.height;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.frame.size.width - 10, 19)];
    
    NSString *title = [NSString stringWithFormat:@"友だち (%lu)", (unsigned long)users.count];
    switch (section) {
        case 0:
            label.text = @"プロフィール";
            break;
            
        default:
            label.text = title;
            break;
    }
    
    label.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN W6" size:12];
    label.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    
    [headerView addSubview:label];
    return headerView;
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
    
    if(!indexPath.section) [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"editMain"];
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"editMain"];
        [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"editUserNum"];
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
