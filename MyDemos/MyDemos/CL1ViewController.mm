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

/**
 *	@brief	CColorPoint
 */
@interface CColorPoint : NSObject {
    @public
    int         _x;
    int         _y;
    CColorARGB  _cColor;
}
@end
@implementation CColorPoint
@end

@interface CColorRegion : NSObject
@property (nonatomic, strong) NSMutableArray *pointsArray;

- (CColorARGB)averageColor;
- (CColorPoint *)averageColorPoint;
@end

@implementation CColorRegion
- (id)init
{
    self = [super init];

    if (self) {
        _pointsArray = [NSMutableArray array];
    }

    return self;
}

- (CColorARGB)averageColor
{
    CColorARGB color = CColorARGB();

    if (![self.pointsArray count]) {
        return color;
    }

    long long   r = 0;
    long long   g = 0;
    long long   b = 0;
    long long   a = 0;
    long long   count = [self.pointsArray count];

    for (CColorPoint *colorPoint in self.pointsArray) {
        r += colorPoint->_cColor._r;
        g += colorPoint->_cColor._g;
        b += colorPoint->_cColor._b;
        a += colorPoint->_cColor._a;
    }

    color._r = r / count;
    color._g = g / count;
    color._b = b / count;
    color._a = a / count;
    return color;
}

- (CColorPoint *)averageColorPoint
{
    if (![self.pointsArray count]) {
        return nil;
    }

    CColorARGB  aColor = [self averageColor];
    CColorPoint *colorPoint = [self.pointsArray lastObject];

    uint delta = compareTwoColors(aColor, colorPoint->_cColor);

    for (CColorPoint *nextColorPoint in self.pointsArray) {
        uint newDelta = compareTwoColors(aColor, nextColorPoint->_cColor);

        if (delta > newDelta) {
            delta = newDelta;
            colorPoint = nextColorPoint;
        }
    }

    return colorPoint;
}

@end

@interface CL1ViewController () {
    NSMutableArray *_regions;
}

@end

@implementation CL1ViewController {
    UIImageView *_testImageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tap.numberOfTapsRequired = 1;
    self.picImageView.userInteractionEnabled = YES;
    [self.picImageView addGestureRecognizer:tap];
}

- (IBAction)btnAction:(id)sender
{
    [_testImageView removeFromSuperview];

    int         width = 100;
    int         height = 100;
    CColorARGB  *c = new CColorARGB[width * height];

    for (int row = 0; row < height; row++) {
        for (int col = 0; col < width; col++) {
            *(c + row * width + col) = CColorARGB(0xff, 0xff, 0, 0);
        }
    }

    UIImage *image = [UIImage imageWithRawImageData:[NSData dataWithBytes:(const void *)c length:sizeof(CColorARGB) * width * height] width:width height:height];
    _testImageView = [[UIImageView alloc] initWithImage:image];
    // _testImageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    _testImageView.frame = CGRectMake(123, 20, image.size.width, image.size.height);
    [self.view addSubview:_testImageView];

    delete[] c;
}

- (IBAction)btn1Action:(id)sender
{
    int         x = 0;
    int         y = 0;
    CColorARGB  *pHead = (CColorARGB *)[[self.picImageView.image rawImageData] bytes];
    uint8_t     *pFlagHead = new uint8_t[(int)(self.picImageView.image.size.width * self.picImageView.image.size.height)];
    NSMutableArray *regionArray = [NSMutableArray array];
    
    BOOL bFind = YES;
    
    while (bFind) {
        for (int row = 0; row < self.picImageView.image.size.height; row+=10) {
            bFind = NO;
            for (int col = 0; col < self.picImageView.image.size.width; col+=10) {
                uint8_t flag = *(pFlagHead + row * (int)self.picImageView.image.size.width + col);
                
                if (!flag) {
                    x = col;
                    y = row;
                    bFind = YES;
                    break;
                }
            }
            if (bFind) {
                break;
            }
        }
        
        if (bFind) {
            CColorARGB  colorAtPoint = *(pHead + (int)self.picImageView.image.size.width * y + x);
            CColorPoint     *colorPoint = [[CColorPoint alloc] init];
            colorPoint->_x = x;
            colorPoint->_y = y;
            colorPoint->_cColor = colorAtPoint;
            CColorRegion *region = [self regionForColor:colorPoint withPHead:pHead PFlagHead:pFlagHead];
            if ([region.pointsArray count] > 2000) {
                NSLog(@"%d", [region.pointsArray count]);
                [regionArray addObject:region];
            }
        }
    }
    
    NSLog(@"%@", regionArray);
    _regions = regionArray;
    
    [self markRegion];
}

