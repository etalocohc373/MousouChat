//
//  MasterViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/05/04.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "MasterViewController.h"
#import "SettingViewController.h"
#import "KeywordsCell.h"

@interface MasterViewController ()<SettingViewControllerDelegate> {
    NSMutableArray *_objects;
}
@end

@interface MasterViewController ()

@end

@implementation MasterViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.227 green:0.114 blue:0.369 alpha:1.0];
    
    back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = back;
    
    NSMutableArray *items = [NSMutableArray array];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    
    [items addObject:space];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    
    [items addObject:editButton];
    [tb setItems:items];
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    tv.delegate = self;
    tv.dataSource = self;
    tv.rowHeight = 58.0;
    
    UINib *nib = [UINib nibWithNibName:@"KeywordsCell" bundle:nil];
    [tv registerNib:nib forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [tv deselectRowAtIndexPath:tv.indexPathForSelectedRow animated:YES];
    
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    //rows = [store integerForKey:@"kaisu"];
    
    talks = [NSArray arrayWithArray:[store objectForKey:@"talks"]];
    
    keyword = [NSMutableArray array];
    
    NSArray *keywordmodoki = [NSArray array];
    NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
    keywordmodoki = [store objectForKey:key];
    if(keywordmodoki) keyword = [keywordmodoki mutableCopy];
    
    reply = [NSMutableArray array];
    key = [NSString stringWithFormat:@"replies%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
    keywordmodoki = [store objectForKey:key];
    if(keywordmodoki) reply = [keywordmodoki mutableCopy];
    
    [tv reloadData];
    
    tv.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return _objects.count;
    return [keyword count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    KeywordsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.wordLabel.text = [NSString stringWithFormat:@"%@", [reply objectAtIndex:indexPath.row]];
    
    //NSDate *object = _objects[indexPath.row];
    cell.keywordLabel.text = [NSString stringWithFormat:@"%@", [keyword objectAtIndex:indexPath.row]];//[object description];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
    imgView.image = [UIImage imageNamed:@"fukidashi2.png"];
    [cell addSubview:imgView];
    [cell sendSubviewToBack:imgView];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        
        [keyword removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
    [store setObject:keyword forKey:key];
    
    key = [NSString stringWithFormat:@"replies%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
    [store setObject:reply forKey:key];
    
    [store synchronize];
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    int from = (int)sourceIndexPath.row;
    int to = (int)destinationIndexPath.row;
    
    NSString *hogekey = [keyword objectAtIndex:from];
    [keyword removeObjectAtIndex:from];
    [keyword insertObject:hogekey atIndex:to];
    
    hogekey = [reply objectAtIndex:from];
    [reply removeObjectAtIndex:from];
    [reply insertObject:hogekey atIndex:to];
    
    NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selecteduser"]]];
    [[NSUserDefaults standardUserDefaults] setObject:keyword forKey:key];
    
    key = [NSString stringWithFormat:@"replies%@", [talks objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selecteduser"]]];
    [[NSUserDefaults standardUserDefaults] setObject:reply forKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    [store setInteger:[indexPath row] forKey:@"selectedrow"];
    [tv deselectRowAtIndexPath:tv.indexPathForSelectedRow animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ShowSettingView"]) {
        SettingViewController *vc = (SettingViewController *)[[[segue destinationViewController]viewControllers]objectAtIndex:0];
        vc.delegate = self;
    }
}

-(void)settingViewControllerDidFinish:(SettingViewController *)controller item:(NSString *)item{
    if(!_objects){
        _objects = [[NSMutableArray alloc]init];
    }
    [_objects insertObject:item atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [tv insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (void)edit{
    NSMutableArray *items = [NSMutableArray array];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(edit)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [items addObject:space];
    
    if(!editing){
        [tv setEditing:YES animated:YES];
        [tv beginUpdates];
        editing = YES;
        [back setEnabled:NO];
        [items addObject:doneButton];
    }else{
        [tv setEditing:NO animated:YES];
        [tv endUpdates];
        editing = NO;
        [back setEnabled:YES];
        [items addObject:editButton];
    }
    [tb setItems:items];
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
