//
//  AddUserViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/05/05.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "AddUserViewController.h"

#import "UserData.h"
#import "NavigationBarTextColor.h"

@interface AddUserViewController ()

@end

@implementation AddUserViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [self back];
}

-(void)viewWillAppear:(BOOL)animated{
    [tf becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.allowsSelection = NO;
    
    [NavigationBarTextColor setNavigationTitleColor:self.navigationItem withString:@"友だち追加"];
    
    imgView.userInteractionEnabled = YES;
    imgView.image = [UIImage imageNamed:@"pimage.png"];
}

-(IBAction)done{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    
    NSData *data = (NSData *)[store objectForKey:@"userDatas"];
    NSMutableArray *_userDatas = [NSMutableArray array];
    
    if([store objectForKey:@"userDatas"]){
        NSData *data = (NSData *)[store objectForKey:@"userDatas"];
        _userDatas = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    BOOL chofuku = NO;
    for (int i = 0; i < _userDatas.count; i++) {
        UserData *userData = [_userDatas objectAtIndex:i];
        if([userData.name isEqualToString:tf.text]) chofuku = YES;
    }
    
    if(!chofuku){//ユーザー名重複判定
        UserData *userData = [[UserData alloc] init];
        userData.name = tf.text;
        
        if(imgView.image == [UIImage imageNamed:@"pimage.png"]) [self trimImage:[UIImage imageNamed:@"pimage.png"]];
        NSData *pngData = [[NSData alloc] initWithData:UIImagePNGRepresentation(imgView.image)];
        userData.image = pngData;
        
        userData.intro = tv.text;
        
        [_userDatas addObject:userData];
        
        data = [NSKeyedArchiver archivedDataWithRootObject:_userDatas];
        [store setObject:data forKey:@"userDatas"];
        [store synchronize];
        
        [self cancel];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"この名前は既に使われています" message:@"別の名前に変更してください" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(IBAction)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)hantei{
    if(![tf.text isEqualToString:@""]){
        done.enabled = YES;
    }else{
        done.enabled = NO;
    }
}

#pragma mark - Image Picker

- (void)selectPhoto {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Library",nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType;
    switch (buttonIndex) {
        case 0:
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
            
        default:
            return;
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        return;
    }
    
    /*---イメージピッカーの生成---*/
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];

    picker.sourceType = sourceType;
    picker.allowsEditing = true;
    picker.delegate = (id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
    //<UINavigetionControllerDelegate, UIImagePickerControllerDelegate>
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self trimImage:[info objectForKey:UIImagePickerControllerEditedImage]];
    
    /*// グラフィックスコンテキストを作る
    CGSize size = { 44, 44 };
    UIGraphicsBeginImageContext(size);
    
    // 画像を縮小して描画する
    CGRect rect;
    rect.origin = CGPointZero;
    rect.size = size;
    [originalImage drawInRect:rect];*/
    
    /*// 描画した画像を取得する
    UIImage *shrinkedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();*/
}

-(void)trimImage:(UIImage *)image{
    UIImage *originalImage = image;
    float hoge;
    if(originalImage.size.height > originalImage.size.width){
        hoge = originalImage.size.width;
    }else{
        hoge = originalImage.size.height;
    }
    
    [CoreImageHelper centerCroppingImageWithImage:originalImage atSize:CGSizeMake(hoge, hoge) completion:^(UIImage *resultImg){
        [CoreImageHelper resizeAspectFitImageWithImage:resultImg atSize:100.f completion:^(UIImage *resultImg2){
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.image = resultImg2;
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    switch (touch.view.tag) {
        case 1:
            [self selectPhoto];
            break;
        default:
            break;
    }
    
}

@end
