//
//  TalkTableViewCell.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/11/15.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "TalkTableViewCell.h"

@implementation TalkTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)rowHeight
{
    return 70.0f;
}

@end
