//
//  EditProfileViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/07/20.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    int editNum = (int)[store integerForKey:@"editUserNum"];
    switch ([store integerForKey:@"editprof"]) {
        case 0:
            self.title = @"名前";
            tf.textAlignment = NSTextAlignmentCenter;
            
            if([store boolForKey:@"editMain"]) tf.text = [store objectForKey:@"myname"];
            else tf.text = [[store objectForKey:@"users"] objectAtIndex:editNum];
            break;
            
        default:
            self.title = @"自己紹介";
            tf.textAlignment = NSTextAlignmentLeft;
            
            if([store boolForKey:@"editMain"]) tf.text = [store objectForKey:@"aboutme"];
            else tf.text = [[store objectForKey:@"intros"] objectAtIndex:editNum];
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)done{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *users = [NSMutableArray arrayWithArray:[store objectForKey:@"users"]];
    NSMutableArray *intros = [NSMutableArray arrayWithArray:[store objectForKey:@"intros"]];
    NSMutableArray *talks = [NSMutableArray arrayWithArray:[store objectForKey:@"talks"]];
    
    int editNum = (int)[store integerForKey:@"editUserNum"];
    
    switch ([store integerForKey:@"editprof"]) {
        case 0:
            if([store boolForKey:@"editMain"]) [store setObject:tf.text forKey:@"myname"];
            else {
                if([users containsObject:tf.text] && ![tf.text isEqualToString:[users objectAtIndex:editNum]]) {
                    [self showAlert:@"この名前は既に使われています" message:@"別の名前に変更してください"];
                    return;
                }
                
                if([talks containsObject:[users objectAtIndex:editNum]]){
                    NSString *key = [NSString stringWithFormat:@"keywords%@", [users objectAtIndex:editNum]];
                    NSArray *hogeArr = [store objectForKey:key];
                    [store setObject:nil forKey:key];
                    
                    [talks replaceObjectAtIndex:[talks indexOfObject:[users objectAtIndex:editNum]] withObject:tf.text];
                    [store setObject:talks forKey:@"talks"];
                    
                    key = [NSString stringWithFormat:@"keywords%@", tf.text];
                    [store setObject:hogeArr forKey:key];
                    
                    
                    key = [NSString stringWithFormat:@"replies%@", [users objectAtIndex:editNum]];
                    hogeArr = [store objectForKey:key];
                    [store setObject:nil forKey:key];
                    
                    [talks replaceObjectAtIndex:[talks indexOfObject:[users objectAtIndex:editNum]] withObject:tf.text];
                    [store setObject:talks forKey:@"talks"];
                    
                    key = [NSString stringWithFormat:@"replies%@", tf.text];
                    [store setObject:hogeArr forKey:key];
                }
                
                [users replaceObjectAtIndex:editNum withObject:tf.text];
                [store setObject:users forKey:@"users"];
            }
            break;
            
        default:
            if([store boolForKey:@"editMain"]) [store setObject:tf.text forKey:@"aboutme"];
            else {
                [intros replaceObjectAtIndex:editNum withObject:tf.text];
                [store setObject:intros forKey:@"intros"];
            }
            break;
    }
    
    [store synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
