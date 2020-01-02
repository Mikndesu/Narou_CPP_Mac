//
//  Narou_Core.mm
//  Narou
//
//  Created by MitsukiGoto on 2019/11/19.
//  Copyright © 2019 五島充輝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Narou_Core.h"
#include <iostream>
#include <string>
#include <fstream>
#include <array>
#include <cstdarg>
#include <utility>
#include <curl/curl.h>
#include "OnClickFunction.h"
#include "DealJson.hpp"

@implementation UseCurlMain

DealJson dj;
Narou_Core nc;
OnClickFunction ocf;

const std::string rootpath = nc.makeNeedFile();
const std::string logpath = rootpath + "/log.txt";
const std::string datapath = rootpath + "/data.json";
const std::string settingspath = rootpath + "/settings.json";

void writeLog(){}

//A Method for Making Directory to Save Setting Files
std::string Narou_Core::makeNeedFile() {
    NSArray* array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cacheDirPath = [array objectAtIndex:0];
    NSString* newCacheDirPath = [cacheDirPath stringByAppendingPathComponent:@"Narou"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    BOOL created = [fileManager createDirectoryAtPath:(newCacheDirPath) withIntermediateDirectories:(YES) attributes:(nil) error:&error];
    if (!created) {
        std::cerr << "FAILED TO CREATE DHIRECTORY" << std::endl;
        NSLog(@"%@ - %@", error, error.userInfo);
    }
    std::string result = [newCacheDirPath UTF8String];
    return result;
}

std::string cachepath = nc.makeNeedFile();

//see https://cpprefjp.github.io/lang/cpp11/variadic_templates.html
template <class Head, class... Tail>
void writeLog(Head&& head, Tail&&... tail) {
    std::ofstream ofs;
    ofs.open(logpath, std::ios::app);
    if(!ofs) {
        std::cout << "Can't Open" << std::endl;
    }
    ofs << head << std::endl;
    ofs.close();
    writeLog(std::forward<Tail>(tail)...);
}

-(void) usecurlmain {
    std::ifstream ifs(settingspath);
    if(!ifs) {
        dj.makeSettingsJsonFile(settingspath);
        ifs.close();
    }
    std::map<std::string, std::string> ncodes = dj.readSettingsJsonFile(settingspath);
    std::string url = "http://api.syosetu.com/novelapi/api/?out=json&of=l&ncode=";
    std::string path;
    std::cout << ncodes.size() << std::endl;
    for(auto it = ncodes.begin(); it != ncodes.end(); it++) {
        std::cout << "Execute CURL" << std::endl;
        docurl(url, it->second, it->first);
    }
//    dj.addNovels(settingspath, "AAA", "N1443BP");
}

//C++ Method Wrapper for ObjC & Swift
-(void) writelog:(NSString*) contents {
    //Wrote down this contents
    std::string s = [contents UTF8String];
    writeLog(s);
}

//this words is from Internet
void renewCheck(std::string wordsfromInternet, std::string novelName, std::string filepath) {
    int before,after;
    
    std::cout << __LINE__ << std::endl;
    //filepath should be datapath
    std::string words = dj.readWordsfromLocal(filepath, novelName);

    if(words.empty()) {
        before = 0;
    } else {
        before = std::stoi(words);
    }
    
    std::string next_words = wordsfromInternet;
    
    if(next_words.empty()) {
        after = 0;
    } else {
        after = std::stoi(next_words);
    }
    dj.saveWords(filepath, novelName, next_words);
    NSString* novelname = [NSString stringWithUTF8String:novelName.c_str()];
    compareCheck(before, after, novelname, words, next_words);
}

void compareCheck(int before, int after, NSString* novelName, std::string words, std::string next_words) {
    if(before < after) {
        //Here means there are new Renewals
        ocf.setisReNew(1);
        ocf.setnovelname(novelName);
        writeLog(words, next_words, "a<b");
    } else if(before == after) {
        //Here means there is no Renewals
        //        isReNew = 0;
        ocf.setisReNew(0);
        ocf.setnovelname(novelName);
        writeLog(words, next_words, "a==b");
    }
}

//A Method for Executing CURL
void docurl(std::string url, std::string ncode, std::string novelName) {
    
    CURL *curl;
    CURLcode ret;
    curl = curl_easy_init();
    std::string chunk, reqURL;
    const char* userAgent = "Mozilla/5.0 (X11; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0";
    
    if(curl == NULL) {
        std::cerr << "curl_east_init() failed" << std::endl;
    }
    
    reqURL = url + ncode;
    
    curl_easy_setopt(curl, CURLOPT_URL, reqURL.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, callbackWrite);
    curl_easy_setopt(curl, CURLOPT_USERAGENT, userAgent);
    //    curl_easy_setopt(curl, CURLOPT_COOKIE, thecookie);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &chunk);
    ret = curl_easy_perform(curl);
    curl_easy_cleanup(curl);
    
    if (ret != CURLE_OK) {
        std::cerr << "curl_easy_perform() failed." << std::endl;
    }
    
    std::cout << chunk << std::endl;
    std::string words = dj.readWordsfromInternet(chunk);
    std::cout << words << std::endl;
    renewCheck(words, novelName, datapath);
    std::cout << __LINE__ << std::endl;
}

size_t callbackWrite(char *ptr, size_t size, size_t nmemb, std::string *stream) {
    int datalength = static_cast<int>(size * nmemb);
    stream -> append(ptr, datalength);
    return datalength;
}

@end
