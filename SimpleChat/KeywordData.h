//
//  KeywordData.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/12/29.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeywordData : NSObject <NSCoding>

@property (nonatomic) NSString *keyword;
@property (nonatomic) NSString *reply;
@property (nonatomic) NSDate *sendDate;
@property (nonatomic) BOOL setTime;
@property (nonatomic) BOOL doRepeat;

- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;
- (void)dealloc;

@end
