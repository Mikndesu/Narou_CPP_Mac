//
//  Novel.hpp
//  Narou
//
//  Created by MitsukiGoto on 2020/03/12.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#ifndef NovelManage_hpp
#define NovelManage_hpp

#include <stdio.h>
#include <string>
#include <vector>
#include <map>
#include "picojson.h"

class NovelManage {
public:
    NovelManage(std::string);
    std::vector<std::map<std::string, std::string>> getAllNovelInfo();
    void addNovel();
private:
    std::string novelDataPath;
    picojson::value value;
};

#endif /* Novel_hpp */
