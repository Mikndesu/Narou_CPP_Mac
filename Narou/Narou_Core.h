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

-(NSInteger) getIsReNew;
-(NSString *) getnovelname;
-(void) usecurlmain;
-(void) showLog;
-(void) writelog:(NSString *) contents;
-(void) rewriteJson:(NSString *) of ncode:(NSString *) ncode;
-(void) deleteSettings;

@end

#endif /* Narou_Core_h */
