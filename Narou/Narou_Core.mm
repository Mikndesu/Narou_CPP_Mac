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
#include <curl/curl.h>
#include "picojson.h"

@implementation UseCurl

-(void) usecurl {
    using namespace picojson;
    CURL * curl;
    CURLcode ret;
    //When I access NintendoAPI
//    const char* url = "https://app.splatoon2.nintendo.net/api/data/stages";
    //Your iksm_session
//    const char* thecookie = "";
    //When I access Narou
    const char* url = "http://api.syosetu.com/novelapi/api/?out=json&gzip=5";
    const char* useragent = "Mozilla/5.0 (X11; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0";
    
    curl = curl_easy_init();
    std::string chunk;
    
    if(curl == NULL) {
        std::cerr << "curl_east_init() failed" << std::endl;
    }
    
    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, callbackWrite);
    curl_easy_setopt(curl, CURLOPT_USERAGENT, useragent);
//    curl_easy_setopt(curl, CURLOPT_COOKIE, thecookie);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &chunk);
    ret = curl_easy_perform(curl);
    curl_easy_cleanup(curl);
    
    if (ret != CURLE_OK) {
            std::cerr << "curl_easy_perform() failed." << std::endl;
    }

    std::cout << chunk << std::endl;
    
}

size_t callbackWrite(char *ptr, size_t size, size_t nmemb, std::string * stream) {
    int datalength = size * nmemb;
    stream -> append(ptr, datalength);
    return datalength;
}

@end
