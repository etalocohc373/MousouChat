//
//  AdViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2015/02/17.
//  Copyright (c) 2015年 Logan Wright. All rights reserved.
//

#import "AdViewController.h"
#import "NavigationBarTextColor.h"

#import <Social/Social.h>

@interface AdViewController ()

@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NavigationBarTextColor setNavigationTitleColor:self.navigationItem withString:@"その他"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadAdMobIntersBanner
{
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.adUnitID = @"ca-app-pub-7980904471394092/6169729764";
    interstitial_.delegate = self;
    GADRequest *request = [GADRequest request];
    [interstitial_ loadRequest:request];
}

// AdMobのインタースティシャル広告表示
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [interstitial_ presentFromRootViewController:self];
}

-(IBAction)showAd{
    [self loadAdMobIntersBanner];
}

#pragma mark - Share SNS

- (IBAction)makeShare{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"シェアエラー"
                                                        message:@"facebookアカウントが設定されていません"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    NSString *text = @"妄想ちゃっと。";
    NSURL *URL = [NSURL URLWithString:@"hogehoge"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"hogehoge"]];
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controller setInitialText:text];
    [controller addURL:URL];
    [controller addImage:[[UIImage alloc] initWithData:imageData]];
    controller.completionHandler =^(SLComposeViewControllerResult result){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)makeTweet{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ツイートエラー"
                                                        message:@"Twitterアカウントが設定されていません"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    NSString *text = @"妄想ちゃっと。";
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [controller setInitialText:text];
    controller.completionHandler = ^(SLComposeViewControllerResult result){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:controller animated:YES completion:nil];
}

-(IBAction)makeLine{
    NSString *string = @"妄想ちゃっと。";
    
    string = [string
              stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *LINEUrlString = [NSString
                               stringWithFormat:@"line://msg/text/%@", string];
    
    //LINEがインストールされているか確認。されていなければアラート→AppStoreを開く
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:LINEUrlString]]) {
        [[UIApplication sharedApplication]
         openURL:[NSURL URLWithString:LINEUrlString]];
    } else {
        [self cannotOpenAlert];
    }
}

-(void)cannotOpenAlert{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"LINEがインストールされていません"
                          message:@"LINEをインストールしますか？"
                          delegate:self
                          cancelButtonTitle:@"いいえ"
                          otherButtonTitles:@"はい", nil
                          ];
    [alert show];
}

@end
