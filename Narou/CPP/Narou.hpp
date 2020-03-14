//
//  Narou.hpp
//  Narou
//
//  Created by MitsukiGoto on 2020/03/13.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#ifndef Narou_hpp
#define Narou_hpp

#include <iostream>
#include <stdio.h>
#include <string>
#include <array>
#include <curl/curl.h>

class Narou {
public:
    Narou(std::string, std::string);
    void checkAll();
};

#endif /* Narou_hpp */
