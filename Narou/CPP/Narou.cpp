//
//  Narou.cpp
//  Narou
//
//  Created by MitsukiGoto on 2020/03/13.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#include <memory>
#include "NovelNcode.hpp"
#include "NovelLength.hpp"
#include "Narou.hpp"

Narou::Narou(const std::string ncodePath, const std::string lengthPath) : _ncodePath(ncodePath), _lengthPath(lengthPath) {
}

std::vector<std::string> Narou::checkAll() {
    std::unique_ptr<NovelNcode> novelCode(new NovelNcode(_ncodePath));
    std::vector<std::string> renewedNovels;
    const auto novelInfo = novelCode->allNovelInfo();
    for(auto it = novelInfo.begin(); it != novelInfo.end(); it++) {
        std::pair<std::string, std::string> eachNovelInfo = *it;
        std::unique_ptr<NovelLength> novelLength(new NovelLength(eachNovelInfo.first, eachNovelInfo.second, _lengthPath));
        if(novelLength->isReNew()) {
            std::cout << "New" << eachNovelInfo.first << std::endl;
            renewedNovels.push_back(eachNovelInfo.first);
        }
    }
    for(const auto&e:renewedNovels) {
        std::cout << e << std::endl;
    }
    return renewedNovels;
}

void Narou::addNovel(const std::string novelName, const std::string ncode) {
    std::unique_ptr<NovelNcode> novelCode(new NovelNcode(_ncodePath));
    novelCode->addNovel(novelName, ncode);
}
