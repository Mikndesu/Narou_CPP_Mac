//
//  NovelLength.hpp
//  Narou
//
//  Created by MitsukiGoto on 2020/03/13.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#ifndef NovelLength_hpp
#define NovelLength_hpp

#include <stdio.h>
#include <string>
#include "picojson.h"

class NovelLength {
public:
    NovelLength(const std::string, const std::string, const std::string);
    ~NovelLength();
    bool isReNew();
private:
    int _previousLength;
    int _presentLength;
    std::string _ncode;
    std::string _novelName;
    std::string _apiUrl;
    std::string _lengthPath;
    std::string requestNarouAPI() const;
    void getPreviousLength();
    bool isNovelExists(const picojson::value&);
    bool isFileExists();
};

#endif /* NovelLength_hpp */
