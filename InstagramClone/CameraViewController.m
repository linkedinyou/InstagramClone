//
//  CameraViewController.m
//  InstagramClone
//
//  Created by Stephen Compton on 2/3/14.
//  Copyright (c) 2014 Stephen Compton. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "Parse/Parse.h"

@interface CameraViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
        NSString *imageName;
    __weak IBOutlet UIImageView *cameraImageView;
    
    __weak IBOutlet UIButton *selectPhoto;
    UIImagePickerController *imagePicker;
    UIImage *image;
}
@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (IBAction)onTakePhotoButtonPressed:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}



- (IBAction)selectPhoto:(id)sender {
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else  {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
    [self presentViewController :imagePicker animated:NO completion:nil];

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [ info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //A photo was taken/ selected
        image = info[UIImagePickerControllerOriginalImage];
        cameraImageView.image = image;
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
  //      [self uploadImage:imageData];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}




//ADD EFFECTS BUTTON?
//
//-(void)effects {
//    //apply sepia filter - taken from the Beginning Core Image from iOS5 by Tutorials
//    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(photo.image)];
//    CIContext *context = [CIContext contextWithOptions:nil];
//    
//    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
//                                  keysAndValues: kCIInputImageKey, beginImage,
//                        @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
//    CIImage *outputImage = [filter outputImage];
//    
//    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
//    photo.image = [UIImage imageWithCGImage:cgimg];
//    
//    CGImageRelease(cgimg);
//}




- (IBAction)onSharePhotoButonPressed:(id)sender {
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hide old HUD, show completed HUD (see example for code)
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"Photo"];
            [userPhoto setObject:imageFile forKey:@"image"];
          
            
            PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [ACL setPublicReadAccess:YES];
            [ACL setWriteAccess:YES forUser:[PFUser currentUser]];

            
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    // [self refresh:nil];
                    
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }];

    
}


-(void)uploadImage:(NSData *)data
{
    }

    




@end
