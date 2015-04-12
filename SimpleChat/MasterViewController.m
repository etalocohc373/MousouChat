//
//  MasterViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/05/04.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "MasterViewController.h"
#import "ViewController.h"
#import "NavigationBarTextColor.h"
#import <Social/Social.h>
#import "SettingViewController.h"
#import "KeywordsCell.h"
#import "WSCoachMarksView.h"
#import "UserData.h"
#import "KeywordData.h"

@interface KeywordsCellData:NSObject {
    BOOL _isChecked;
}
@property(nonatomic, assign) BOOL isChecked;
@end

@implementation KeywordsCellData
@synthesize isChecked = _isChecked;

@end

@interface MasterViewController ()<SettingViewControllerDelegate> {
    NSMutableArray *_objects;
}
@end

@interface MasterViewController ()

@end

@implementation MasterViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [NavigationBarTextColor setNavigationTitleColor:self.navigationItem withString:@"キーワード設定"];
    
    
    back = [[UIBarButtonItem alloc] initWithTitle:@"＜" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //self.navigationItem.leftBarButtonItem = back;
    
    /*
    NSMutableArray *items = [NSMutableArray array];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    
    [items addObject:space];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    
    [items addObject:editButton];
    [tb setItems:items];
     */
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    tv.delegate = self;
    tv.dataSource = self;
    tv.rowHeight = 50.0;
    
    tv.separatorInset = UIEdgeInsetsZero;
    if ([tv respondsToSelector:@selector(layoutMargins)]) {
        tv.layoutMargins = UIEdgeInsetsZero;
    }
    
    UINib *nib = [UINib nibWithNibName:@"KeywordsCell" bundle:nil];
    [tv registerNib:nib forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [tv deselectRowAtIndexPath:tv.indexPathForSelectedRow animated:YES];
    
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    
    talks = [NSArray arrayWithArray:[store objectForKey:@"talks"]];
    
    _keywordDatas = [NSMutableArray array];
    
    NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
    if([store objectForKey:key]){
        NSData *data = (NSData *)[store objectForKey:key];
        _keywordDatas = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    }
    
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < _keywordDatas.count; i++){
        KeywordsCellData *cellData = [[KeywordsCellData alloc] init];
        cellData.isChecked = NO;
        [tmpArr addObject:cellData];
    }
    _cellDataArray = [[NSArray alloc] initWithArray:tmpArr];
    
    [tv reloadData];
    
    tv.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UINib *nib = [UINib nibWithNibName:@"CustomToolBar" bundle:nil];
    customBar = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    customBar.frame = CGRectMake(0, 568, 320, 44);
    customBar.delegate = (id<CustomToolBarDelegate>)self;
    [self.view addSubview:customBar];
    
    [store setObject:nil forKey:@"keywordDate"];
    [store setBool:NO forKey:@"keywordDoRepeat"];
    [store synchronize];
    
    if([self isFirstRun]) [self activateTutorial];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return _objects.count;
    return _keywordDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeywordsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if(!cell) cell = [[KeywordsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    
    cell.delegate = (id<KeywordsCellDelegate>)self;
    
    cell.separatorInset = UIEdgeInsetsZero;
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    KeywordData *keywordData = [_keywordDatas objectAtIndex:indexPath.row];
    
    cell.wordLabel.text = keywordData.reply;
    
    cell.keywordLabel.text = keywordData.keyword;
    if(keywordData.setTime){
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"MM-dd HH:mm";
        
        cell.keywordLabel.text = [df stringFromDate:keywordData.sendDate];
    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, 270, 50)];
    imgView.image = [UIImage imageNamed:@"fukidashi2.png"];
    [cell.contentView addSubview:imgView];
    [cell.contentView sendSubviewToBack:imgView];
    
    [cell setCheckboxState:[(KeywordsCellData *)[_cellDataArray objectAtIndex:indexPath.row] isChecked]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        KeywordData *keywordData = [_keywordDatas objectAtIndex:indexPath.row];
        if(keywordData.setTime){
            ViewController *hoge = [[ViewController alloc] init];
            [NSObject cancelPreviousPerformRequestsWithTarget:hoge selector:@selector(henshin:) object:nil];
            NSLog(@"%@", hoge);
        }
        
        [_objects removeObjectAtIndex:indexPath.row];
        [_keywordDatas removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:[store integerForKey:@"selecteduser"]]];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_keywordDatas];
    
    [store setObject:data forKey:key];
    [store synchronize];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

/*- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    int from = (int)sourceIndexPath.row;
    int to = (int)destinationIndexPath.row;
    
    NSString *hogekey = [keyword objectAtIndex:from];
    [keyword removeObjectAtIndex:from];
    [keyword insertObject:hogekey atIndex:to];
    
    hogekey = [reply objectAtIndex:from];
    [reply removeObjectAtIndex:from];
    [reply insertObject:hogekey atIndex:to];
    
    NSString *key = [NSString stringWithFormat:@"keywords%@", [talks objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selecteduser"]]];
    [[NSUserDefaults standardUserDefaults] setObject:keyword forKey:key];
    
    key = [NSString stringWithFormat:@"replies%@", [talks objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"selecteduser"]]];
    [[NSUserDefaults standardUserDefaults] setObject:reply forKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}*/

- (void)cell:(KeywordsCell *)cell checkboxTappedEvent:(UITouch *)touch
{
    CGPoint touchPt = [tv convertPoint:[touch locationInView:self.view] fromView:tv.superview];
    NSIndexPath *indexPath = [tv indexPathForRowAtPoint:touchPt];
    KeywordsCellData *cellData = [_cellDataArray objectAtIndex:indexPath.row];
    
    cellData.isChecked = !cellData.isChecked;
    [cell setCheckboxState:cellData.isChecked];
    
    BOOL checked = NO;
    
    for (int i = 0; i < _cellDataArray.count; i++) {
        KeywordsCellData *hoge = [_cellDataArray objectAtIndex:i];
        if(hoge.isChecked) checked = YES;
    }
    
    [self moveCustomToolBarUp:checked];
    
    [self changeEditBtnStatus];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self moveCustomToolBarUp:NO];
    
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    
    [store setInteger:[indexPath row] forKey:@"selectedrow"];
    [store setBool:YES forKey:@"editKeyword"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"setting"];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:controller];
    nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nc animated:YES completion:nil];
    
    [tv deselectRowAtIndexPath:tv.indexPathForSelectedRow animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ShowSettingView"]) {
        SettingViewController *vc = (SettingViewController *)[[[segue destinationViewController]viewControllers]objectAtIndex:0];
        vc.delegate = self;
    }
}

