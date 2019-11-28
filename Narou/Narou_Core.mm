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
#include <boost/iostreams/device/file.hpp>
#include <boost/iostreams/filtering_stream.hpp>
#include <boost/iostreams/filter/gzip.hpp>
#include <curl/curl.h>
#include "picojson.h"

@implementation UseCurlMain

struct Aboutcurl {
    const char* name;
    const char* url;
    const char* useragent;
    const char* iksm_session;
};

-(void) usecurlmain {
    
    Aboutcurl aboutcurl[] = {
        {"Narou", "http://api.syosetu.com/novelapi/api/?out=json", "Mozilla/5.0 (X11; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0", ""},
        {"Iksm", "https://app.splatoon2.nintendo.net/api/data/stages", "Mozilla/5.0 (X11; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0", ""}
    };
    
    char filepath[FILENAME_MAX];
    std::string s = makedir();
    s += "/data.gzip";
    sprintf(filepath, "%s", s.c_str());
    
    std::cout << filepath << std::endl;
    docurl(aboutcurl[0]);
    makeJsonFile();
    
}

size_t callbackWrite(char *ptr, size_t size, size_t nmemb, std::string * stream) {
    int datalength = size * nmemb;
    stream -> append(ptr, datalength);
    return datalength;
}

std::string makedir() {
    NSArray* array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cacheDirPath = [array objectAtIndex:0];
    NSString* newCacheDirPath = [cacheDirPath stringByAppendingPathComponent:@"Settings_Narou"];
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

void docurl(const Aboutcurl aboutcurl) {

    CURL * curl;
    CURLcode ret;
    curl = curl_easy_init();
    std::string chunk;
    
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
    
    std::cout << chunk << std::endl;
}

void makeJsonFile() {
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
    std::cout << picojson::value(license) << std::endl;
}

@end
