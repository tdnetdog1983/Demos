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

#import "CLPinView.h"

const int THE_THRESHOLD = 10000;

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
    NSMutableArray *_pinviews;
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
    
    _pinviews = [NSMutableArray arrayWithCapacity:10];
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

- (IBAction)btn3Action:(id)sender {
    for (UIView *pinView in _pinviews) {
        [pinView removeFromSuperview];
    }
    
    int width = (int)self.picImageView.image.size.width;
    int height = (int)self.picImageView.image.size.height;
    CColorARGB pSample[] = {
        CColorARGB(0xff, 184, 204, 228),
        CColorARGB(0xff, 230, 184, 183),
        CColorARGB(0xff, 255, 255, 153),
        CColorARGB(0xff, 204, 255, 153),
        CColorARGB(0xff, 51, 51, 204),
        
        CColorARGB(0xff, 102, 153, 0),
        CColorARGB(0xff, 204, 0, 0),
        CColorARGB(0xff, 255, 255, 0),
        CColorARGB(0xff, 204, 0, 102),
        CColorARGB(0xff, 226, 107, 10),
        
        CColorARGB(0xff, 153, 51, 255),
        CColorARGB(0xff, 102, 153, 255),
        CColorARGB(0xff, 238, 236, 225),
        CColorARGB(0xff, 255, 255, 255),
        CColorARGB(0xff, 207, 207, 207),
        
        CColorARGB(0xff, 89, 89, 89),
        CColorARGB(0xff, 0, 0, 0),
        CColorARGB(0xff, 122, 122, 122),
        CColorARGB(0xff, 0, 32, 96),
        CColorARGB(0xff, 0, 102, 0),
        
        CColorARGB(0xff, 204, 102, 0),
        CColorARGB(0xff, 204, 0, 255),
        CColorARGB(0xff, 153, 0, 0),
    };
    int sampleSize = sizeof(pSample)/sizeof(CColorARGB);
    
    NSMutableArray *sampleArray = [NSMutableArray arrayWithCapacity:sampleSize];
    for (int i = 0; i < sampleSize; i++) {
        CColorPoint *colorPoint = [[CColorPoint alloc] init];
        colorPoint->_cColor = pSample[i];
        
        NSMutableArray *singleArray = [NSMutableArray arrayWithObject:colorPoint];
        [sampleArray addObject:singleArray];
    }
    
    
    CColorARGB  *pHead = (CColorARGB *)[[self.picImageView.image rawImageData] bytes];
    for (int i = 0; i < width*height; i+=10) {
        CColorARGB currentColor = *(pHead + i);
        int row = i/width;
        int col = i%width;
        
        for (int j = 0; j < sampleSize; j++) {
            if (areTwoColorsSimilar(pSample[j], currentColor, THE_THRESHOLD)) {
                CColorPoint *colorPoint = [[CColorPoint alloc] init];
                colorPoint->_x = col;
                colorPoint->_y = row;
                colorPoint->_cColor = currentColor;
                NSMutableArray *arr = [sampleArray objectAtIndex:j];
                [arr addObject:colorPoint];
                break;
            }
        }
    }
    
    [sampleArray sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
        int c1 = [(NSArray *)obj1 count];
        int c2 = [(NSArray *)obj2 count];
        if (c1 < c2) return NSOrderedAscending;
        if (c1 > c2) return NSOrderedDescending;
        
        return NSOrderedSame;
    }];
    
    for (int i = 0; i < 10; i++) {
        NSArray *singleArray = [sampleArray lastObject];
        [sampleArray removeLastObject];
        
        if ([singleArray count] > 200) {
            CColorPoint *p = [singleArray objectAtIndex:[singleArray count]/2];
            NSLog(@"%d, %d", p->_x, p->_y);
            
            
            
            CGPoint point = [self changeFromX:p->_x andY:p->_y];
            CLPinView *pinview = [[[NSBundle mainBundle] loadNibNamed:@"CLPinView" owner:self options:nil] lastObject];
            NSLog(@"%@", NSStringFromCGRect(pinview.frame));
            [self.picImageView addSubview:pinview];
            pinview.selectedColorARGB = p->_cColor;
            [pinview changeHSB];
            
            [pinview performSelector:@selector(showForPositionWithNSValue:) withObject:[NSValue valueWithCGPoint:point] afterDelay:[self randomDoubleFrom:0 To:1]];
            //[pinview showForPosition:point];
            
//            UIView *pinview = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, 30, 30)];
//            
//            CColorARGB color = p->_cColor;
//            pinview.backgroundColor = [UIColor colorWithRed:color._r/255.f green:color._g/255.f blue:color._b/255.f alpha:color._a/255.f];
//            
//            [self.picImageView addSubview:pinview];
        }
    }
}

- (double)randomDoubleFrom:(double)aStart To:(double)aEnd {
    double random = (double)rand() / (double)RAND_MAX;
    double diff = aEnd - aStart;
    return aStart + random*diff;
}

- (IBAction)btn4Action:(id)sender {
    CLPinView *pinview = [[[NSBundle mainBundle] loadNibNamed:@"CLPinView" owner:self options:nil] lastObject];
    NSLog(@"%@", NSStringFromCGRect(pinview.frame));
    [self.picImageView addSubview:pinview];
    pinview.selectedColorARGB = CColorARGB(255, 255, 0, 0);
    [pinview changeHSB];
    pinview.contentImageView.image = pinview.myImage;
    pinview.contentImageView.hidden = NO;
    
    //[pinview showForPosition:CGPointMake(100, 50)];
}

- (CGPoint)changeFromX:(int)x andY:(int)y {
    CGFloat nx = self.picImageView.bounds.size.width * x / self.picImageView.image.size.width;
    CGFloat ny = self.picImageView.bounds.size.height * y / self.picImageView.image.size.height;
    return CGPointMake(nx, ny);
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