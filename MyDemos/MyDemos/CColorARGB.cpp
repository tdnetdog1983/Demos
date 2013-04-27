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
    //abs(lhs._r - rhs._r) * 299 +
    //abs(lhs._g - rhs._g) * 587 +
    //abs(lhs._b - rhs._b) * 114;
    deltaR[abs(lhs._r - rhs._r)] + deltaG[abs(lhs._g - rhs._g)] + deltaB[abs(lhs._b - rhs._b)];
    
    return delta;
}

bool areTwoColorsSimilar(const CColorARGB& lhs, const CColorARGB& rhs, uint threshold) {
    uint delta = compareTwoColors(lhs, rhs);
    return (delta < threshold);
}