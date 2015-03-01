//
//  AdViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2015/02/17.
//  Copyright (c) 2015年 Logan Wright. All rights reserved.
//

#import "AdViewController.h"

@interface AdViewController ()

@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadAdMobIntersBanner];
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

@end
