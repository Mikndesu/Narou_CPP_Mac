//
//  Narou_Core.h
//  Narou
//
//  Created by MitsukiGoto on 2019/11/19.
//  Copyright © 2019 五島充輝. All rights reserved.
//

#ifndef Narou_Core_h
#define Narou_Core_h

#import <Foundation/Foundation.h>
@interface UseCurlMain : NSObject

-(NSArray*) usecurlmain;
-(void) writelog:(NSString*) contents;
-(void) addNovelonGUI:(NSString *) novelname ncode:(NSString *) ncode;

@end

#endif /* Narou_Core_h */
