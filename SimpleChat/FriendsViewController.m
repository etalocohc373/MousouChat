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
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.tabBarController.tabBar.barTintColor = [UIColor purpleColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    searchArray = [NSMutableArray array];
    searchArrayImg = [NSMutableArray array];
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
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    // Configure the cell...
    
    switch (indexPath.section) {
        case 1:
            if (!searching){
                cell.textLabel.text = [users objectAtIndex:indexPath.row];
                cell.imageView.image = [[UIImage alloc] initWithData:[images objectAtIndex:indexPath.row]];
            }else{
                cell.textLabel.text = [searchArray objectAtIndex:indexPath.row];
                cell.imageView.image = [[UIImage alloc] initWithData:[searchArrayImg objectAtIndex:indexPath.row]];
            }
            break;
            
        default:
            [self makeProfile];
            
            cell.textLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"myname"];
            cell.imageView.image = [[UIImage alloc] initWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"myimage"]];
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"プロフィール";
            break;
            
        default:
            return @"友だち";
            break;
    }
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
                
                NSString *key = [NSString stringWithFormat:@"keyword%@", [users objectAtIndex:deletepath.row]];
                [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary new] forKey:key];
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
    
    UIViewController *viewcon = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    if(!indexPath.row && !indexPath.section) [self presentViewController:viewcon animated:YES completion:nil];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar showsCancelButton];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    for (int i = 0; i < users.count; i++) {
        NSRange range = [[users objectAtIndex:i] rangeOfString:searchBar.text];
        if (range.location != NSNotFound) {
            [searchArray addObject:[users objectAtIndex:i]];
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

-(void)makeProfile{
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
