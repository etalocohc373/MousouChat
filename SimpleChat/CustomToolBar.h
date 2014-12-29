//
//  CustomToolBar.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/11/30.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomToolBar;

@protocol CustomToolBarDelegate <NSObject>

@optional
-(void)deleteButtonTappedEvent;
-(void)actionButtonTappedEvent;
-(void)editButtonTappedEvent;
-(void)closeButtonTappedEvent;

@end

@interface CustomToolBar : UIView{
    id<CustomToolBarDelegate> delegate;
}

@property (weak, nonatomic) IBOutlet UIButton *trash;
@property (weak, nonatomic) IBOutlet UIButton *edit;
@property (weak, nonatomic) IBOutlet UIButton *action;
@property (weak, nonatomic) IBOutlet UIButton *hide;

@property(nonatomic, assign) id <CustomToolBarDelegate> delegate;

-(void)setEditBtnState:(BOOL)editable;

@end
