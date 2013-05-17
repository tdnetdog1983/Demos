//
//  CColorARGB.cpp
//  MyDemos
//
//  Created by Cai Lei on 4/23/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#include "CColorARGB.h"
static uint deltaR[256];
static uint deltaG[256];
static uint deltaB[256];

CColorARGB pSample[23] = {
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

void initDeltaArray() {
    for (int i = 0; i < 256; i++) {
        deltaR[i] = i*299;
        deltaG[i] = i*587;
        deltaB[i] = i*114;
    }
}

CColorARGB::CColorARGB() {
    _a = _r = _g = _b = 0;
}

CColorARGB::CColorARGB(uint8_t a, uint8_t r, uint8_t g, uint8_t b) {
    _a = a;
    _r = r;
    _g = g;
    _b = b;
}

CColorARGB::~CColorARGB() {
    
}

CColorARGB::CColorARGB(const CColorARGB& rhs) {
    _a = rhs._a;
    _r = rhs._r;
    _g = rhs._g;
    _b = rhs._b;
}

CColorARGB& CColorARGB::operator=(const CColorARGB& rhs) {
    if (this == &rhs) {
        return *this;
    }
    
    _a = rhs._a;
    _r = rhs._r;
    _g = rhs._g;
    _b = rhs._b;
    return *this;
}

uint compareTwoColors(const CColorARGB& lhs, const CColorARGB& rhs) {
    uint delta =
    abs(lhs._r - rhs._r) * 299 +
    abs(lhs._g - rhs._g) * 587 +
    abs(lhs._b - rhs._b) * 114;
    //deltaR[abs(lhs._r - rhs._r)] + deltaG[abs(lhs._g - rhs._g)] + deltaB[abs(lhs._b - rhs._b)];
    
    return delta;
}

bool areTwoColorsSimilar(const CColorARGB& lhs, const CColorARGB& rhs, uint threshold) {
    uint delta = compareTwoColors(lhs, rhs);
    return (delta < threshold);
}

#pragma mark - CColorPoint
@implementation CColorPoint
@end

#pragma mark - CColorRegion
@implementation CColorRegion
- (id)init
{
    self = [super init];
    
    if (self) {
        _colorPointArray = [NSMutableArray array];
    }
    
    return self;
}

- (CColorARGB)averageColor
{
    CColorARGB color = CColorARGB();
    
    if (![self.colorPointArray count]) {
        return color;
    }
    
    long long   r = 0;
    long long   g = 0;
    long long   b = 0;
    long long   a = 0;
    long long   count = [self.colorPointArray count];
    
    for (CColorPoint *colorPoint in self.colorPointArray) {
        r += colorPoint.colorARGB._r;
        g += colorPoint.colorARGB._g;
        b += colorPoint.colorARGB._b;
        a += colorPoint.colorARGB._a;
    }
    
    color._r = r / count;
    color._g = g / count;
    color._b = b / count;
    color._a = a / count;
    return color;
}

- (CColorPoint *)averageColorPoint
{
    if (![self.colorPointArray count]) {
        return nil;
    }
    
    CColorARGB  aColor = [self averageColor];
    CColorPoint *colorPoint = [self.colorPointArray lastObject];
    
    uint delta = compareTwoColors(aColor, colorPoint.colorARGB);
    
    for (CColorPoint *nextColorPoint in self.colorPointArray) {
        uint newDelta = compareTwoColors(aColor, nextColorPoint.colorARGB);
        
        if (delta > newDelta) {
            delta = newDelta;
            colorPoint = nextColorPoint;
        }
    }
    
    return colorPoint;
}

@end
