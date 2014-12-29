//
//  KeywordData.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/12/29.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "KeywordData.h"

@implementation KeywordData

@synthesize keyword = _keyword;
@synthesize reply = _reply;
@synthesize sendDate = _sendDate;
@synthesize doRepeat = _doRepeat;

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if (self) {
        _keyword = [coder decodeObjectForKey:@"keyword"];
        _reply = [coder decodeObjectForKey:@"reply"];
        _sendDate = [coder decodeObjectForKey:@"sendDate"];
        _doRepeat = [coder decodeBoolForKey:@"doRepeat"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_keyword forKey:@"keyword"];
    [coder encodeObject:_reply forKey:@"reply"];
    [coder encodeObject:_sendDate forKey:@"sendDate"];
    [coder encodeBool:_doRepeat forKey:@"doRepeat"];
}

- (void)dealloc
{
    self.keyword = nil;
    self.reply = nil;
    self.sendDate = nil;
    self.doRepeat = nil;
}

@end
