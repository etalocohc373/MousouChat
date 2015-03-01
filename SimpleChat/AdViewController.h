//
//  AdViewController.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2015/02/17.
//  Copyright (c) 2015年 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GADInterstitial.h>

@interface AdViewController : UIViewController <GADInterstitialDelegate>{
    GADInterstitial *interstitial_;
}

@end
