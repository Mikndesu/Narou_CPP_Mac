//
//  DealJson.cpp
//  Narou
//
//  Created by MitsukiGoto on 2019/12/05.
//  Copyright © 2019 五島充輝. All rights reserved.
//

#include "DealJson.hpp"
#include <string>
#include <array>
#include <fstream>
#include <iostream>
#include "picojson.h"

#define CONTENTS_FROMPATH(filepath, contents, v, err) do {std::ifstream ifs; ifs.open(filepath, std::ios::in); std::getline(ifs, contents); ifs.close(); picojson::parse(v, contents.c_str(), contents.c_str() + strlen(contents.c_str()), &err);} while(0)
//Caution Deprecated please use readWords instead of this
std::string DealJson::readJsonFilefromInternet(const char* contents) {
    picojson::value v;
    std::string err;
    picojson::parse(v, contents, contents + strlen(contents), &err);
    if (err.empty())
    {
        picojson::object& o = v.get<picojson::object>();
        return o["length"].get<std::string>();
    }
    return "";
}

//A General Method instead of readJsonFilefromInternet
std::string DealJson::readWords(std::string jsonobj) {
    picojson::value v;
    std::string err, words;
    picojson::parse(v, jsonobj.c_str(), jsonobj.c_str() + strlen(jsonobj.c_str()), &err);
    if(err.empty()) {
        picojson::array& array = v.get<picojson::array>();
        for(auto it = array.begin(); it != array.end(); it++) {
            picojson::object& o = it->get<picojson::object>();
            for(auto ite = o.begin(); ite != o.end(); ite++) {
                if(ite->first == "length") {
                    words = ite->second.to_str();
                }
            }
        }
        std::cout << words << std::endl;
    }
    return words;
}

//in Progress
std::array<std::string, 3> DealJson::readSettingsJsonFilefromLocal(std::string filepath) {
    picojson::value v;
    std::string err, jsonobj;
    CONTENTS_FROMPATH(filepath, jsonobj, v, err);
    std::array<std::string, 3> result;
    if(err.empty()) {
        picojson::object& o = v.get<picojson::object>();
        picojson::object& e = o["CurlSettings"].get<picojson::object>();
        result[0] = e["ncode"].get<std::string>();
        result[1] = e["out"].get<std::string>();
        result[2] = e["request_url"].get<std::string>();
    }
    return result;
}

void DealJson::makeSettingsJsonFile(std::string filepath, std::string ncode) {

    std::ofstream ofs;
    ofs.open(filepath, std::ios::out);
    
    picojson::object obj;
    picojson::object data;
    {
        data.emplace(std::make_pair("request_url", picojson::value("http://api.syosetu.com/novelapi/api/")));
        data.emplace(std::make_pair("out", picojson::value("json")));
        if(ncode.empty()) {
            data.emplace(std::make_pair("ncode", picojson::value("N2267BE")));
        } else {
            data.emplace(std::make_pair("ncode", picojson::value(ncode)));
        }
        obj.emplace(std::make_pair("CurlSettings", picojson::value(data)));
    }
    
    ofs << picojson::value(obj) << std::endl;
    ofs.close();
}

void DealJson::saveWords(std::string filepath, std::string novelName, std::string words) {
    std::string err, jsonobj;
    picojson::value v;
    CONTENTS_FROMPATH(filepath, jsonobj, v, err);
    if(err.empty()) {
        std::map<std::string, std::string> jsonmap;
        picojson::array& array = v.get<picojson::array>();
        for(auto it = array.begin(); it != array.end(); it++) {
            picojson::object& o = it->get<picojson::object>();
            for(auto ite = o.begin(); ite != o.end(); ite++) {
                if(ite->first==novelName) {
                    o.erase(ite);
                    o.emplace(std::make_pair(novelName, picojson::value(words)));
                    goto FOR_END;
                }
            }
        }
        FOR_END:
        std::cout << v << std::endl;
    }
}

void DealJson::addNovels(std::string filepath, std::string valueName, std::string value) {
    std::string err, jsonobj;
    picojson::value v;
    CONTENTS_FROMPATH(filepath, jsonobj, v, err);
    if(err.empty()) {
        std::map<std::string, std::string> jsonmap;
        picojson::array& array = v.get<picojson::array>();
        for(auto it = array.begin(); it != array.end(); it++) {
            picojson::object& o = it->get<picojson::object>();
            for(auto ite = o.begin(); ite != o.end(); ite++) {
                jsonmap.insert(std::make_pair(ite->first, ite->second.to_str()));
                std::cout << ite->first << ":" << ite->second.to_str() << std::endl;
                if(it == array.end() - 1) {
                    int c = static_cast<int>(jsonmap.count(valueName));
                    if(c == 0) {
                        picojson::object obj;
                        obj.emplace(std::make_pair(valueName, picojson::value(value)));
                        array.push_back(picojson::value(obj));
                    }
                }
            }
        }
        std::cout << v << std::endl;
    }
}
