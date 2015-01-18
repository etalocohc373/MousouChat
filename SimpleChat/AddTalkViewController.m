//
//  AddTalkViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/07/19.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "AddTalkViewController.h"

#import "UserData.h"

@interface AddTalkViewController ()

@end

@implementation AddTalkViewController

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
    
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    
    NSData *data = (NSData *)[store objectForKey:@"userDatas"];
    _userDatas = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    
    talks = [NSArray arrayWithArray:[store objectForKey:@"talks"]];
    
    [self createNavTitle:@"　　　友だちを選択"];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 23)];
    headerView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
    tableView.sectionHeaderHeight = headerView.frame.size.height;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.frame.size.width - 10, 23)];
    label.text = @"友だち";
    
    label.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN W6" size:11.5];
    label.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    
    [headerView addSubview:label];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _userDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    UserData *userData = [_userDatas objectAtIndex:indexPath.row];
    
    cell.textLabel.text = userData.name;
    cell.textLabel.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN W6" size:17];
    cell.imageView.image = [[UIImage alloc] initWithData:userData.image];
    
    return cell;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserData *userData = [_userDatas objectAtIndex:indexPath.row];
    
    if([talks indexOfObject:userData.name] == NSNotFound){
        [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row + 1 forKey:@"addtalk"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self showError];
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

-(IBAction)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createNavTitle:(NSString *)title{
    UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(-50, 0, 300, 40)];
    tLabel.text = title;
    tLabel.textColor = [UIColor whiteColor];
    tLabel.backgroundColor = [UIColor clearColor];
    tLabel.textAlignment = NSTextAlignmentLeft;
    tLabel.adjustsFontSizeToFitWidth = YES;
    tLabel.font = [UIFont fontWithName:@"MS Gothic" size:17];
    self.navigationItem.titleView = tLabel;
}

-(void)showError{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"既にトークが作成済みです" message:@"他のフレンドを選択してください" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
