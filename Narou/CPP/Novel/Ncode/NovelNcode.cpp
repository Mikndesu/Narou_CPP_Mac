//
//  Novel.cpp
//  Narou
//
//  Created by MitsukiGoto on 2020/03/12.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#include "NovelNcode.hpp"
#include <iostream>
#include <fstream>
#include "picojson.h"

NovelNcode::NovelNcode(const std::string path) : _novelDataPath(path) {
    std::ifstream ifs(path, std::ios::in);
    if(!ifs.is_open()) {
        defaultNovel();
    }
    std::string data, err;
    std::getline(ifs, data);
    if(data.empty()) {
        defaultNovel();
    } else {
        picojson::parse(_value, data.c_str(), data.c_str()+strlen(data.c_str()), &err);
    }
    std::cout << err << std::endl;
    std::cout << __LINE__ << std::endl;
}

void NovelNcode::saveNovelData() {
    std::ofstream ofs(_novelDataPath, std::ios::out);
    ofs << _value << std::endl;
}

void NovelNcode::defaultNovel() {
    std::ofstream ofs(_novelDataPath, std::ios::out);
    std::cout << _novelDataPath << std::endl;
    picojson::array array;
    picojson::object object;
    object.emplace(std::make_pair("ReZero", picojson::value("N2267BE")));
    array.push_back(picojson::value(object));
    ofs << picojson::value(array) << std::endl;
}

void NovelNcode::addNovel(const std::string novelName, const std::string ncode) {
    auto& array = _value.get<picojson::array>();
    for(auto it = array.begin(); it != array.end(); it++) {
        const auto& object = it->get<picojson::object>();
        if(object.count(novelName) == 1) {
            return;
        } else if(object.count(novelName) == 0 && it == array.end()--) {
            picojson::object obj;
            obj.emplace(std::make_pair(novelName, picojson::value(_value)));
            array.push_back(picojson::value(obj));
            break;
        }
    }
    _value = picojson::value(array);
    saveNovelData();
}

std::vector<std::pair<std::string, std::string>> NovelNcode::allNovelInfo() const {
    std::vector<std::pair<std::string, std::string>> allInfo;
    const auto& array = _value.get<picojson::array>();
    for(auto it = array.begin(); it != array.end(); it++) {
        const auto& object = it->get<picojson::object>();
        for(auto iterator = object.begin(); iterator != object.end(); iterator++) {
            std::pair<std::string, std::string> pair = std::make_pair(iterator->first, iterator->second.to_str());
            allInfo.push_back(pair);
        }
    }
    return allInfo;
}
