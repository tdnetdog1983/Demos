//
//  CL2ViewController.m
//  MyDemos
//
//  Created by Cai Lei on 4/25/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import "CL2ViewController.h"

@interface CL2ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation CL2ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)btn1Action:(id)sender {
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.delegate = self;
    imagePickerVC.sourceType = UIImagePickerControllerCameraCaptureModePhoto;
    [self presentModalViewController:imagePickerVC animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSLog(@"%f, %f", image.size.width, image.size.height);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
}

@end
