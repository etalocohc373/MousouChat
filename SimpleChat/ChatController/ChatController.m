//
//  ChatController.m
//  LowriDev
//
//  Created by Logan Wright on 3/17/14
//  Copyright (c) 2014 Logan Wright. All rights reserved.
//


/*
 Mozilla Public License
 Version 2.0
 */


#import "ChatController.h"
#import "MessageCell.h"
#import "MyMacros.h"

#define SCREEN_HEIGHT [[UIScreen mainScreen] applicationFrame].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] applicationFrame].size.width

static NSString * kMessageCellReuseIdentifier = @"MessageCell";
static int connectionStatusViewTag = 1701;
static int chatInputStartingHeight = 40;


@interface ChatController ()

{
    // Used for scroll direction
    CGFloat lastContentOffset;
}

// View Properties
@property (strong, nonatomic) TopBar * topBar;
@property (strong, nonatomic) ChatInput * chatInput;
@property (strong, nonatomic) UICollectionView * myCollectionView;

@end

@implementation ChatController

#pragma mark INITIALIZATION

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        //_topBar.frame = CGRectMake(0, 0, 320, 44);
        
        UIBarButtonItem *btn =
        [[UIBarButtonItem alloc]
         initWithImage:[UIImage imageNamed:@"addword.png"]  // 画像を指定
         style:UIBarButtonItemStylePlain  // スタイルを指定（※下記表参照）
         target:self  // デリゲートのターゲットを指定
         action:@selector(topRightPressed)  // ボタンが押されたときに呼ばれるメソッドを指定
         ];
        
        self.navigationItem.rightBarButtonItem = btn;

        
        // TopBar
        _topBar = [[TopBar alloc]init];
        //_topBar.title = @"Chat Controller";
        //_topBar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        _topBar.backgroundColor = [UIColor blackColor];
        _topBar.delegate = self;
        
        
        [self.view addSubview:_topBar];
        
        
        // ChatInput
        _chatInput = [[ChatInput alloc]init];
        _chatInput.stopAutoClose = NO;
        //_chatInput.placeholderLabel.text = @"  Send A Message";
        _chatInput.delegate = self;
        _chatInput.backgroundColor = [UIColor colorWithWhite:1 alpha:0.825f];
        
        // Set Up Flow Layout
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc]init];
        flow.sectionInset = UIEdgeInsetsMake(80, 0, 10, 0);
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.minimumLineSpacing = 6;
        
        //BackGround
        //_backgroundImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
        //_backgroundImg.image = [UIImage imageNamed:@"mizutama.png"];
        
        // Set Up CollectionView
        CGRect myFrame = (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation])) ? CGRectMake(0, 0, ScreenHeight(), ScreenWidth() - height(_chatInput)) : CGRectMake(0, 0, ScreenWidth(), ScreenHeight() - height(_chatInput));
        _myCollectionView = [[UICollectionView alloc]initWithFrame:myFrame collectionViewLayout:flow];
        //_myCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //_myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mizutama.png"]];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
        _myCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 2, 0, -2);
        _myCollectionView.allowsSelection = YES;
        _myCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_myCollectionView registerClass:[MessageCell class]
              forCellWithReuseIdentifier:kMessageCellReuseIdentifier];
        
        // Register Keyboard Notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    store = [NSUserDefaults standardUserDefaults];
}

- (void) viewWillAppear:(BOOL)animated
{
    // Add views here, or they will create problems when launching in landscape
    
    [self.view addSubview:_myCollectionView];
    
    NSArray *array = [NSArray array];
    array = [store objectForKey:@"talks"];
    self.title = [array objectAtIndex:[store integerForKey:@"selecteduser"]];
    
    [store setObject:self.title forKey:@"controllerOpen"];
    [store synchronize];
    
    // Scroll CollectionView Before We Start
    [self.view addSubview:_chatInput];
    
    _messagesArray = [NSMutableArray array];
    
    [_myCollectionView reloadData];
    
    //[_TopBar setTitle];
    
    //メッセージ読み込み
    NSString *key = [NSString stringWithFormat:@"message%@", [[store objectForKey:@"talks"] objectAtIndex:[store integerForKey:@"selecteduser"]]];
    
    if([store objectForKey:key]) _messagesArray = [[NSKeyedUnarchiver unarchiveObjectWithData:[store objectForKey:key]] mutableCopy];
    else _messagesArray = [NSMutableArray new];
    //ここまで
    
    // Fix if we receive Null
    if (![_messagesArray.class isSubclassOfClass:[NSArray class]]) {
        _messagesArray = [NSMutableArray new];
    }
    
    [_myCollectionView reloadData];
    
    [self scrollToBottom];
    
    /*
    NSArray *hogeArray = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[store objectForKey:@"messageまっすー"]]];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[hogeArray objectAtIndex:hogeArray.count - 1]];
    
    NSLog(@"loadedSentBy: %@", dic[kMessageRuntimeSentBy]);
     */
}

