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

//in Progress
std::array<std::string, 4> DealJson::readJsonFilefromLocal(std::string filepath) {
     picojson::value v;
       std::string err;
       std::string contents;
       std::ifstream ifs;
       ifs.open(filepath, std::ios::in);
       std::getline(ifs, contents);
       ifs.close();
       picojson::parse(v, contents.c_str(), contents.c_str() + strlen(contents.c_str()), &err);
       std::array<std::string, 4> result;
    if(err.empty()) {
        picojson::object& o = v.get<picojson::object>();
        picojson::object& e = o["CurlSettings"].get<picojson::object>();
        result[0] = e["ncode"].get<std::string>();
        result[1] = e["of"].get<std::string>();
        result[2] = e["out"].get<std::string>();
        result[3] = e["request_url"].get<std::string>();
    }
    return result;
}

void DealJson::makeJsonFile(std::string filepath, std::string ncode, std::string of) {
    
    // expected out
    //    https://tools.m-bsys.com/development_tooles/json-beautifier.php
    //
    //    {
    //        "CurlSettings": {
    //            "ncode": "N2267BE",
    //            "of": "l",
    //            "out": "json",
    //            "request_url": "http://api.syosetu.com/novelapi/api/"
    //        }
    //    }
    
    std::ofstream ofs;
    ofs.open(filepath, std::ios::out);
    
    picojson::object license;
    picojson::object data;
    {
        data.emplace(std::make_pair("request_url", picojson::value("http://api.syosetu.com/novelapi/api/")));
        data.emplace(std::make_pair("out", picojson::value("json")));
        if(ncode.empty()) {
            data.emplace(std::make_pair("ncode", picojson::value("N2267BE")));
        } else {
            data.emplace(std::make_pair("ncode", picojson::value(ncode)));
        }
        if(of.empty()) {
            data.emplace(std::make_pair("of", picojson::value("l")));
        } else {
            data.emplace(std::make_pair("of", picojson::value(of)));
        }
        license.emplace(std::make_pair("CurlSettings", picojson::value(data)));
    }
    
//    license.insert(std::make_pair("Settings", picojson::value(datalist)));
    
    ofs << picojson::value(license) << std::endl;
    ofs.close();
}

