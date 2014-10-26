//
//  AddUserViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/05/05.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "AddUserViewController.h"

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
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.227 green:0.114 blue:0.369 alpha:1.0];
    self.title = @"友だち追加";
    
    imgView.userInteractionEnabled = YES;
    imgView.image = [UIImage imageNamed:@"pimage.png"];
}

-(IBAction)done{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    
    NSArray *mar3 = [NSArray arrayWithArray:[store objectForKey:@"users"]];
    NSMutableArray *users = [NSMutableArray array];
    
    if(mar3) users = [mar3 mutableCopy];
    
    if([users indexOfObject:tf.text] == NSNotFound){//ユーザー名重複判定
        //ユーザー名保存
        [users addObject:tf.text];
        //ここまで
        
        //プロ画保存
        mar3 = [NSArray arrayWithArray:[store objectForKey:@"pimages"]];
        NSMutableArray *images = [NSMutableArray array];
        if(mar3) images = [mar3 mutableCopy];
        
        if(imgView.image == [UIImage imageNamed:@"pimage.png"]) [self trimImage:[UIImage imageNamed:@"pimage.png"]];
        
        NSData *pngData = [[NSData alloc] initWithData:UIImagePNGRepresentation(imgView.image)];
        [images addObject:pngData];
        //ここまで
        
        //自己紹介保存
        mar3 = [NSArray arrayWithArray:[store objectForKey:@"intros"]];
        NSMutableArray *intros = [NSMutableArray array];
        if(mar3) intros = [mar3 mutableCopy];
        
        [intros addObject:tv.text];
        //ここまで
        
        [store setObject:users forKey:@"users"];
        [store setObject:images forKey:@"pimages"];
        [store setObject:intros forKey:@"intros"];
        
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
        [CoreImageHelper resizeAspectFitImageWithImage:resultImg atSize:70.f completion:^(UIImage *resultImg2){
            imgView.image = resultImg2;
            [imgView sizeToFit];
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
