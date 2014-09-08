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
    
    imgView.userInteractionEnabled = YES;
    imgView.image = [UIImage imageNamed:@"pimage.png"];
}

-(IBAction)done{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    
    NSArray *mar3 = [NSArray arrayWithArray:[store objectForKey:@"users"]];
    NSMutableArray *users = [NSMutableArray array];
    
    if(mar3) users = [mar3 mutableCopy];
    
    if([users indexOfObject:tf.text] == NSNotFound){
        [users addObject:tf.text];
        
        [store setObject:users forKey:@"users"];
        
        mar3 = [NSArray arrayWithArray:[store objectForKey:@"pimages"]];
        NSMutableArray *images = [NSMutableArray array];
        images = [mar3 mutableCopy];
        
        if(imgView.image == [UIImage imageNamed:@"pimage.png"]) [self trimImage:[UIImage imageNamed:@"pimage.png"]];
        
        NSData *pngData = [[NSData alloc] initWithData:UIImagePNGRepresentation(imgView.image)];
        [images addObject:pngData];
        [store setObject:images forKey:@"pimages"];
        
        [store synchronize];
        
        [self cancel];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"この名前は既に使われています" message:@"別の名前に変更してください" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        tf.text = @"";
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
        NSLog(@"width: %.0f height: %.0f", resultImg.size.width, resultImg.size.height);
        [CoreImageHelper resizeAspectFitImageWithImage:resultImg atSize:44.f completion:^(UIImage *resultImg2){
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
