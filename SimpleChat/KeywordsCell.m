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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /*
         _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         NSString *checkedImgPath = [[NSBundle mainBundle] pathForResource:@"checkedmark" ofType:@"png"];
         NSString *uncheckedImgPath = [[NSBundle mainBundle] pathForResource:@"uncheckmark" ofType:@"png"];
         */
        _checkbox.userInteractionEnabled = YES;
        
        _checkedImage = [UIImage imageNamed:@"checkmark.png"];
        _uncheckedImage = [UIImage imageNamed:@"uncheckmark.png"];
        
        _checkbox.image = _uncheckedImage;
        
    }
    return self;
}

- (IBAction)checkboxTapped:(id)sender event:(id)event
{
    NSSet *set = [event allTouches];
    UITouch *touch = [set anyObject];
    
    if (touch && [_delegate respondsToSelector:@selector(cell:checkboxTappedEvent:)]){
        [_delegate cell:self checkboxTappedEvent:touch];
    }
}

- (void)setCheckboxState:(BOOL)isCheck
{
    if(isCheck) {
        //MARK:fixed
        
        NSString *path = [[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"checkmark" ofType:@"png"]];
        _checkedImage = [[UIImage alloc] initWithContentsOfFile:path];
        _checkbox.image = _checkedImage;
        
    }else {
        NSString *path = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:@"uncheckmark" ofType:@"png"]];
        
        _checkedImage = [[UIImage alloc] initWithContentsOfFile:path];
        _checkbox.image = _checkedImage;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) _keywordLabel.textColor = [UIColor whiteColor];
    else _keywordLabel.textColor = [UIColor blackColor];
}

@end
