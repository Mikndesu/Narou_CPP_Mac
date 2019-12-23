//
//  OnClickFunction.m
//  Narou
//
//  Created by MitsukiGoto on 2019/12/14.
//  Copyright © 2019 五島充輝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OnClickFunction.h"
#import "Narou_Core.h"
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <string>
#include "DealJson.hpp"

@implementation OnClickFun

NSInteger isReNew;
NSMutableString* novelname = [NSMutableString string];
DealJson dJ;
Narou_Core nC;

std::string cachePath = nC.makeNeedFile();

void OnClickFunction::setisReNew(NSInteger IsReNew) {
    isReNew = IsReNew;
}

void OnClickFunction::setnovelname(NSString* novelName) {
    novelname = novelName;
}

//Receive Value to AppDelegate.Swift
-(NSInteger) getIsReNew {
    return isReNew;
}

-(NSString*) getnovelname {
    return novelname;
}

-(void) showLog {
    std::string command = "open ";
    std::string filepath = cachePath;
    filepath += "/logs.txt";
    command += filepath;
    system(command.c_str());
    std::ofstream ofs;
    ofs.open(filepath, std::ios::app);
    if(!ofs) {
        std::cout << "Can't Open" << std::endl;
    }
    ofs << "delete settings.json" << std::endl;
    ofs.close();
}

-(void) deleteSettings {
    std::string command = "rm ";
    std::string filepath = cachePath;
    filepath += "/settings.json";
    command += filepath;
    std::cout << command << std::endl;
    system(command.c_str());
}

-(void) addNovelonGUI:(NSString *) novelname ncode:(NSString *) ncode {
}

@end
