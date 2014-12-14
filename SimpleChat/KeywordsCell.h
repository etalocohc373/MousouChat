//
//  KeywordsCell.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/11/17.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeywordsCell;

@protocol KeywordsCellDelegate <NSObject>
@optional
-(void)cell:(KeywordsCell *)cell checkboxTappedEvent:(UITouch *)touch;

@end

@interface KeywordsCell : UITableViewCell{
    UIImage *_checkedImage;
    UIImage *_uncheckedImage;
    __unsafe_unretained id<KeywordsCellDelegate> _delegate;
}

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIImageView *checkbox;

@property (weak, nonatomic) IBOutlet UILabel *keywordLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;

@property(nonatomic, assign) id <KeywordsCellDelegate> delegate;
- (void)setCheckboxState:(BOOL)isCheck;

@end