-(void)settingViewControllerDidFinish:(SettingViewController *)controller item:(NSString *)item{
    if(!_objects){
        _objects = [[NSMutableArray alloc]init];
    }
    [_objects insertObject:item atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [tv insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (void)edit{
    NSMutableArray *items = [NSMutableArray array];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(edit)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [items addObject:space];
    
    if(!editing){
        [tv setEditing:YES animated:YES];
        [tv beginUpdates];
        editing = YES;
        [back setEnabled:NO];
        [items addObject:doneButton];
    }else{
        [tv setEditing:NO animated:YES];
        [tv endUpdates];
        editing = NO;
        [back setEnabled:YES];
        [items addObject:editButton];
    }
}

-(void)back{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isFirstRun
{
    if(_keywordDatas.count){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSMutableArray *hoge = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"didRunArray"]];
        
        if ([hoge containsObject:@"MasterViewController"]) return NO;
        
        [hoge addObject:@"MasterViewController"];
        
        [userDefaults setObject:hoge forKey:@"didRunArray"];
        [userDefaults synchronize];
        
        return YES;
    }
    else return NO;
}

-(void)activateTutorial{
    NSArray *coachMarks = @[
                            @{
                                @"rect": [NSValue valueWithCGRect:(CGRect){{0, 60},{320, 58}}],
                                @"caption": @"タップしてキーワードを編集"
                                }
                            ];
    WSCoachMarksView *coachMarksView = [[WSCoachMarksView alloc] initWithFrame:self.navigationController.view.bounds coachMarks:coachMarks];
    [self.navigationController.view addSubview:coachMarksView];
    [coachMarksView start];
}

-(void)moveCustomToolBarUp:(BOOL)up{
    if(up && customBar.center.y < 568) return;
    if(!up && customBar.center.y > 568) return;
    
    float movement = 44.f;
    if(up) movement *= -1;
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         customBar.center = CGPointMake(customBar.center.x, customBar.center.y + movement);
                     }];
}

