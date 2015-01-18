//
//  EditProfileViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/07/20.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "EditProfileViewController.h"

#import "UserData.h"

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
    
    NSData *data = (NSData *)[store objectForKey:@"userDatas"];
    _userDatas = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    UserData *userData = [_userDatas objectAtIndex:editNum];
    
    switch ([store integerForKey:@"editprof"]) {
        case 0:
            self.title = @"名前";
            tf.textAlignment = NSTextAlignmentCenter;
            
            if([store boolForKey:@"editMain"]) tf.text = [store objectForKey:@"myname"];
            else tf.text = userData.name;
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
    
    int editNum = (int)[store integerForKey:@"editUserNum"];
    
    UserData *userData = [_userDatas objectAtIndex:editNum];
    
    NSMutableArray *talks = [store objectForKey:@"talks"];
    
    switch ([store integerForKey:@"editprof"]) {
        case 0:
            if([store boolForKey:@"editMain"]) [store setObject:tf.text forKey:@"myname"];
            else {
                BOOL chofuku = NO;
                
                for (int i = 0; i < _userDatas.count; i++) {
                    UserData *hogeUserData = [_userDatas objectAtIndex:i];
                    if([hogeUserData.name isEqualToString:tf.text]) chofuku = YES;
                }
                
                if(chofuku && ![tf.text isEqualToString:userData.name]) {
                    [self showAlert:@"この名前は既に使われています" message:@"別の名前に変更してください"];
                    return;
                }
                
                if([talks containsObject:userData.name]){
                    NSString *key = [NSString stringWithFormat:@"keywords%@", userData.name];
                    NSArray *hogeArr = [store objectForKey:key];
                    [store setObject:nil forKey:key];
                    
                    [talks replaceObjectAtIndex:[talks indexOfObject:userData.name] withObject:tf.text];
                    [store setObject:talks forKey:@"talks"];
                    
                    key = [NSString stringWithFormat:@"keywords%@", tf.text];
                    [store setObject:hogeArr forKey:key];
                }
                
                userData.name = tf.text;
                [_userDatas replaceObjectAtIndex:editNum withObject:userData];
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_userDatas];
                [store setObject:data forKey:@"userDatas"];
            }
            break;
            
        default:
            if([store boolForKey:@"editMain"]) [store setObject:tf.text forKey:@"aboutme"];
            else {
                userData.intro = tf.text;
                [_userDatas replaceObjectAtIndex:editNum withObject:userData];
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_userDatas];
                [store setObject:data forKey:@"userDatas"];
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
