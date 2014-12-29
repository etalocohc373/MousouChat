//
//  MessageCell.m
//  LowriDev
//
//  Created by Logan Wright on 3/17/14
//  Copyright (c) 2014 Logan Wright. All rights reserved.
//


/*
 Mozilla Public License
 Version 2.0
 */


#import "MessageCell.h"
#import "MyMacros.h"

#import "RNBlurModalView.h"
#import "CustomAlertView.h"
#import "UserData.h"

// External Constants
int const outlineSpace = 22; // 11 px on each side for border
int const maxBubbleWidth = 260; // Max Bubble Size

// Message Dict Keys
NSString * const kMessageSize = @"size";
NSString * const kMessageRuntimeSentBy = @"runtimeSentBy";

#if defined(__has_include) 
// (namespace)
#if __has_include("FSChatManager.h")
static NSString * kMessageContent = @"content";
static NSString * kMessageTimestamp = @"timestamp";
#else
NSString * const kMessageContent = @"content";
NSString * const kMessageTimestamp = @"timestamp"; // Will eventually be used to access & display timestamps 
#endif
#else
#endif

// Instance Level Constants
static int offsetX = 6; // 6 px from each side
// Minimum Bubble Height
static int minimumHeight = 30;

@interface MessageCell()

// Who Sent The Message
@property (nonatomic) SentBy sentBy;

// Received Size
@property CGSize textSize;

// Bubble, Text, ImgV
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UILabel *bgLabel;
@property (strong, nonatomic) UILabel *readLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation MessageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        self.contentView.layer.rasterizationScale = 2.0f;
        self.contentView.layer.shouldRasterize = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        // Blue
        _opponentColor = [UIColor colorWithRed:0.142954 green:0.60323 blue:0.862548 alpha:0.88];
        // Green
        _userColor = [UIColor colorWithRed:0.14726 green:0.838161 blue:0.533935 alpha:1];
        
        if (!_bgLabel) {
            _bgLabel = [UILabel new];
            _bgLabel.layer.rasterizationScale = 2.0f;
            _bgLabel.layer.shouldRasterize = YES;
            _bgLabel.layer.borderWidth = 2;
            _bgLabel.layer.cornerRadius = minimumHeight / 2;
            _bgLabel.alpha = .925;
            [self.contentView addSubview:_bgLabel];
        }
        
        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN" size:11];
            _nameLabel.layer.rasterizationScale = 2.0f;
            _nameLabel.layer.shouldRasterize = YES;
            _nameLabel.textColor = [UIColor darkTextColor];
            [self.contentView addSubview:_nameLabel];
        }
        
        if (!_textLabel) {
            _textLabel = [UILabel new];
            _textLabel.layer.rasterizationScale = 2.0f;
            _textLabel.layer.shouldRasterize = YES;
            _textLabel.font = [UIFont systemFontOfSize:15.0f];
            //_textLabel.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN W6" size:15.0];
            _textLabel.textColor = [UIColor darkTextColor];
            _textLabel.numberOfLines = 0;
            [self.contentView addSubview:_textLabel];
        }
        
        if(!_timeLabel) {
            _timeLabel = [UILabel new];
            _timeLabel.font = [UIFont systemFontOfSize:10.0f];
            _timeLabel.textColor = [UIColor darkTextColor];
            _timeLabel.numberOfLines = 1;
            [self.contentView addSubview:_timeLabel];
        }
        
        if(!_readLabel) {
            _readLabel = [UILabel new];
            // _readLabel.frame = CGRectMake(_textLabel.center.x - (_textLabel.bounds.size.width / 2 + 40), _textLabel.bounds.size.height / 2, 25, _textLabel.bounds.size.height / 2);
            _readLabel.text = @"既読";
            _readLabel.font = [UIFont systemFontOfSize:10.0f];
            _readLabel.textColor = [UIColor darkTextColor];
            _readLabel.numberOfLines = 1;
            _readLabel.hidden = YES;
            [self.contentView addSubview:_readLabel];
        }
    }
    
    //FIXME: [NSObject cancelPreviousPerformRequestsWithTarget:nil selector:@selector(makeReadLabel) object:nil];
    
    [self performSelector:@selector(makeReadLabel) withObject:nil afterDelay:[[NSUserDefaults standardUserDefaults]floatForKey:@"kidokuDelay"]];
    
    return self;
}

#pragma mark - Make 既読Label
- (void)makeReadLabel
{
    //NSLog(@"%@", _message[kMessageRuntimeSentBy]);
    if([_message[kMessageRuntimeSentBy] isEqualToString:@"0"]) {
        
        if(!_readLabel.frame.size.width) _readLabel.frame = CGRectMake(_timeLabel.frame.origin.x, 0, 30, _timeLabel.frame.size.height);
        
        //[self.contentView addSubview:_readLabel];
        _readLabel.hidden = NO;
    }
}

