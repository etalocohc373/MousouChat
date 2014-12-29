//
//  EditProfileViewController.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/07/20.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>{
    IBOutlet UITextField *tf;
    
    NSMutableArray *_userDatas;
}

@end