- (IBAction)btn2Action:(id)sender {
    int x = 899;
    int y = 0;
    
    CColorARGB  *pHead = (CColorARGB *)[[self.picImageView.image rawImageData] bytes];
    uint8_t     *pFlagHead = new uint8_t[(int)(self.picImageView.image.size.width * self.picImageView.image.size.height)];
    CColorARGB  colorAtPoint = *(pHead + (int)self.picImageView.image.size.width * y + x);
    CColorPoint     *colorPoint = [[CColorPoint alloc] init];
    colorPoint->_x = x;
    colorPoint->_y = y;
    colorPoint->_cColor = colorAtPoint;
    CColorRegion *region = [self regionForColor:colorPoint withPHead:pHead PFlagHead:pFlagHead];
    NSLog(@"%d", [region.pointsArray count]);
}

- (void)markRegion {
    CColorARGB *pHead = new CColorARGB[(int)(self.picImageView.image.size.width * self.picImageView.image.size.height)];
    
    for (CColorRegion *r in _regions) {
        CColorARGB aColor = [r averageColor];
        for (CColorPoint *p in r.pointsArray) {
            *(pHead + p->_y * (int)self.picImageView.image.size.width + p->_x) = aColor;
        }
    }
    
    self.outputImageView.image = [UIImage   imageWithRawImageData   :[NSData dataWithBytes:(const void *)pHead length:4 * self.picImageView.image.size.width * self.picImageView.image.size.height]
                                            width                   :self.picImageView.image.size.width height:self.picImageView.image.size.height];
}

- (void)tapHandler:(UITapGestureRecognizer *)sender
{
    CGPoint p = [sender locationInView:sender.view];
    int     x = p.x * self.picImageView.image.size.width / self.picImageView.bounds.size.width;
    int     y = p.y * self.picImageView.image.size.height / self.picImageView.bounds.size.height;
    
    NSLog(@"%d, %d", x, y);
    x = MAX(0, MIN(x, self.picImageView.image.size.width - 1));
    y = MAX(0, MIN(y, self.picImageView.image.size.height - 1));

    CColorARGB  *pHead = (CColorARGB *)[[self.picImageView.image rawImageData] bytes];
    CColorARGB  colorAtPoint = *(pHead + (int)self.picImageView.image.size.width * y + x);

    UIColor *color = [UIColor   colorWithRed:colorAtPoint._r / 255.0f
                                green       :colorAtPoint._g / 255.0f
                                blue        :colorAtPoint._b / 255.0f
                                alpha       :colorAtPoint._a / 255.0f];

    self.outputView.backgroundColor = color;

    uint8_t         *pFlagHead = new uint8_t[(int)(self.picImageView.image.size.width * self.picImageView.image.size.height)];
    NSMutableArray  *queue = [NSMutableArray array];
    CColorPoint     *colorPoint = [[CColorPoint alloc] init];
    colorPoint->_x = x;
    colorPoint->_y = y;
    colorPoint->_cColor = colorAtPoint;

    [queue addObject:colorPoint];
    *(pFlagHead + y * (int)self.picImageView.image.size.width + x) = 1;
    
    int avA = 0;
    int avR = 0;
    int avG = 0;
    int avB = 0;
    
    while ([queue count]) {
        // NSLog(@"%d", [queue count]);

        CColorPoint *curColorPoint = [queue lastObject];
//        for (CColorPoint *c in queue) {
//            avA += c->_cColor._a;
//            avR += c->_cColor._r;
//            avG += c->_cColor._g;
//            avB += c->_cColor._b;
//        }
//        avA = avA / [queue count];
//        avR = avR / [queue count];
//        avG = avG / [queue count];
//        avB = avB / [queue count];
//        
//        curColorPoint->_cColor._a = avA;
//        curColorPoint->_cColor._r = avR;
//        curColorPoint->_cColor._g = avG;
//        curColorPoint->_cColor._b = avB;
        
        [queue removeLastObject];
        int xx = curColorPoint->_x;
        int yy = curColorPoint->_y;
        
        
        
        // Up
        if (yy > 0) {
            [self checkCColorPoint:curColorPoint withPHead:pHead PFlagHead:pFlagHead forX:xx Y:yy - 1 toAddToQueue:queue];
        }

        // Left
        if (xx > 0) {
            [self checkCColorPoint:curColorPoint withPHead:pHead PFlagHead:pFlagHead forX:xx - 1 Y:yy toAddToQueue:queue];
        }

        // Down
        if (yy < self.picImageView.image.size.height - 1) {
            [self checkCColorPoint:curColorPoint withPHead:pHead PFlagHead:pFlagHead forX:xx Y:yy + 1 toAddToQueue:queue];
        }

        // Right
        if (xx < self.picImageView.image.size.width - 1) {
            [self checkCColorPoint:curColorPoint withPHead:pHead PFlagHead:pFlagHead forX:xx + 1 Y:yy toAddToQueue:queue];
        }
    }

    // * to change the color style/
    long long count = 0;
    for (int row = 0; row < self.picImageView.image.size.height; row++) {
        for (int col = 0; col < self.picImageView.image.size.width; col++) {
            uint8_t flag = *(pFlagHead + row * (int)self.picImageView.image.size.width + col);

            if (flag) {
                count ++;
                *(pHead + row * (int)self.picImageView.image.size.width + col) = CColorARGB(255, 0, 0, 255);
            }
        }
    }
    NSLog(@"%lld", count);
    // */

    self.outputImageView.image = [UIImage   imageWithRawImageData   :[NSData dataWithBytes:(const void *)pHead length:4 * self.picImageView.image.size.width * self.picImageView.image.size.height]
                                            width                   :self.picImageView.image.size.width height:self.picImageView.image.size.height];
}