-(void)viewWillDisappear:(BOOL)animated{
    [store setFloat:0 forKey:@"kidokuDelay"];
    [store setObject:nil forKey:@"controllerOpen"];
    [store synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CLEAN UP

- (void) removeFromParentViewController {
    
    [_chatInput removeFromSuperview];
    _chatInput = nil;
    
    [_messagesArray removeAllObjects];
    _messagesArray = nil;
    
    [_myCollectionView removeFromSuperview];
    _myCollectionView.delegate = nil;
    _myCollectionView.dataSource = nil;
    _myCollectionView = nil;
    
    _opponentImg = nil;
    
    [_topBar removeFromSuperview];
    _topBar = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [super removeFromParentViewController];
}

#pragma mark ROTATION CALLS

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Help Animation
    [_chatInput willRotate];
}
- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [_chatInput isRotating];
    _myCollectionView.frame = (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) ? CGRectMake(0, 0, ScreenHeight(), ScreenWidth() - height(_chatInput)) : CGRectMake(0, 0, ScreenWidth(), ScreenHeight() - chatInputStartingHeight);
    [_myCollectionView reloadData];
}
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [_chatInput didRotate];
    [self scrollToBottom];
}

#pragma mark CHAT INPUT DELEGATE

- (void) chatInputNewMessageSent:(NSString *)messageString {
    
    NSMutableDictionary * newMessageOb = [NSMutableDictionary new];
    newMessageOb[kMessageContent] = messageString;
    newMessageOb[kMessageTimestamp] = TimeStamp();
    
    if ([(NSObject *)_delegate respondsToSelector:@selector(chatController:didSendMessage:)]) {
        [_delegate chatController:self didSendMessage:newMessageOb];
    }
    else {
        NSLog(@"ChatController: ** DELEGATE OR PROTOCOL METHOD NOT SET ** ");
    }
}

#pragma mark TOP BAR DELEGATE

- (void) topLeftPressed {
    if ([(NSObject *)_delegate respondsToSelector:@selector(closeChatController:)]) {
        [_delegate closeChatController:self];
    }
    else {
        NSLog(@"ChatController: AutoClosing");
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) topMiddlePressed {
    // Currently Inactive
}

- (void) topRightPressed {
    // Currently Inactive
    UIStoryboard *storyBoard = [self.delegate getStoryBoard];
    
    UINavigationController *gameViewController = [storyBoard instantiateViewControllerWithIdentifier:@"waaaa"];
    
    [self presentViewController:gameViewController animated:YES completion:nil];
}

#pragma mark ADD NEW MESSAGE

- (void) addNewMessage:(NSDictionary *)message {
    
    if (_messagesArray == nil)  _messagesArray = [NSMutableArray new];
    
    // preload message into array;
    [_messagesArray addObject:message];
    
    NSLog(@"sentMessage: %@", message);
    NSString *key = [NSString stringWithFormat:@"message%@", [[store objectForKey:@"talks"] objectAtIndex:[store integerForKey:@"selecteduser"]]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_messagesArray];
    
    [store setObject:data forKey:key];
    
    [store synchronize];
    
    //NSArray *hogeArray = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:[store objectForKey:@"messageまっすー"]]];
    
    //NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[hogeArray objectAtIndex:hogeArray.count - 1]];
    
    // add extra cell, and load it into view;
    [_myCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:_messagesArray.count -1 inSection:0]]];
    
    [_myCollectionView reloadData];
    
    // show us the message
    [self scrollToBottom];
}

