//
//  NavigationBarTextColor.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2015/02/07.
//  Copyright (c) 2015年 Logan Wright. All rights reserved.
//

#import "NavigationBarTextColor.h"

@implementation NavigationBarTextColor

+ (void)setNavigationTitleColor:(UINavigationItem *)navigationItem withString:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    //titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:18];
    titleLabel.font = [UIFont fontWithName:@"KozGoPro-Medium" size:17];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    navigationItem.titleView = titleLabel;
}


@end
