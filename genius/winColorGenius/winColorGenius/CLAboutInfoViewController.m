//
//  CLAboutInfoViewController.m
//  winColorGenius
//
//  Created by Cai Lei on 5/7/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import "CLAboutInfoViewController.h"

@interface CLAboutInfoViewController ()

@end

@implementation CLAboutInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIImage *srcImage = [UIImage imageNamed:@"loreal_large"];
//    UIImage *desImage = [UIImage adjustImage:srcImage changeFromColor:CColorARGB(0xff, 0, 0, 0) ToColor:CColorARGB(0xff, 0xff, 0, 0) withThreshold:100];
//    
//    [self.view addSubview:[[UIImageView alloc] initWithImage:desImage]];
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
