//
//  UserData.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/12/20.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "UserData.h"

@implementation UserData
@synthesize name = _name;
@synthesize image = _image;
@synthesize intro = _intro;

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if (self) {
        _name = [coder decodeObjectForKey:@"userName"];
        _image = [coder decodeObjectForKey:@"userImage"];
        _intro = [coder decodeObjectForKey:@"userIntro"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_name forKey:@"userName"];
    [coder encodeObject:_image forKey:@"userImage"];
    [coder encodeObject:_intro forKey:@"userIntro"];
}

- (void)dealloc
{
    self.name = nil;
    self.image = nil;
    self.intro = nil;
}

@end
