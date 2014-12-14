//
//  KeywordsCell.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/11/17.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "KeywordsCell.h"

@interface KeywordsCell()
- (void)checkboxTapped:(id)sender event:(id)event;
@end

@implementation KeywordsCell
@synthesize delegate = _delegate;

- (IBAction)checkboxTapped:(id)sender event:(id)event
{
    NSString *checkedImgPath = [[NSBundle mainBundle] pathForResource:@"checkmark" ofType:@"png"];
    _checkedImage = [[UIImage alloc] initWithContentsOfFile:checkedImgPath];
    NSSet *set = [event allTouches];
    UITouch *touch = [set anyObject];
    
    if (touch && [_delegate respondsToSelector:@selector(cell:checkboxTappedEvent:)]){
        [_delegate cell:self checkboxTappedEvent:touch];
    }
}

- (void)setCheckboxState:(BOOL)isCheck
{
    if(isCheck) [_checkBtn setImage:_checkedImage forState:UIControlStateNormal];
    else [_checkBtn setImage:_uncheckedImage forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
