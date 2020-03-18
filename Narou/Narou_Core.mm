//
//  Narou_Core.mm
//  Narou
//
//  Created by MitsukiGoto on 2019/11/19.
//  Copyright © 2019 五島充輝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Narou_Core.h"
#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include "CPP/Narou.hpp"

@implementation UseCurlMain

void writeLog(){}

//A Method for Making Directory to Save Setting Files
std::string makeNeedFile() {
    NSArray* array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cacheDirPath = [array objectAtIndex:0];
    NSString* newCacheDirPath = [cacheDirPath stringByAppendingPathComponent:@"Narou"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    BOOL created = [fileManager createDirectoryAtPath:(newCacheDirPath) withIntermediateDirectories:(YES) attributes:(nil) error:&error];
    if (!created) {
        std::cerr << "FAILED TO CREATE DHIRECTORY" << std::endl;
        NSLog(@"%@ - %@", error, error.userInfo);
    }
    std::string result = [newCacheDirPath UTF8String];
    return result;
}

const std::string rootpath = makeNeedFile();
const std::string logpath = rootpath + "/log.txt";
const std::string lengthpath = rootpath + "/length.json";
const std::string ncodepath = rootpath + "/ncode.json";

//see https://cpprefjp.github.io/lang/cpp11/variadic_templates.html
template <class Head, class... Tail>
void writeLog(Head&& head, Tail&&... tail) {
    std::ofstream ofs;
    ofs.open(logpath, std::ios::app);
    if(!ofs) {
        std::cout << "Can't Open" << std::endl;
    }
    ofs << head << std::endl;
    ofs.close();
    writeLog(std::forward<Tail>(tail)...);
}

-(NSArray*) usecurlmain {
    std::unique_ptr<Narou> narou(new Narou(ncodepath, lengthpath));
    auto novels = narou->checkAll();
    if(std::begin(novels) != std::end(novels)) {
        auto *renewedNovel = [NSMutableArray array];
        for(const auto& e:novels) {
            std::cout << e << std::endl;
            [renewedNovel addObject:[NSString stringWithUTF8String:e.c_str()]];
        }
        return (NSArray*)renewedNovel;
    }
    return [NSArray array];
}

//C++ Method Wrapper for ObjC & Swift
-(void) writelog:(NSString*) contents {
    //Wrote down this contents
    std::string s = [contents UTF8String];
    writeLog(s);
}

-(void) addNovelonGUI:(NSString *) novelname ncode:(NSString *) ncode {
    std::unique_ptr<Narou> narou(new Narou(ncodepath, lengthpath));
    narou->addNovel([novelname UTF8String], [ncode UTF8String]);
}

@end
