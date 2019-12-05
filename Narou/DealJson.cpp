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
std::array<std::string, 2> DealJson::readJsonFilefromLocal(std::string filepath) {
    picojson::value v;
    std::string err;
    std::string contents;
    std::ifstream ifs;
    ifs.open(filepath, std::ios::in);
    std::getline(ifs, contents);
    ifs.close();
    picojson::parse(v, contents.c_str(), contents.c_str() + strlen(contents.c_str()), &err);
    std::array<std::string, 2> result;
    if(err.empty()) {
        picojson::object &o = v.get<picojson::object>();
        picojson::array& array = o["Settings"].get<picojson::array>();
        int i = 0;
        for (picojson::array::iterator it = array.begin(); it != array.end(); it++) {
            picojson::object& o = it->get<picojson::object>();
            picojson::object& e = o["CURLSETTIGS"].get<picojson::object>();
            if(i == 0) {
                result[i] = e["url_Naoru"].get<std::string>();
                i++;
            } else if (i == 1) {
                result[i] = e["useragent"].get<std::string>();
            }
        }
    }
    return result;
}

void DealJson::makeJsonFile(std::string filepath) {
    
    std::ofstream ofs;
    ofs.open(filepath, std::ios::out);
    
    picojson::object license;
    picojson::array datalist;
    {
        picojson::object data;
        data.insert(std::make_pair("url_Naoru", picojson::value("http://api.syosetu.com/novelapi/api/?out=json&of=l&ncode=N2267BE")));
        data.insert(std::make_pair("useragent", picojson::value("Mozilla/5.0 (X11; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0")));

        picojson::object id;
        id.insert(std::make_pair("CURLSETTIGS", picojson::value(data)));

        datalist.push_back(picojson::value(id));
    }
    
    license.insert(std::make_pair("Settings", picojson::value(datalist)));
    
    ofs << picojson::value(license) << std::endl;
    ofs.close();
    
    std::cout << picojson::value(license) << std::endl;
}

