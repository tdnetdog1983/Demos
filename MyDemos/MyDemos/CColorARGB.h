//
//  CColorARGB.h
//  MyDemos
//
//  Created by Cai Lei on 4/23/13.
//  Copyright (c) 2013 com.winchannel. All rights reserved.
//

#ifndef __MyDemos__CColorARGB__
#define __MyDemos__CColorARGB__

#include <iostream>
class CColorARGB {
public:
    uint8_t _a;
    uint8_t _r;
    uint8_t _g;
    uint8_t _b;
    
    CColorARGB();
    CColorARGB(uint8_t a, uint8_t r, uint8_t g, uint8_t b);
    ~CColorARGB();
    CColorARGB(const CColorARGB& rhs);
    CColorARGB& operator=(const CColorARGB& rhs);
};

/**
 *	@brief threshold 	0 - 255000
 */
extern uint compareTwoColors(const CColorARGB& lhs, const CColorARGB& rhs);
extern bool areTwoColorsSimilar(const CColorARGB& lhs, const CColorARGB& rhs, uint threshold);


#endif /* defined(__MyDemos__CColorARGB__) */
