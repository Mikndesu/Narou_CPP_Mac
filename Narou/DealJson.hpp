//
//  DealJson.hpp
//  Narou
//
//  Created by MitsukiGoto on 2019/12/05.
//  Copyright © 2019 五島充輝. All rights reserved.
//

#ifndef DealJson_hpp
#define DealJson_hpp

#include <stdio.h>
#include <array>
#include <string>

class DealJson {
    
    public :
    
    std::string readJsonFilefromInternet(const char* contents);
    
    std::string readWords(std::string novelName);
    
    //std::array<std::string, 5>
    std::array<std::string, 4> readJsonFilefromLocal(std::string filepath);
    
    void makeJsonFile(std::string filepath, std::string ncode, std::string of);
    
    void saveWords(std::string filepath, std::string novelName, std::string words);
    
    void addNovels(std::string novelname);
};

#endif /* DealJson_hpp */
