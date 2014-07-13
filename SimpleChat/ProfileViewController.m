//
//  ProfileViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/05/06.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    if(![store objectForKey:@"myimage"]){
        NSData *pngData = [[NSData alloc] initWithData:UIImagePNGRepresentation([UIImage imageNamed:@"pimage.png"])];
        [store setObject:pngData forKey:@"myimage"];
    }
    if(![store objectForKey:@"myname"]) [store setObject:@"Hoge" forKey:@"myname"];
    if(![store objectForKey:@"aboutme"]) [store setObject:@"特になし" forKey:@"aboutme"];
    [store synchronize];
    
    imgView.image = [[UIImage alloc] initWithData:[store objectForKey:@"myimage"]];
    name.text = [store objectForKey:@"myname"];
    about.text = [store objectForKey:@"aboutme"];
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
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    float hoge;
    if(originalImage.size.height > originalImage.size.width){
        hoge = originalImage.size.width;
    }else{
        hoge = originalImage.size.height;
    }
    
    [CoreImageHelper centerCroppingImageWithImage:originalImage atSize:CGSizeMake(hoge, hoge) completion:^(UIImage *resultImg){
        NSLog(@"width: %.0f height: %.0f", resultImg.size.width, resultImg.size.height);
        [CoreImageHelper resizeAspectFitImageWithImage:resultImg atSize:70.f completion:^(UIImage *resultImg2){
            imgView.image = resultImg2;
            [imgView sizeToFit];
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