#pragma mark GETTERS | SETTERS

- (void) setOpponentImage:(UIImage *)opponentImage {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.userInteractionEnabled = YES;
        _imageView.tag = 1;
        _imageView.frame = CGRectMake(offsetX / 2, 0, minimumHeight, minimumHeight);
        _imageView.layer.cornerRadius = minimumHeight / 5;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.rasterizationScale = 2;
        _imageView.layer.shouldRasterize = YES;
        
        [self.contentView addSubview:_imageView];
    }
    
    if (_sentBy == kSentByUser || !_imageView.image) {
        // If sentby current user, or no image, hide imageView;
        _imageView.image = nil;
        _imageView.hidden = YES;
    } else {
        for (UIView * v in @[_bgLabel, _textLabel, _timeLabel]) {
            v.center = CGPointMake(v.center.x + _imageView.bounds.size.width, v.center.y);
        }
        _imageView.hidden = NO;
    }
    
    _imageView.image = opponentImage;
}

- (UIImage *) opponentImage {
    return _imageView.image;
}

- (void) setOpponentColor:(UIColor *)opponentColor {
    if (_sentBy == kSentByOpponent) {
        _bgLabel.layer.borderColor = opponentColor.CGColor;
    }
    _opponentColor = opponentColor;
}

- (void) setUserColor:(UIColor *)userColor {
    if (_sentBy == kSentByUser) {
        _bgLabel.layer.borderColor = userColor.CGColor;
    }
    _userColor = userColor;
}

- (void) setMessage:(NSDictionary *)message {
    _message = message;
    [self drawCell];
}


#pragma mark - DrawCell
//FIXME:座標のズレ
- (void) drawCell {
    
    // Get Our Stuff
    _textSize = [_message[kMessageSize] CGSizeValue];
    _textLabel.text = _message[kMessageContent];
    _sentBy = [_message[kMessageRuntimeSentBy] intValue];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"HH:mm";
    _timeLabel.text = [df stringFromDate:_message[@"daySent"]];
    
    
    // the height that we want our text bubble to be
    CGFloat height = self.contentView.bounds.size.height - 10;
    if (height < minimumHeight) height = minimumHeight;
    
    if (_sentBy == kSentByUser) {
        // then this is a message that the current user created . . .
        _bgLabel.frame = (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])) ? CGRectMake(ScreenWidth() - offsetX, 0, -_textSize.width - outlineSpace, height) : CGRectMake(ScreenHeight() - offsetX, 0, -_textSize.width - outlineSpace, height);
        _bgLabel.layer.borderColor = _userColor.CGColor;
    } else if(_sentBy == kSentByOpponent) {
        // sent by opponent
        _bgLabel.frame = CGRectMake(offsetX, 15, _textSize.width + outlineSpace, height);
        _bgLabel.layer.borderColor = _opponentColor.CGColor;
        
        NSArray *array = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"talks"]];
        _nameLabel.text = [array objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selecteduser"]];
        _nameLabel.frame = CGRectMake(_imageView.frame.origin.x+minimumHeight+5, 0, _bgLabel.frame.size.width, 13);
    }
    
    // Add image if we have one
    if (_sentBy == kSentByUser || !_imageView.image) {
        // If sentby current user, or no image, hide imageView;
        _imageView.image = nil;
        _imageView.hidden = YES;
        _nameLabel.text = @"";
    } else {
        for (UIView * v in @[_bgLabel, _textLabel,  _timeLabel]) {
            v.center = CGPointMake(v.center.x + _imageView.bounds.size.width, v.center.y);
        }
        _imageView.hidden = NO;
    }
    
    // position _textLabel in the _bgLabel;
    
    if([_message[kMessageRuntimeSentBy] isEqualToString:@"0"]){
        _textLabel.frame = CGRectMake(_bgLabel.frame.origin.x + (outlineSpace / 2), 0, _bgLabel.bounds.size.width - outlineSpace, _bgLabel.bounds.size.height);
        
        _timeLabel.frame = CGRectMake(_textLabel.center.x - (_textLabel.bounds.size.width / 2 + 40), _textLabel.bounds.size.height / 2, 30, _textLabel.bounds.size.height / 2);
        
        _readLabel.frame = CGRectMake(_timeLabel.frame.origin.x, _timeLabel.frame.origin.y - _timeLabel.frame.size.height, 30, _timeLabel.frame.size.height);
    }
    else {
        _textLabel.frame = CGRectMake(_bgLabel.frame.origin.x + (outlineSpace / 2), 15, _bgLabel.bounds.size.width - outlineSpace, _bgLabel.bounds.size.height);
        
        _timeLabel.frame = CGRectMake(_textLabel.center.x + (_textLabel.bounds.size.width / 2 + 15), _textLabel.bounds.size.height / 2, 30, _textLabel.bounds.size.height / 2);
        
        _readLabel.frame = CGRectMake(_timeLabel.frame.origin.x, _timeLabel.frame.origin.y - _timeLabel.frame.size.height, 30, _timeLabel.frame.size.height);
        
    }
    
    _bgLabel.layer.backgroundColor = [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9] CGColor];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    RNBlurModalView *modal;
    UIView *view;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[NSUserDefaults standardUserDefaults] integerForKey:@"selecteduser"] inSection:1];
    editPath = indexPath;
    switch (touch.view.tag) {
        case 1:
            view = [self setUpAlertViewForIndexPath:indexPath];
            
            modal = [[RNBlurModalView alloc] initWithView:view];
            modal.dismissButtonRight = YES;
            
            [modal show];
            break;
            
        default:
            break;
    }
    
}

