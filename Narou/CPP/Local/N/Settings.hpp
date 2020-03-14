//
//  Settings.hpp
//  Narou
//
//  Created by MitsukiGoto on 2020/03/12.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#ifndef Settings_hpp
#define Settings_hpp

#include <stdio.h>
#include <map>
#include <string>

class Settings {
public:
    Settings(std::string);
    std::map<std::string, std::string> parseSettigs();
private:
    std::string settingFilePath;
    void makeSettigsFile();
};

#endif /* Settings_hpp */