- (void)viewDidUnload
{
    [self setPicImageView:nil];
    [self setOutputView:nil];
    [self setOutputImageView:nil];
    [super viewDidUnload];
}

- (CColorRegion *)  regionForColor  :(CColorPoint *)colorPoint
                    withPHead       :(CColorARGB *)pHead
                    PFlagHead       :(uint8_t *)pFlagHead
{
    NSMutableArray  *retArray = [NSMutableArray array];
    NSMutableArray  *queue = [NSMutableArray array];

    [queue addObject:colorPoint];

    *(pFlagHead + colorPoint->_y * (int)self.picImageView.image.size.width + colorPoint->_x) = 1;

    while ([queue count]) {
        // NSLog(@"%d", [queue count]);

        CColorPoint *curColorPoint = [queue lastObject];
        [queue removeLastObject];
        [retArray addObject:curColorPoint];
        int xx = curColorPoint->_x;
        int yy = curColorPoint->_y;

        // Up
        if (yy > 0) {
            [self checkCColorPoint:curColorPoint withPHead:pHead PFlagHead:pFlagHead forX:xx Y:yy - 1 toAddToQueue:queue];
        }

        // Left
        if (xx > 0) {
            [self checkCColorPoint:curColorPoint withPHead:pHead PFlagHead:pFlagHead forX:xx - 1 Y:yy toAddToQueue:queue];
        }

        // Down
        if (yy < self.picImageView.image.size.height - 1) {
            [self checkCColorPoint:curColorPoint withPHead:pHead PFlagHead:pFlagHead forX:xx Y:yy + 1 toAddToQueue:queue];
        }

        // Right
        if (xx < self.picImageView.image.size.width - 1) {
            [self checkCColorPoint:curColorPoint withPHead:pHead PFlagHead:pFlagHead forX:xx + 1 Y:yy toAddToQueue:queue];
        }
    }

    CColorRegion *colorRegion = [[CColorRegion alloc] init];
    colorRegion.pointsArray = retArray;

    return colorRegion;
}

- (void)checkCColorPoint:(CColorPoint *)curColorPoint
        withPHead       :(CColorARGB *)pHead
        PFlagHead       :(uint8_t *)pFlagHead
        forX            :(int)x
        Y               :(int)y
        toAddToQueue    :(NSMutableArray *)queue
{
    uint8_t *flag;

    flag = pFlagHead + y * (int)self.picImageView.image.size.width + x;

    if (!*flag) {
        CColorARGB nextColor = *(pHead + y * (int)self.picImageView.image.size.width + x);

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