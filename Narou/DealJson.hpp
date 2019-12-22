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
    
    std::string readWords(std::string jsonobj);
    
    std::array<std::string, 3> readSettingsJsonFilefromLocal(std::string filepath);
    
    void makeSettingsJsonFile(std::string filepath, std::string ncode);
    
    void saveWords(std::string filepath, std::string novelName, std::string words);
    
    void addNovels(std::string filepath, std::string valueName, std::string value);
};

#endif /* DealJson_hpp */