#pragma mark - Custom Toolbar Delegate

-(void)closeButtonTappedEvent{
    for (NSInteger j = 0; j < [tv numberOfSections]; j++){
        for (NSInteger i = 0; i < [tv numberOfRowsInSection:j]; i++){
            KeywordsCell *cell = (KeywordsCell *)[tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            [cell setCheckboxState:NO];
        }
    }
}

-(void)changeEditBtnStatus{
    int count = 0;
    
    for (int i = 0; i < _cellDataArray.count; i++) {
        KeywordsCellData *cellData = [_cellDataArray objectAtIndex:i];
        if(cellData.isChecked) count++;
    }
    
    if(count <= 1) [customBar setEditBtnState:YES];
    else [customBar setEditBtnState:NO];
}

-(void)deleteButtonTappedEvent{
    NSIndexPath *indexPath;
    for (int i = 0; i < _cellDataArray.count; i++) {
        KeywordsCellData *cellData = [_cellDataArray objectAtIndex:i];
        if(cellData.isChecked){
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self tableView:tv commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
        }
    }
    
    [self moveCustomToolBarUp:NO];
}

-(void)editButtonTappedEvent{
    NSIndexPath *indexPath = [self getCheckedIndexPath];
    
    [self tableView:tv didSelectRowAtIndexPath:indexPath];
    
    [self moveCustomToolBarUp:NO];
}

-(void)actionButtonTappedEvent{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"共有" delegate:self cancelButtonTitle:@"キャンセル" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", @"LINE", nil];
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSIndexPath *indexPath = [self getCheckedIndexPath];
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    NSData *data = (NSData *)[store objectForKey:@"userDatas"];
    NSArray *_userDatas = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    UserData *userData = [_userDatas objectAtIndex:[store integerForKey:@"selecteduser"]];
    
    KeywordData *keywordData = [_keywordDatas objectAtIndex:indexPath.row];
    
    NSString *str = [NSString stringWithFormat:@"自分「%@」 %@「%@」", keywordData.keyword, userData.name, keywordData.reply];
    
    switch (buttonIndex) {
        case 0:
            [self makeShare:str];
            break;
        case 1:
            [self makeTweet:str];
            break;
        case 2:
            [self makeLine:str];
            break;
    }
    
}

- (void)makeShare:(NSString *)sender {
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"シェアエラー"
                                                        message:@"facebookアカウントが設定されていません。"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    NSString *text = @"hogehoge";
    NSURL *URL = [NSURL URLWithString:@"hogehoge"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"hogehoge"]];
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controller setInitialText:text];
    [controller addURL:URL];
    [controller addImage:[[UIImage alloc] initWithData:imageData]];
    controller.completionHandler =^(SLComposeViewControllerResult result){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)makeTweet:(NSString *)sender {
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ツイートエラー"
                                                        message:@"Twitterアカウントが設定されていません。"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    NSString *text = sender;
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [controller setInitialText:text];
    controller.completionHandler = ^(SLComposeViewControllerResult result){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)makeLine:(NSString *)sender{
    NSString *string = sender;
    
    string = [string
              stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *LINEUrlString = [NSString
                               stringWithFormat:@"line://msg/text/%@", string];
    
    //LINEがインストールされているか確認。されていなければアラート→AppStoreを開く
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:LINEUrlString]]) {
        [[UIApplication sharedApplication]
         openURL:[NSURL URLWithString:LINEUrlString]];
    } else {
        [self cannotOpenAlert];
    }
}

-(void)cannotOpenAlert{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"LINEがインストールされていません"
                          message:@"LINEをインストールしますか？"
                          delegate:self
                          cancelButtonTitle:@"いいえ"
                          otherButtonTitles:@"はい", nil
                          ];
    [alert show];
}

-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://いいえのとき
            break;
        case 1://はいのとき
            [[UIApplication sharedApplication]
             openURL:[NSURL
                      URLWithString:@"https://itunes.apple.com/jp/app/line/id443904275?mt=8"]];
            break;
    }
}

-(NSIndexPath *)getCheckedIndexPath{
    NSIndexPath *indexPath;
    
    for (int i = 0; i < _cellDataArray.count; i++) {
        KeywordsCellData *cellData = [_cellDataArray objectAtIndex:i];
        if(cellData.isChecked){
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            break;
        }
    }
    
    return indexPath;
}

@end
