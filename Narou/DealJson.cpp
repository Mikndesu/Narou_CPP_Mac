//
//  DealJson.cpp
//  Narou
//
//  Created by MitsukiGoto on 2019/12/05.
//  Copyright © 2019 五島充輝. All rights reserved.
//

#include "DealJson.hpp"
#include <string>
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
//void DealJson::readJsonFilefromLocal(std::string filepath) {
//    picojson::value v;
//    std::string err;
//    picojson::parse(v, )
//}

void DealJson::makeJsonFile(std::string filepath) {
    
    std::ofstream ofs;
    ofs.open(filepath, std::ios::out);
    
    picojson::object license;
    picojson::array datalist;
    {
        picojson::object data;
        data.insert(std::make_pair("url_Naoru", picojson::value("http://api.syosetu.com/novelapi/api/?out=json&gzip=5")));
        data.insert(std::make_pair("url_iksm", picojson::value("https://app.splatoon2.nintendo.net/api/data/stages")));
        data.insert(std::make_pair("iksm_session", picojson::value("")));
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

