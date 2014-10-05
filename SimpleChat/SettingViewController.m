//
//  SettingViewController.m
//  TextSample
//
//  Created by Minami Sophia Aramaki on 2013/10/20.
//  Copyright (c) 2013年 Minami Sophia Aramaki. All rights reserved.
//

#import "SettingViewController.h"

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
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.allowsSelection = NO;
    
    self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
    
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    kaisu = (int)[store integerForKey:@"kaisu"];
    
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"キーワード";
            break;
            
        case 1:
            return @"返答";
            break;
            
        default:
            break;
    }
    return nil;
}

-(IBAction)dainyu{
    kaisu++;
    //kaisu = 0;
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    
    [keyword addObject:tf.text];
    NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
    [store setObject:keyword forKey:key];
    
    [reply addObject:tf2.text];
    key = [NSString stringWithFormat:@"replies%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
    [store setObject:reply forKey:key];
    
    [store synchronize];

    //[self.delegate settingViewControllerDidFinish:self item:self.tf.text];
    [self back];
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

@end
