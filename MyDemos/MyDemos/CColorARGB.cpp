//
//  CColorARGB.cpp
//  MyDemos
//
//  Created by Cai Lei on 4/23/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#include "CColorARGB.h"
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

bool areTwoColorsSimilar(const CColorARGB& lhs, const CColorARGB& rhs, uint threshold) {
    int delta =
        abs(lhs._r - rhs._r) * 299 +
        abs(lhs._g - rhs._g) * 587 +
        abs(lhs._b - rhs._b) * 114;
    
    int newThreshold = threshold;
    return (delta < newThreshold);
}