//
//  AddTalkViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/07/19.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "AddTalkViewController.h"

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
    
    self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
    
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    NSArray *mar3 = [store objectForKey:@"users"];
    
    users = [NSMutableArray array];
    users = [mar3 mutableCopy];
    
    mar3 = [NSArray arrayWithArray:[store objectForKey:@"pimages"]];
    
    images = [NSMutableArray array];
    images = [mar3 mutableCopy];
    
    talks = [NSArray arrayWithArray:[store objectForKey:@"talks"]];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    // Configure the cell...
    
    cell.textLabel.text = [users objectAtIndex:indexPath.row];
    cell.imageView.image = [[UIImage alloc] initWithData:[images objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([talks indexOfObject:[users objectAtIndex:indexPath.row]] == NSNotFound){
        [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row + 1 forKey:@"addtalk"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

-(IBAction)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
