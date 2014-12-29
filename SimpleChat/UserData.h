//
//  UserData.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/12/20.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject <NSCoding>

@property (nonatomic) NSString *name;
@property (nonatomic) NSData *image;
@property (nonatomic) NSString *intro;

- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;
- (void)dealloc;

@end