#pragma mark KEYBOARD NOTIFICATIONS

- (void) keyboardWillShow:(NSNotification *)note {
    
    if (!_chatInput.shouldIgnoreKeyboardNotifications) {
        
        NSDictionary *keyboardAnimationDetail = [note userInfo];
        UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        NSValue* keyboardFrameBegin = [keyboardAnimationDetail valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
        int keyboardHeight = (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])) ? keyboardFrameBeginRect.size.height : keyboardFrameBeginRect.size.width;
        
        _myCollectionView.scrollEnabled = NO;
        _myCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
            
            _myCollectionView.frame = (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation])) ? CGRectMake(0, 0, ScreenHeight(), ScreenWidth() - chatInputStartingHeight - keyboardHeight) : CGRectMake(0, 0, ScreenWidth(), ScreenHeight() - chatInputStartingHeight - keyboardHeight);
            
        } completion:^(BOOL finished) {
            if (finished) {
                
                [self scrollToBottom];
                _myCollectionView.scrollEnabled = YES;
                _myCollectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
            }
        }];
    }
}

- (void) keyboardWillHide:(NSNotification *)note {
    
    if (!_chatInput.shouldIgnoreKeyboardNotifications) {
        NSDictionary *keyboardAnimationDetail = [note userInfo];
        UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        _myCollectionView.scrollEnabled = NO;
        _myCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
           
            _myCollectionView.frame = (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation])) ? CGRectMake(0, 0, ScreenHeight(), ScreenWidth() - height(_chatInput)) : CGRectMake(0, 0, ScreenWidth(), ScreenHeight() - height(_chatInput));
            
        } completion:^(BOOL finished) {
            if (finished) {
                _myCollectionView.scrollEnabled = YES;
                _myCollectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
                [self scrollToBottom];
            }
        }];
    }
}

#pragma mark CONNECTION NOTIFICATIONS

- (void) isOffline {
    if ([self.view viewWithTag:connectionStatusViewTag] == nil) {
        UILabel * offlineStatus = [[UILabel alloc]init];
        offlineStatus.frame = CGRectMake(0, 0, ScreenWidth(), 30);
        offlineStatus.backgroundColor = [UIColor colorWithRed:0.322311 green:0.347904 blue:0.424685 alpha:1];
        offlineStatus.textColor = [UIColor whiteColor];
        offlineStatus.font = [UIFont boldSystemFontOfSize:16.0];
        offlineStatus.textAlignment = NSTextAlignmentCenter;
        offlineStatus.minimumScaleFactor = .3;
       
        
        offlineStatus.text = @"You're offline! Messages may not send.";
        offlineStatus.tag = connectionStatusViewTag;
        [self.view insertSubview:offlineStatus belowSubview:_topBar];
        [UIView animateWithDuration:.25 animations:^{
            offlineStatus.center = CGPointMake(self.view.center.x, offlineStatus.center.y + _topBar.bounds.size.height);
        }];
    }
}

- (void) isOnline {
    UILabel * offlineStatus = (UILabel *)[self.view viewWithTag:connectionStatusViewTag];
    if (offlineStatus != nil) {
        [UIView animateWithDuration:.25 animations:^{
            offlineStatus.center = CGPointMake(self.view.center.x, offlineStatus.center.y - _topBar.bounds.size.height);
        } completion:^(BOOL finished) {
            if (finished) {
                [offlineStatus removeFromSuperview];
            }
        }];
    }
}

#pragma mark COLLECTION VIEW METHODS

