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
    
    std::string readWordsfromInternet(std::string jsonobj);
    
    std::string readWordsfromLocal(std::string filepath, std::string novelName);
    
    std::string readSettingsJsonFile(std::string filepath, std::string novelName);
    
    void makeSettingsJsonFile(std::string filepath);
    
    void saveWords(std::string filepath, std::string novelName, std::string words);
    
    void addNovels(std::string filepath, std::string novelName, std::string value);
};

#endif /* DealJson_hpp */
