//
//  CustomToolBar.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/11/30.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "CustomToolBar.h"

@interface CustomToolBar()

-(IBAction)dismiss:(id)sender event:(id)event;

@end

@implementation CustomToolBar

@synthesize delegate = _delegate;

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context,UIColor.lightGrayColor.CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 320, 0);
    CGContextStrokePath(context);
}

-(id)init
{
    NSArray *topLevelViews = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil];
    return topLevelViews[0];
}

- (id)initWithFrame:(CGRect)frame {
    self = [self init];
    if (self) {
        self.frame = frame;
    }
    return self;
}

-(IBAction)deleteBtnTapped{
    if([_delegate respondsToSelector:@selector(deleteButtonTappedEvent)]) [_delegate deleteButtonTappedEvent];
}

-(IBAction)editBtnTapped{
    if([_delegate respondsToSelector:@selector(editButtonTappedEvent)]) [_delegate editButtonTappedEvent];
}

-(IBAction)actionBtnTapped{
    if([_delegate respondsToSelector:@selector(actionButtonTappedEvent)]) [_delegate actionButtonTappedEvent];
}

-(IBAction)dismiss:(id)sender event:(id)event{
    [UIView animateWithDuration:0.2f
                     animations:^{
                         self.center = CGPointMake(160, 590);
                     }];
    
    if ([_delegate respondsToSelector:@selector(closeButtonTappedEvent)]) [_delegate closeButtonTappedEvent];
}

-(void)setEditBtnState:(BOOL)editable{
    _edit.enabled = editable;
    _action.enabled = editable;
}

@end
