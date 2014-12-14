//
//  SettingViewController.m
//  TextSample
//
//  Created by Minami Sophia Aramaki on 2013/10/20.
//  Copyright (c) 2013年 Minami Sophia Aramaki. All rights reserved.
//

#import "SettingViewController.h"
#import "TimeSpecViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize tf;

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    BOOL edit = [store boolForKey:@"editKeyword"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    //self.tableView.allowsSelection = NO;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.227 green:0.114 blue:0.369 alpha:1.0];
    
    [tf becomeFirstResponder];
    
    talks = [NSArray arrayWithArray:[store objectForKey:@"talks"]];
    
    keyword = [NSMutableArray array];
    reply = [NSMutableArray array];
    
    NSArray *keywordmodoki = [NSArray array];
    NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
    keywordmodoki = [store objectForKey:key];
    if(keywordmodoki) keyword = [keywordmodoki mutableCopy];
    
    keywordmodoki = [NSArray array];
    key = [NSString stringWithFormat:@"replies%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
    keywordmodoki = [store objectForKey:key];
    if(keywordmodoki) reply = [keywordmodoki mutableCopy];
    
    
    if(edit){
        self.title = @"キーワード編集";
        
        tf.text = [keyword objectAtIndex:[store integerForKey:@"selectedrow"]];
        tf2.text = [reply objectAtIndex:[store integerForKey:@"selectedrow"]];
    }
    
    /*[keyword removeAllObjects];
    [word removeAllObjects];
    
    [store setObject:keyword forKey:@"keywords"];
    [store setObject:word forKey:@"words"];
    [store synchronize];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 30;
            break;
            
        default:
            return 20;
            break;
    }
}

/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 3){
        TimeSpecViewController *secondVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"time"];
        [self.navigationController pushViewController:secondVC animated:YES];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}*/

-(IBAction)dainyu{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    BOOL edit = [store boolForKey:@"editKeyword"];
    
    if(edit){
        if([keyword containsObject:tf.text] && ![tf.text isEqualToString:[keyword objectAtIndex:[store integerForKey:@"selectedrow"]]]) [self showError];
        else{
            int editRow = (int)[store integerForKey:@"selectedrow"];
            
            [keyword replaceObjectAtIndex:editRow withObject:tf.text];
            NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
            [store setObject:keyword forKey:key];
            
            [reply replaceObjectAtIndex:editRow withObject:tf2.text];
            key = [NSString stringWithFormat:@"replies%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
            [store setObject:reply forKey:key];
            
            [store synchronize];
            
            [self back];
        }
    }else{
        if(![keyword containsObject:tf.text]){
            [keyword addObject:tf.text];
            NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
            [store setObject:keyword forKey:key];
            
            [reply addObject:tf2.text];
            key = [NSString stringWithFormat:@"replies%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
            [store setObject:reply forKey:key];
            
            [store synchronize];
            
            //[self.delegate settingViewControllerDidFinish:self item:self.tf.text];
            [self back];
        }else{
            [self showError];
        }
    }
}

-(IBAction)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)hantei{
    if(![tf.text isEqualToString:@""] && ![tf2.text isEqualToString:@""]){
        done.enabled = YES;
    }else{
        done.enabled = NO;
    }
}

-(void)showError{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"キーワードが重複しています" message:@"キーワードを変更してください" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
