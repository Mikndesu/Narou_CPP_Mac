//
//  OnClickFunction.h
//  Narou
//
//  Created by MitsukiGoto on 2019/12/14.
//  Copyright © 2019 五島充輝. All rights reserved.
//

#ifndef OnClickFunction_h
#define OnClickFunction_h

#ifdef __OBJC__
#import <Foundation/Foundation.h>

@interface OnClickFun : NSObject

-(NSInteger) getIsReNew;
-(NSString *) getnovelname;
-(void) showLog;
-(void) rewriteJson:(NSString *) of ncode:(NSString *) ncode;
-(void) deleteSettings;

@end
#endif

#ifdef __cplusplus

class OnClickFunction {
public:
    void setisReNew(NSInteger IsReNew);
    void setnovelname(NSMutableString* novelName);
};

#endif

#endif /* OnClickFunction_h */
