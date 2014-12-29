//
//  ProfileViewController.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/05/06.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "ProfileViewController.h"

#import "UserData.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createNavTitle:@"プロフィール"];
}

-(void)viewDidAppear:(BOOL)animated{
    [self back];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    
    NSData *data = (NSData *)[store objectForKey:@"userDatas"];
    _userDatas = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    
    about.font = [UIFont fontWithName:@"Hiragino Kaku Gothic ProN W6" size:22];
    
    if([store boolForKey:@"editMain"]){
        imgView.image = [[UIImage alloc] initWithData:[store objectForKey:@"myimage"]];
        name.text = [store objectForKey:@"myname"];
        about.text = [store objectForKey:@"aboutme"];
    }else{
        int editNum = (int)[store integerForKey:@"editUserNum"];
        UserData *userData = [_userDatas objectAtIndex:editNum];
        
        imgView.image = [[UIImage alloc] initWithData:userData.image];
        name.text = userData.name;
        about.text = userData.intro;
    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.227 green:0.114 blue:0.369 alpha:1.0];
    
    [self save];
}

-(void)save{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    
    if([store boolForKey:@"editMain"]) [store setObject:[[NSData alloc] initWithData:UIImagePNGRepresentation(imgView.image)] forKey:@"myimage"];
    else{
        UserData *userData = [_userDatas objectAtIndex:[store integerForKey:@"editUserNum"]];
        userData.image = [[NSData alloc] initWithData:UIImagePNGRepresentation(imgView.image)];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_userDatas];
        [store setObject:data forKey:@"userDatas"];
    }
    
    [store synchronize];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section){
        [[NSUserDefaults standardUserDefaults] setInteger:indexPath.section - 1 forKey:@"editprof"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        EditProfileViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"edit"];
        [self.navigationController pushViewController:gameViewController animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Image Picker

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
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Library",nil];
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
        [CoreImageHelper resizeAspectFitImageWithImage:resultImg atSize:70.f completion:^(UIImage *resultImg2){
            imgView.image = resultImg2;
            [imgView sizeToFit];
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createNavTitle:(NSString *)title{
    UILabel* tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    tLabel.text = title;
    tLabel.textColor = [UIColor whiteColor];
    tLabel.backgroundColor = [UIColor clearColor];
    tLabel.textAlignment = NSTextAlignmentCenter;
    tLabel.adjustsFontSizeToFitWidth = YES;
    tLabel.font = [UIFont fontWithName:@"MS Gothic" size:19];
    self.navigationItem.titleView = tLabel;
}

@end
