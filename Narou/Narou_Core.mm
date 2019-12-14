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
#include <cstdlib>
#include <curl/curl.h>
#include "picojson.h"
#include "DealJson.hpp"

@implementation UseCurlMain

NSInteger isReNew;
NSMutableString* novelname = [NSMutableString string];

DealJson dj;

struct Aboutcurl {
    const char* name;
    const char* url;
    const char* useragent;
};

void writeLog(){}

//A Method for Making Directory to Save Setting Files
std::string makeNeedFile() {
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

std::string cachepath = makeNeedFile();

-(void) usecurlmain {
    
//    ?out=json&of=l&ncode=N2267BE
    std::string filepath = cachepath;
    filepath += "/settings.json";
    std::ifstream ifs(filepath);
    if(!ifs) {
        dj.makeJsonFile(filepath, "", "");
        ifs.close();
    }
    std::array<std::string, 4> value = dj.readJsonFilefromLocal(filepath);
    for(int i = 0; i < 4; i++) {
        std::cout << value[i] << std::endl;
    }
    std::string url = value[3] + "?out=" + value[2] + "&of=" + value[1] + "&ncode=" + value[0];
    std::cout << url << std::endl;
    Aboutcurl aboutcurl[] = {
        {"Narou", url.c_str(), "Mozilla/5.0 (X11; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0"}
    };
    
    docurl(aboutcurl[0]);
    
}

//C++ Method Wrapper for ObjC & Swift
-(void) writelog: (NSString *) contents {
    //Wrote down this contents
    std::string s = [contents UTF8String];
    writeLog(s);
}

//Receive Value to AppDelegate.Swift
-(NSInteger) getIsReNew {
    return isReNew;
}

-(NSString* ) getnovelname {
    return novelname;
}

-(void) showLog {
    std::string command = "open ";
    std::string filepath = cachepath;
    filepath += "/logs.txt";
    command += filepath;
    system(command.c_str());
    writeLog("delete Settings.json");
}

-(void) rewriteJson:(NSString *) of ncode:(NSString *) ncode {
    std::string filepath = cachepath;
    filepath += "/settings.json";
    dj.makeJsonFile(filepath, [ncode UTF8String], [of UTF8String]);
}

-(void) deleteSettings {
    std::string command = "rm ";
    std::string filepath = cachepath;
    filepath += "/settings.json";
    command += filepath;
    std::cout << command << std::endl;
    system(command.c_str());
}

//see https://cpprefjp.github.io/lang/cpp11/variadic_templates.html
template <class Head, class... Tail>
void writeLog(Head&& head, Tail&&... tail) {
    std::string filepath = cachepath;
    filepath += "/logs.txt";
    std::ofstream ofs;
    ofs.open(filepath, std::ios::app);
    if(!ofs) {
        std::cout << "Can't Open" << std::endl;
    }
    ofs << head << std::endl;
    ofs.close();
    writeLog(std::forward<Tail>(tail)...);
}

void renewCheck(std::string contents, std::string filepath) {
    
    int a,b;
    
    std::ifstream ifs(filepath);
    //the novels words to get ReNewal Info
    std::string words;
    std::getline(ifs, words);
    std::cout << words << std::endl;
    
    if(words.empty()) {
        a = 0;
    } else {
        a = std::stoi(words);
    }
    
    ifs.close();
    
    std::ofstream ofs;
    ofs.open(filepath, std::ios::out);
    
    std::string next_words = dj.readJsonFilefromInternet(contents.c_str());
    std::cout << next_words << std::endl;
    
    if(next_words.empty()) {
        b = 0;
    } else {
        b = std::stoi(next_words);
    }
       
    ofs << next_words << std::endl;
    ofs.close();
    
    if(a < b) {
        //Here means there are new Renewals
        isReNew = 1;
        novelname = [NSMutableString stringWithString:@"ReZero"];
        std::cout << "a<b" << std::endl;
        writeLog(words, next_words, "a<b");
    } else if(a == b) {
        //Here means there is no Renewals
        isReNew = 0;
        novelname = [NSMutableString stringWithString:@"ReZero"];
        std::cout << "a==b" << std::endl;
        writeLog(words, next_words, "a==b");
    }
}

//A Method for Executing CURL
void docurl(const Aboutcurl aboutcurl) {

    CURL *curl;
    CURLcode ret;
    curl = curl_easy_init();
    std::string chunk;
    
    std::string filepath = cachepath;
    filepath += "/data.txt";
    
    if(curl == NULL) {
        std::cerr << "curl_east_init() failed" << std::endl;
    }
        
    curl_easy_setopt(curl, CURLOPT_URL, aboutcurl.url);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, callbackWrite);
    curl_easy_setopt(curl, CURLOPT_USERAGENT, aboutcurl.useragent);
    //    curl_easy_setopt(curl, CURLOPT_COOKIE, thecookie);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &chunk);
    ret = curl_easy_perform(curl);
    curl_easy_cleanup(curl);
        
    if (ret != CURLE_OK) {
        std::cerr << "curl_easy_perform() failed." << std::endl;
    }
   
    chunk.replace(34, 1, "");
    chunk.replace(0, 16, "");
    chunk.insert(10, "\"");
    chunk.insert(18, "\"");

    renewCheck(chunk, filepath);
    std::cout << chunk << std::endl;
}

size_t callbackWrite(char *ptr, size_t size, size_t nmemb, std::string * stream) {
    int datalength = size * nmemb;
    stream -> append(ptr, datalength);
    return datalength;
}

@end
