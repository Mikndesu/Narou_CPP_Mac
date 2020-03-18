//
//  Novel.hpp
//  Narou
//
//  Created by MitsukiGoto on 2020/03/12.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#ifndef NovelNcode_hpp
#define NovelNcode_hpp

#include <stdio.h>
#include <string>
#include <vector>
#include <map>
#include "picojson.h"

class NovelNcode {
public:
    NovelNcode(const std::string);
    std::vector<std::pair<std::string, std::string>> allNovelInfo() const;
    void addNovel(const std::string, const std::string);
private:
    void saveNovelData();
    void defaultNovel();
    std::string _novelDataPath;
    picojson::value _value;
};

#endif /* Novel_hpp */
