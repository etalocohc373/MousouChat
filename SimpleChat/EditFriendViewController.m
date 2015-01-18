//
//  EditFriendViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/09/18.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "EditFriendViewController.h"

#import "UserData.h"

@interface EditFriendViewController ()

@end

@implementation EditFriendViewController

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
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.227 green:0.114 blue:0.369 alpha:1.0];
    
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.separatorColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    
    NSData *data = (NSData *)[store objectForKey:@"userDatas"];
    _userDatas = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    
    talks = [NSMutableArray array];
    NSArray *mar3 = [NSArray arrayWithArray:[store objectForKey:@"talks"]];
    if(mar3) talks = [mar3 mutableCopy];
    
    selectedRow = [NSMutableArray array];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _userDatas.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"　友だち";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [selectedRow addObject:[NSNumber numberWithInt:(int)indexPath.row]];
    
    deleteBtn.enabled = YES;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [selectedRow removeObject:[NSNumber numberWithInt:(int)indexPath.row]];
    
    if(!selectedRow.count) deleteBtn.enabled = NO;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    UserData *userData = [_userDatas objectAtIndex:indexPath.row];

    cell.textLabel.text = userData.name;
    cell.textLabel.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN W3" size:18];
    cell.imageView.image = [[UIImage alloc] initWithData:userData.image];
    
    return cell;
}

-(IBAction)delete{
    [self showAlert:@"本当に友だちを削除しますか？" message:@"一度削除すると元には戻りません"];
}

-(IBAction)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int hoge;
    
    //NSArray *_userDatasClone = [NSArray arrayWithArray:_userDatas];
    NSArray *talk2 = [NSArray arrayWithArray:talks];
    
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    
    switch (buttonIndex) {
        case 1:
            for (int i = 0; i < selectedRow.count; i++) {
                hoge = [[selectedRow objectAtIndex:i] intValue];
                //トーク削除
                BOOL chofuku = NO;
                
                UserData *userData = [_userDatas objectAtIndex:hoge];
                
                for (int x = 0; x < _userDatas.count; x++) {
                    if([[talk2 objectAtIndex:x] isEqualToString:userData.name]) chofuku = YES;
                }
                
                if(chofuku){
                    [talks removeObject:userData.name];
                    [store setObject:talks forKey:@"talks"];
                    
                    NSString *key = [NSString stringWithFormat:@"keywords%@", userData.name];
                    [store setObject:nil forKey:key];
                }//ここまで
                
                //ユーザ削除
                [_userDatas removeObject:userData];
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_userDatas];
                [store setObject:data forKey:@"userDatas"];
                //ここまで
                
                [store synchronize];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:hoge inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
            
            [self cancel];
            break;
            
        default:
            break;
    }
}

-(void)showAlert:(NSString *)title message:(NSString *)text{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:text delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"削除", nil];
    [alert show];
}

@end
