//
//  Narou.cpp
//  Narou
//
//  Created by MitsukiGoto on 2020/03/13.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#include <iostream>
#include "Narou.hpp"

Narou::Narou(std::string novelName, std::string ncode) {
    std::string apiUrl = "http://api.syosetu.com/novelapi/api/?out=json&of=l&ncode=";
    std::array<std::string, 3> novelInfo = {novelName, ncode, ""};
}

std::string Narou::internetConnection() {
    CURL *curl;
    CURLcode ret;
    curl = curl_easy_init();
    std::string chunk, reqURL;
    const char* userAgent = "Mozilla/5.0 (X11; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0";
    
    if(curl == NULL) {
        std::cerr << "curl_east_init() failed" << std::endl;
    }
    
    reqURL = apiUrl + novelInfo[1];
    
    curl_easy_setopt(curl, CURLOPT_URL, reqURL.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, [](char *ptr, size_t size, size_t nmemb, std::string *stream){int datalength = static_cast<int>(size * nmemb);
        stream -> append(ptr, datalength);return datalength;});
    curl_easy_setopt(curl, CURLOPT_USERAGENT, userAgent);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &chunk);
    
    ret = curl_easy_perform(curl);
    curl_easy_cleanup(curl);
    
    if (ret != CURLE_OK) {
        std::cerr << "curl_easy_perform() failed." << std::endl;
    }
    return chunk;
}
