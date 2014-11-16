//
//  CustomAlertView.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/11/16.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init{
    self = [super initWithFrame:CGRectMake(0, 0, 280, 140)];
    if (self) {
        [self customViewCommonInit];
    }
    return self;
}

- (void)customViewCommonInit
{
    // STCustomView.xibをロードし、Viewを得る
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"CustomAlertView" owner:self options:nil] objectAtIndex:0];
    [self addSubview:view];
}

@end
