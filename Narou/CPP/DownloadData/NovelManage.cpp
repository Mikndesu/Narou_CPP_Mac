//
//  Novel.cpp
//  Narou
//
//  Created by MitsukiGoto on 2020/03/12.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#include "NovelManage.hpp"
#include <iostream>
#include <fstream>
#include "picojson.h"

NovelManage::NovelManage(std::string path) {
    NovelManage::novelDataPath = path;
    std::ifstream ifs(path, std::ios::in);
    std::string data, err;
    std::getline(ifs, data);
    picojson::parse(NovelManage::value, data.c_str(), data.c_str()+strlen(data.c_str()), &err);
}

std::vector<std::map<std::string, std::string>> NovelManage::getAllNovelInfo() {
    std::vector<std::map<std::string, std::string>> allInfo;
    auto array = NovelManage::value.get<picojson::array>();
    for(auto it = array.begin(); it != array.end(); it++) {
        auto object = it->get<picojson::object>();
        for(auto iterator = object.begin(); iterator != object.end(); iterator++) {
            std::map<std::string, std::string> map {{iterator->first, iterator->second.to_str()}};
            allInfo.push_back(map);
        }
    }
    return allInfo;
}
