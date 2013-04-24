//
//  CL1ViewController.m
//  MyDemos
//
//  Created by Cai Lei on 4/23/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#import "CL1ViewController.h"
#include "CColorARGB.h"
#import "UIImage+RawData.h"

const int THE_THRESHOLD = 2500;
@interface CColorPoint : NSObject {
 @public
    int _x;
    int _y;
    CColorARGB _cColor;
}
@end

@implementation CColorPoint
@end




@interface CL1ViewController ()

@end

@implementation CL1ViewController {
    UIImageView *_testImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tap.numberOfTapsRequired = 1;
    self.picImageView.userInteractionEnabled = YES;
    [self.picImageView addGestureRecognizer:tap];
}

- (IBAction)btnAction:(id)sender {
    [_testImageView removeFromSuperview];
    
    int width = 100;
    int height = 100;
    CColorARGB *c = new CColorARGB[width * height];
    for (int row = 0; row < height; row++) {
        for (int col = 0; col < width; col++) {
            *(c+row*width+col) = CColorARGB(0xff, 0xff, 0, 0);
        }
    }
    
    UIImage *image = [UIImage imageWithRawImageData:[NSData dataWithBytes:(const void *)c length:sizeof(CColorARGB)*width*height] width:width height:height];
    _testImageView = [[UIImageView alloc] initWithImage:image];
    //_testImageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    _testImageView.frame = CGRectMake(123, 20, image.size.width, image.size.height);
    [self.view addSubview:_testImageView];
    
    delete[] c;
}

- (IBAction)btn1Action:(id)sender {
    
}

- (void)tapHandler:(UITapGestureRecognizer *)sender {
    CGPoint p = [sender locationInView:sender.view];
    int x = p.x * self.picImageView.image.size.width / self.picImageView.bounds.size.width;
    int y = p.y * self.picImageView.image.size.height / self.picImageView.bounds.size.height;
    x = MAX(0, MIN(x, self.picImageView.image.size.width - 1));
    y = MAX(0, MIN(y, self.picImageView.image.size.height - 1));
    
    CColorARGB *pHead = (CColorARGB *)[[self.picImageView.image rawImageData] bytes];
    CColorARGB colorAtPoint = *(pHead + (int)self.picImageView.image.size.width*y + x);
    
    UIColor *color = [UIColor colorWithRed:colorAtPoint._r/255.0f
                                     green:colorAtPoint._g/255.0f
                                      blue:colorAtPoint._b/255.0f
                                     alpha:colorAtPoint._a/255.0f];
    
    self.outputView.backgroundColor = color;
    
    uint8_t *pFlagHead = new uint8_t[(int)(self.picImageView.image.size.width*self.picImageView.image.size.height)];
    NSMutableArray *queue = [NSMutableArray array];
    CColorPoint *colorPoint = [[CColorPoint alloc] init];
    colorPoint->_x = x;
    colorPoint->_y = y;
    colorPoint->_cColor = colorAtPoint;
    [queue addObject:colorPoint];
    
    *(pFlagHead + y*(int)self.picImageView.image.size.width +x) = 1;
    
    while ([queue count]) {
        //NSLog(@"%d", [queue count]);
        
        CColorPoint *curColorPoint = [queue lastObject];
        [queue removeLastObject];
        int xx = curColorPoint->_x;
        int yy = curColorPoint->_y;
        
        // Up
        if (yy > 0) {
            [self checkCColorPoint:curColorPoint withPHead:pHead PFlagHead:pFlagHead forX:xx Y:yy-1 toAddToQueue:queue];
        }
        
        // Left
        if (xx > 0) {
            [self checkCColorPoint:curColorPoint withPHead:pHead PFlagHead:pFlagHead forX:xx-1 Y:yy toAddToQueue:queue];
        }
        
        // Down
        if (yy < self.picImageView.image.size.height - 1) {
            [self checkCColorPoint:curColorPoint withPHead:pHead PFlagHead:pFlagHead forX:xx Y:yy+1 toAddToQueue:queue];
        }
        
        // Right
        if (xx < self.picImageView.image.size.width - 1) {
            [self checkCColorPoint:curColorPoint withPHead:pHead PFlagHead:pFlagHead forX:xx+1 Y:yy toAddToQueue:queue];
        }
    }
    
    
    //*/
    for (int row = 0; row < self.picImageView.image.size.height; row++) {
        for (int col = 0; col < self.picImageView.image.size.width; col++) {
            uint8_t flag = *(pFlagHead + row*(int)self.picImageView.image.size.width + col);
            if (flag) {
                *(pHead + row*(int)self.picImageView.image.size.width + col) = CColorARGB(255, 0, 0, 255);
            }
        }
    }
    //*/
    
    self.outputImageView.image = [UIImage imageWithRawImageData:[NSData dataWithBytes:(const void *)pHead length:4*self.picImageView.image.size.width*self.picImageView.image.size.height]
                                                       width:self.picImageView.image.size.width height:self.picImageView.image.size.height];
}

- (void)viewDidUnload {
    [self setPicImageView:nil];
    [self setOutputView:nil];
    [self setOutputImageView:nil];
    [super viewDidUnload];
}

- (void)checkCColorPoint:(CColorPoint *)curColorPoint
               withPHead:(CColorARGB *)pHead
               PFlagHead:(uint8_t *)pFlagHead
                    forX:(int)x
                       Y:(int)y
            toAddToQueue:(NSMutableArray *)queue
{
    uint8_t *flag;
    flag = pFlagHead + y*(int)self.picImageView.image.size.width +x;
        if (!*flag) {
            CColorARGB nextColor = *(pHead + y*(int)self.picImageView.image.size.width +x);
            if (areTwoColorsSimilar(nextColor, curColorPoint->_cColor, THE_THRESHOLD)) {
                *flag = 1;
                CColorPoint *upColorPoint = [[CColorPoint alloc] init];
                upColorPoint->_x = x;
                upColorPoint->_y = y;
                upColorPoint->_cColor = nextColor;
                
                [queue addObject:upColorPoint];
            }
        }
}

@end
