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
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
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
    
    mar3 = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"pimages"]];
    
    if([mar3 count]){
        images = [NSMutableArray array];
        images = [mar3 mutableCopy];
    }else{
        NSData *pngData = [[NSData alloc] initWithData:UIImagePNGRepresentation([UIImage imageNamed:@"massu.png"])];
        
        images = [NSMutableArray arrayWithObjects:pngData, nil];
        [store setObject:images forKey:@"pimages"];
    }
    
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
        [users removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:users forKey:@"users"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
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

@end