-(UIView *)setUpAlertViewForIndexPath:(NSIndexPath *)indexPath{
    UIImage *profileImage;
    NSString *name;
    NSString *intro;
    
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    NSData *data = (NSData *)[store objectForKey:@"userDatas"];
    NSArray *_userDatas = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    
    if(indexPath.section){
        UserData *userData = [_userDatas objectAtIndex:indexPath.row];
        profileImage = [UIImage imageWithData:userData.image];
        name = userData.name;
        intro = userData.intro;
    }else{
        profileImage = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"myimage"]];
        name = [[NSUserDefaults standardUserDefaults] objectForKey:@"myname"];
        intro = [[NSUserDefaults standardUserDefaults] objectForKey:@"aboutme"];
    }
    
    UINib *nib = [UINib nibWithNibName:@"CustomAlertView" bundle:nil];
    CustomAlertView *view = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    view.layer.cornerRadius = 5.f;
    view.layer.borderColor = [UIColor colorWithRed:0.592 green:0.435 blue:0.776 alpha:1.0].CGColor;
    //view.layer.borderWidth = 2.f;
    
    view.profileImgView.layer.cornerRadius = 5.0;
    //view.profileImgView.layer.borderWidth = 1.0;
    view.profileImgView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    view.profileImgView.layer.masksToBounds = YES;
    [view.profileImgView setImage:profileImage];
    
    view.nameLabel.text = name;
    [view.nameLabel sizeToFit];
    
    view.introLabel.numberOfLines = 2;
    view.introLabel.text = intro;
    [view.introLabel sizeToFit];
    
    CALayer *rightBorder = [CALayer layer];
    //rightBorder.borderColor = [[UIColor colorWithRed:0.592 green:0.435 blue:0.776 alpha:1.0] CGColor];
    rightBorder.borderColor = [[UIColor lightGrayColor] CGColor];
    rightBorder.borderWidth = 1.f;
    rightBorder.frame = CGRectMake(-2, 1, CGRectGetWidth(view.talkBtn.frame)+2, CGRectGetHeight(view.talkBtn.frame)+1);
    [view.talkBtn.layer addSublayer:rightBorder];
    [view.talkBtn addTarget:self action:@selector(jumpToTalk) forControlEvents:UIControlEventTouchUpInside];
    view.talkBtn.backgroundColor = [UIColor whiteColor];
    
    CALayer *leftBorder = [CALayer layer];
    leftBorder.borderColor = [[UIColor lightGrayColor] CGColor];;
    leftBorder.borderWidth = 1.f;
    leftBorder.frame = CGRectMake(-1, 1, CGRectGetWidth(view.editBtn.frame)+2, CGRectGetHeight(view.editBtn.frame)+1);
    [view.editBtn.layer addSublayer:leftBorder];
    [view.editBtn addTarget:self action:@selector(editProfile) forControlEvents:UIControlEventTouchUpInside];
    view.editBtn.backgroundColor = [UIColor whiteColor];
    
    return view;
}

-(void)jumpToTalk{
    
}

-(void)editProfile{
    if(!editPath.section) [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"editMain"];
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"editMain"];
        [[NSUserDefaults standardUserDefaults] setInteger:editPath.row forKey:@"editUserNum"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //FIXME: UIViewController *viewcon = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
    //FIXME: [self presentViewController:viewcon animated:YES completion:nil];
}

@end