- (void) scrollToBottom {
    if (_messagesArray.count > 0) {
        static NSInteger section = 0;
        NSInteger item = [self collectionView:_myCollectionView numberOfItemsInSection:section] - 1;
        if (item < 0) item = 0;
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
        [_myCollectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }
}

/* Scroll To Top
- (void) scrollToTop {
    if (_myCollectionView.numberOfSections >= 1 && [_myCollectionView numberOfItemsInSection:0] >= 1) {
        NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [_myCollectionView scrollToItemAtIndexPath:firstIndex atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}
*/

/* To Monitor Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat difference = lastContentOffset - scrollView.contentOffset.y;
    if (lastContentOffset > scrollView.contentOffset.y && difference > 10) {
        // scrolled up
    }
    else if (lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0) {
        // scrolled down
        
    }
    lastContentOffset = scrollView.contentOffset.y;
}
*/

#pragma mark COLLECTION VIEW DELEGATE

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary * message = _messagesArray[[indexPath indexAtPosition:1]];
    
    static int offset = 20;
    
    if (!message[kMessageSize]) {
        NSString * content = [message objectForKey:kMessageContent];
        
        NSMutableDictionary * attributes = [NSMutableDictionary new];
        attributes[NSFontAttributeName] = [UIFont systemFontOfSize:15.0f];
        attributes[NSStrokeColorAttributeName] = [UIColor darkTextColor];
        
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithString:content
                                                                       attributes:attributes];
        
        // Here's the maximum width we'll allow our outline to be // 260 so it's offset
        int maxTextLabelWidth = maxBubbleWidth - outlineSpace;
        
        // set max width and height
        // height is max, because I don't want to restrict it.
        // if it's over 100,000 then, you wrote a fucking book, who even does that?
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(maxTextLabelWidth, 100000)
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            context:nil];
        
        message[kMessageSize] = [NSValue valueWithCGSize:rect.size];
        
        return CGSizeMake(width(_myCollectionView), rect.size.height + offset);
    }
    else {
        return CGSizeMake(_myCollectionView.bounds.size.width, [message[kMessageSize] CGSizeValue].height + offset);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return _messagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // Get Cell
    MessageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMessageCellReuseIdentifier
                                                                  forIndexPath:indexPath];
    

    // Set Who Sent Message
    NSMutableDictionary * message = _messagesArray[[indexPath indexAtPosition:1]];
    if (!message[kMessageRuntimeSentBy]) {
        
        // Random just for now, set at runtime
        int sentByNumb = 0;
        if([store boolForKey:@"nothenshin"]){
            sentByNumb = 1;
            [store setBool:NO forKey:@"nothenshin"];
        }
        if ([store boolForKey:@"henshin"]){
            sentByNumb = 0;
            [store setBool:NO forKey:@"henshin"];
        }
        [store synchronize];
        
        message[kMessageRuntimeSentBy] = [NSNumber numberWithInt:(sentByNumb == 0) ? kSentByOpponent : kSentByUser];
        
         //EXAMPLE IMPLEMENTATION
         // See if the sentBy associated with the message matches our currentUserId
         /*if ([_currentUserId isEqualToString:message[@"sentByUserId"]]) {
            message[kMessageRuntimeSentBy] = [NSNumber numberWithInt:kSentByUser];
         }
         else {
            message[kMessageRuntimeSentBy] = [NSNumber numberWithInt:kSentByOpponent];
         }*/
        
    }
    
    // Set the cell
    cell.opponentImage = _opponentImg;
    if (_opponentBubbleColor) cell.opponentColor = _opponentBubbleColor;
    if (_userBubbleColor) cell.userColor = _userBubbleColor;
    cell.message = message;
    
    return cell;
     
}

#pragma mark SETTERS | GETTERS

/*- (void) setMessagesArray:(NSMutableArray *)messagesArray {
    //_messagesArray = messagesArray;
    NSString *key = [NSString stringWithFormat:@"message%@", [[store objectForKey:@"talks"] objectAtIndex:[store integerForKey:@"selecteduser"]]];
    _messagesArray = [store objectForKey:key];
    
    // Fix if we receive Null
    if (![_messagesArray.class isSubclassOfClass:[NSArray class]]) {
        _messagesArray = [NSMutableArray new];
    }
    
    [_myCollectionView reloadData];
}*/

- (void) setChatTitle:(NSString *)chatTitle{
    _topBar.title = chatTitle;
    _chatTitle = chatTitle;
}

- (void) setTintColor:(UIColor *)tintColor {
    _chatInput.sendBtnActiveColor = tintColor;
    _topBar.tintColor = tintColor;
    _tintColor = tintColor;
}


- (UIStoryboard *)getStoryBoard2
{
    return self.storyboard;
}

@end
