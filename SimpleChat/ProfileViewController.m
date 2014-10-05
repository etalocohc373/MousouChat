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
    
    about.font = [UIFont fontWithName:@"APJapanesefont" size:25];
    
    if([store boolForKey:@"editMain"]){
        imgView.image = [[UIImage alloc] initWithData:[store objectForKey:@"myimage"]];
        name.text = [store objectForKey:@"myname"];
        about.text = [store objectForKey:@"aboutme"];
    }else{
        int editNum = (int)[store integerForKey:@"editUserNum"];
        
        imgView.image = [[UIImage alloc] initWithData:[[store objectForKey:@"pimages"] objectAtIndex:editNum]];
        name.text = [[store objectForKey:@"users"] objectAtIndex:editNum];
        about.text = [[store objectForKey:@"intros"] objectAtIndex:editNum];
    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
    
    [self save];
}

-(void)save{
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    
    if([store boolForKey:@"editMain"]) [store setObject:[[NSData alloc] initWithData:UIImagePNGRepresentation(imgView.image)] forKey:@"myimage"];
    else{
        NSMutableArray *images = [NSMutableArray arrayWithArray:[store objectForKey:@"pimages"]];
        [images replaceObjectAtIndex:[store integerForKey:@"editUserNum"] withObject:[[NSData alloc] initWithData:UIImagePNGRepresentation(imgView.image)]];
        [store setObject:images forKey:@"pimages"];
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

@end
