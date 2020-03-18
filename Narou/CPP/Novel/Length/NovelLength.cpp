//
//  NovelLength.cpp
//  Narou
//
//  Created by MitsukiGoto on 2020/03/13.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#include "NovelLength.hpp"
#include "picojson.h"
#include <curl/curl.h>
#include <fstream>

NovelLength::NovelLength(const std::string novelName,const std::string ncode, const std::string lengthPath) : _novelName(novelName), _ncode(ncode), _apiUrl("http://api.syosetu.com/novelapi/api/?out=json&of=l&ncode="), _lengthPath(lengthPath), _presentLength(0) {
    if(isFileExists()) {
        getPreviousLength();
    }
}

NovelLength::~NovelLength() {
    std::ifstream ifs(_lengthPath, std::ios::in);
    std::string data, err;
    std::getline(ifs, data);
    picojson::value v;
    if(!data.empty()){
        picojson::parse(v, data.c_str(), data.c_str()+strlen(data.c_str()), &err);
    }
    auto& array = v.get<picojson::array>();
    for(auto& e:array) {
        auto& o = e.get<picojson::object>();
        if(o.find(_novelName) != o.end()) {
            o[_novelName] = picojson::value(std::to_string(_presentLength));
        }
    }
    std::ofstream ofs(_lengthPath, std::ios::out);
    ofs << picojson::value(array) << std::endl;
    ofs.close();
}

bool NovelLength::isReNew() {
    std::string jsonObj = requestNarouAPI();
    picojson::value v;
    std::string err;
    picojson::parse(v, jsonObj.c_str(), jsonObj.c_str()+strlen(jsonObj.c_str()), &err);
    if(err.empty()) {
        std::cout << err << std::endl;
        std::cout << __LINE__ << std::endl;
    }
    picojson::array& array = v.get<picojson::array>();
    for(auto it = array.begin(); it != array.end(); it++) {
        picojson::object& o = it->get<picojson::object>();
        for(auto ite = o.begin(); ite != o.end(); ite++) {
            if(ite->first == "length") _presentLength = std::stoi(ite->second.to_str());
        }
    }
    return _presentLength > _previousLength;
}

void NovelLength::getPreviousLength() {
    std::ifstream ifs(_lengthPath, std::ios::in);
    std::string data, err;
    std::getline(ifs, data);
    picojson::value v;
    picojson::parse(v, data.c_str(), data.c_str()+strlen(data.c_str()), &err);
    if(err.empty()) {
        std::cout << err << std::endl;
        std::cout << __LINE__ << std::endl;
    }
    if(isNovelExists(v)) {
        for(auto& e:v.get<picojson::array>()){
            auto o = e.get<picojson::object>()[_novelName];
            if(o.is<picojson::null>() == false && o.to_str()!="") {
                _previousLength = std::stoi(o.to_str()); break;
            } else {
                _previousLength = 0;
            }
        }
    } else {
        _previousLength = 0;
    }
}

std::string NovelLength::requestNarouAPI() const {
    CURL *curl;
    CURLcode ret;
    
    curl = curl_easy_init();
    std::string chunk, reqURL;
    const char* userAgent = "Mozilla/5.0 (X11; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0";
    
    if(curl == NULL) {
        std::cerr << "curl_east_init() failed" << std::endl;
    }
    
    reqURL = _apiUrl + _ncode;
    
    curl_easy_setopt(curl, CURLOPT_URL, reqURL.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, +[](char *ptr, size_t size, size_t nmemb, std::string *stream){int datalength = static_cast<int>(size * nmemb);
        stream -> append(ptr, datalength);return datalength;});
    curl_easy_setopt(curl, CURLOPT_USERAGENT, userAgent);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &chunk);
    
    ret = curl_easy_perform(curl);
    curl_easy_cleanup(curl);
    
    
    if (ret != CURLE_OK) {
        std::cerr << "curl_easy_perform() failed." << std::endl;
    }
    
    std::cout << chunk << std::endl;
    
    return chunk;
}

bool NovelLength::isFileExists() {
    std::ifstream ifs(_lengthPath, std::ios::in);
    if(ifs.is_open()) {
        return true;
    } else {
        std::ofstream ofs(_lengthPath, std::ios::out);
        picojson::array array;
        picojson::object object;
        object.emplace(std::make_pair(_novelName, picojson::value("")));
        array.push_back(picojson::value(object));
        ofs << picojson::value(array) << std::endl;
        _previousLength = 0;
        return false;
    }
}

bool NovelLength::isNovelExists(const picojson::value& v) {
    const auto array = v.get<picojson::array>();
    for(auto it = array.begin(); it != array.end(); it++) {
        auto object = it->get<picojson::object>();
        if(object.count(_novelName) == 1) {
            return true;
        } else if(object.count(_novelName) == 0 && it == array.end()--) {
            return false;
        }
    }
    return false;
}
