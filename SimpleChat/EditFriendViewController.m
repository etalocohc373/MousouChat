//
//  EditFriendViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/09/18.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "EditFriendViewController.h"

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
    
    self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
    
    self.tableView.allowsMultipleSelection = YES;
    
    NSArray *mar3 = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"pimages"]];
    
    images = [NSMutableArray array];
    images = [mar3 mutableCopy];
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    NSArray *mar3 = [store objectForKey:@"users"];
    
    users = [NSMutableArray array];
    users = [mar3 mutableCopy];
    
    talks = [NSMutableArray array];
    mar3 = [NSArray arrayWithArray:[store objectForKey:@"talks"]];
    if(mar3){
        talks = [mar3 mutableCopy];
    }
    
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
    return users.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"友だち";
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
    
    // Configure the cell...
    cell.textLabel.text = [users objectAtIndex:indexPath.row];
    cell.imageView.image = [[UIImage alloc] initWithData:[images objectAtIndex:indexPath.row]];
    
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
    NSArray *user2 = [NSArray arrayWithArray:users];
    NSArray *talk2 = [NSArray arrayWithArray:talks];
    NSArray *image2 = [NSArray arrayWithArray:images];
    switch (buttonIndex) {
        case 1:
            for (int i = 0; i < selectedRow.count; i++) {
                hoge = [[selectedRow objectAtIndex:i] intValue];
                //トーク削除
                if([talk2 indexOfObject:[user2 objectAtIndex:hoge]] != NSNotFound){
                    [talks removeObject:[talk2 objectAtIndex:[talk2 indexOfObject:[user2 objectAtIndex:hoge]]]];
                    [[NSUserDefaults standardUserDefaults] setObject:talks forKey:@"talks"];
                    
                    NSString *key = [NSString stringWithFormat:@"keyword%@", [user2 objectAtIndex:hoge]];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary new] forKey:key];
                }//ここまで
                
                //ユーザ削除
                [users removeObject:[user2 objectAtIndex:hoge]];
                [[NSUserDefaults standardUserDefaults] setObject:users forKey:@"users"];
                //ここまで
                
                //プロフ画削除
                [images removeObject:[image2 objectAtIndex:hoge]];
                [[NSUserDefaults standardUserDefaults] setObject:images forKey:@"pimages"];
                //ここまで
                
                [[NSUserDefaults standardUserDefaults] synchronize];
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
