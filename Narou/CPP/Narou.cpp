//
//  Narou.cpp
//  Narou
//
//  Created by MitsukiGoto on 2020/03/13.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#include <iostream>
#include <memory>
#include "NovelNcode.hpp"
#include "NovelLength.hpp"
#include "Narou.hpp"

Narou::Narou(std::string novelName, std::string ncode) {
}

void Narou::checkAll() {
    std::unique_ptr<NovelNcode> novelCode(new NovelNcode(""));
    const auto novelInfo = novelCode->allNovelInfo();
    for(auto it = novelInfo.begin(); it != novelInfo.end(); it++) {
        std::pair<std::string, std::string> eachNovelInfo = *it;
        std::unique_ptr<NovelLength> novelLength(new NovelLength(eachNovelInfo.first, eachNovelInfo.second, ""));
        if(novelLength->isReNew()) {
            std::cout << "New" << std::endl;
        }
    }
}
