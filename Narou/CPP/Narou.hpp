//
//  Narou.hpp
//  Narou
//
//  Created by MitsukiGoto on 2020/03/13.
//  Copyright © 2020 五島充輝. All rights reserved.
//

#ifndef Narou_hpp
#define Narou_hpp

#include <iostream>
#include <string>
#include <vector>

class Narou {
public:
    Narou(const std::string, const std::string);
    std::vector<std::string> checkAll();
    void addNovel(const std::string, const std::string);
private:
    std::string _ncodePath;
    std::string _lengthPath;
};

#endif /* Narou_hpp */
