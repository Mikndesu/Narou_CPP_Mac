//
//  DealJson.cpp
//  Narou
//
//  Created by MitsukiGoto on 2019/12/05.
//  Copyright © 2019 五島充輝. All rights reserved.
//
//
//#include "DealJson.hpp"
//#include <string>
//#include <array>
//#include <fstream>
//#include <vector>
//#include <iostream>
//#include "picojson.h"
//
//#define CONTENTS_FROMPATH(filepath, contents, v, err) do {std::ifstream ifs; ifs.open(filepath, std::ios::in); std::getline(ifs, contents); ifs.close(); picojson::parse(v, contents.c_str(), contents.c_str() + strlen(contents.c_str()), &err);} while(0)
//
//#define CHECK std::cout<<__LINE__<< std::endl;
//
//void makeDatas(std::string filepath, std::string name, std::string value) {
//    std::ofstream ofs;
//    ofs.open(filepath, std::ios::app);
//    picojson::array array;
//    picojson::object object;
//    for(auto iterator = object.begin(); iterator != object.end(); iterator++) {
//        if(iterator->first == name) {
//            goto PROCESS_END;
//        }
//    }
//    object.emplace(std::make_pair(name, picojson::value(value)));
//    array.push_back(picojson::value(object));
//    ofs << picojson::value(array) << std::endl;
//PROCESS_END:
//    ofs.close();
//}
//
////A General Method instead of readJsonFilefromInternet
//std::string DealJson::readWordsfromInternet(std::string jsonobj) {
//    picojson::value v;
//    std::string err, words;
//    picojson::parse(v, jsonobj.c_str(), jsonobj.c_str() + strlen(jsonobj.c_str()), &err);
//    if(err.empty()) {
//        picojson::array& array = v.get<picojson::array>();
//        for(auto it = array.begin(); it != array.end(); it++) {
//            picojson::object& o = it->get<picojson::object>();
//            for(auto ite = o.begin(); ite != o.end(); ite++) {
//                if(ite->first == "length") {
//                    words = ite->second.to_str();
//                }
//            }
//        }
//    }
//    return words;
//}
//
//std::string DealJson::readWordsfromLocal(std::string filepath, std::string novelName) {
//    picojson::value v;
//    std::string err, jsonobj, check;
//    std::ifstream i;
//    i.open(filepath, std::ios::in);
//    std::getline(i, check);
//    if(check.empty()) {
//        return "";
//    }
//    CONTENTS_FROMPATH(filepath, jsonobj, v, err);
//    if(err.empty()) {
//        picojson::array& array = v.get<picojson::array>();
//        for(auto it = array.begin(); it != array.end(); it++) {
//            picojson::object o = it->get<picojson::object>();
//            if(o.count(novelName) == 0 && it == array.end() - 1) {
//                picojson::object obj;
//                obj.emplace(std::make_pair(novelName, picojson::value("")));
//                array.push_back(picojson::value(obj));
//                std::ofstream ofs;
//                ofs.open(filepath, std::ios::trunc);
//                ofs << picojson::value(array) << std::endl;
//                return "";
//            }
//            if(o.count(novelName) == 1) {
//                return o[novelName].get<std::string>();
//            }
//        }
//    }
//    return "";
//}
//
//std::map<std::string, std::string> DealJson::readSettingsJsonFile(std::string filepath) {
//    picojson::value v;
//    std::string err, jsonobj;
//    std::map<std::string, std::string> names;
//    CONTENTS_FROMPATH(filepath, jsonobj, v, err);
//    if(err.empty()) {
//        picojson::array& array = v.get<picojson::array>();
//        for(auto it = array.begin(); it != array.end(); it++) {
//            picojson::object& o = it->get<picojson::object>();
//            for(auto ite = o.begin(); ite != o.end(); ite++) {
//                names.insert(std::make_pair(ite->first, ite->second.to_str()));
//            }
//        }
//    }
//    return names;
//}
//
//void DealJson::makeSettingsJsonFile(std::string filepath) {
//    std::ofstream ofs;
//    ofs.open(filepath, std::ios::out);
//    picojson::object obj;
//    picojson::array array;
//    {
//        obj.emplace(std::make_pair("ReZero", picojson::value("N2267BE")));
//        array.push_back(picojson::value(obj));
//    }
//    ofs << picojson::value(array) << std::endl;
//    ofs.close();
//}
//
//void DealJson::saveWords(std::string filepath, std::string novelName, std::string words) {
//    std::string err, check;
//    picojson::value v;
//    std::ifstream i;
//    i.open(filepath, std::ios::in);
//    std::getline(i, check);
//    i.close();
//    int count = 0;
//    if(check.empty()) {
//        std::cout << "Data.json is Empty" << std::endl;
//        makeDatas(filepath, novelName, words);
//    }
//    const char* jsonobj = check.c_str();
//    picojson::parse(v, jsonobj, jsonobj + strlen(jsonobj), &err);
//    if(err.empty()) {
//        picojson::array& array = v.get<picojson::array>();
//        picojson::array r;
//        picojson::object object, obj;
//        for(auto i = array.begin(); i != array.end(); i++) {
//            object = i->get<picojson::object>();
//            if(object.count(novelName) == 1) {
//                obj.emplace(std::make_pair(novelName, picojson::value(words)));
//                r.push_back(picojson::value(obj));
//                count = 1;
//            } else if(object.count(novelName) == 0) {
//                r.push_back(picojson::value(object));
//                if(i == array.end()-1 && count == 0) {
//                    std::cout << "New" << std::endl;
//                    obj.emplace(std::make_pair(novelName, picojson::value(words)));
//                    r.push_back(picojson::value(obj));
//                }
//            }
//        }
//        std::ofstream ofs;
//        ofs.open(filepath, std::ios::trunc);
//        ofs << picojson::value(r) << std::endl;
//        std::cout << picojson::value(r) << std::endl;
//        ofs.close();
//    }
//}
//
//void DealJson::addNovels(std::string filepath, std::string novelName, std::string value) {
//    std::string err, check;
//    picojson::value v;
//    std::ifstream i;
//    i.open(filepath, std::ios::in);
//    std::getline(i, check);
//    i.close();
//    if(check.empty()) {
//        std::cout << "Settings.json EMPTY" << std::endl;
//        makeDatas(filepath, novelName, value);
//    }
//    const char* jsonobj = check.c_str();
//    picojson::parse(v, jsonobj, jsonobj + strlen(jsonobj), &err);
//    picojson::array& array = v.get<picojson::array>();
//    picojson::object object;
//    for(auto i = array.begin(); i != array.end(); i++) {
//        object = i->get<picojson::object>();
//        if(object.count(novelName) == 0 && i == array.end()-1) {
//            picojson::object obj;
//            obj.emplace(std::make_pair(novelName, picojson::value(value)));
//            array.push_back(picojson::value(obj));
//            goto END;
//        } else if(object.count(novelName) == 1) {
//            goto END;
//        }
//    }
//END:
//    std::ofstream ofs;
//    ofs.open(filepath, std::ios::trunc);
//    ofs << picojson::value(array) << std::endl;
//    ofs.close();
//}
