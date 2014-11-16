//
//  TalkTableViewCell.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/11/15.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

+ (CGFloat)rowHeight;

@end
