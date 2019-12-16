//
//  Narou_Core.h
//  Narou
//
//  Created by MitsukiGoto on 2019/11/19.
//  Copyright © 2019 五島充輝. All rights reserved.
//

#ifndef Narou_Core_h
#define Narou_Core_h

#ifdef __OBJC__
#import <Foundation/Foundation.h>
@interface UseCurlMain : NSObject

-(void) usecurlmain;
-(void) writelog:(NSString*) contents;
@end
#endif

#ifdef __cplusplus
#include <string>

class Narou_Core {
public:
    std::string makeNeedFile();
};

#endif

#endif /* Narou_Core_h */
