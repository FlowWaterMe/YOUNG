//
//  GT_DataLogger.m
//  DataLogger
//
//  Created by Ryan on 12-9-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GT_DataLogger.h"
#include <lua.hpp>
#include <tolua++.h>

#include "DataLogger_Global.h"

#include "CoreLib/TestEngine.h"

TestEngine * pTestEngine=nil;

TOLUA_API int  tolua_DataLogger_open (lua_State* tolua_S);
TOLUA_API int  tolua_DataLogger1_open (lua_State* tolua_S);
TOLUA_API int  tolua_DataLogger2_open (lua_State* tolua_S);
TOLUA_API int  tolua_DataLogger3_open (lua_State* tolua_S);
TOLUA_API int  tolua_DataLogger4_open (lua_State* tolua_S);
TOLUA_API int  tolua_DataLogger5_open (lua_State* tolua_S);
TOLUA_API int  tolua_DataLogger6_open (lua_State* tolua_S);

@implementation GT_DataLogger

- (id)init
{
    self = [super init];
    if (self) {
        //CDataLogger::CreatDataFile();
        //CDataLogger::BuildFilePath();
        // Initialization code here.
        DataLogger1 = new CDataLogger(0);
        DataLogger2 = new CDataLogger(1);
        DataLogger3 = new CDataLogger(2);
        DataLogger4 = new CDataLogger(3);
        DataLogger5 = new CDataLogger(4);
        DataLogger6 = new CDataLogger(5);
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
    if (DataLogger1)
    {
        delete DataLogger1;
        DataLogger1 = NULL;
    }

    if (DataLogger2)
    {
        delete DataLogger2;
        DataLogger2 = NULL;
    }
    
    if (DataLogger3)
    {
        delete DataLogger3;
        DataLogger3 = NULL;
    }
    
    if (DataLogger4)
    {
        delete DataLogger4;
        DataLogger4 = NULL;
    }
    
    if (DataLogger5)
    {
        delete DataLogger5;
        DataLogger5 = NULL;
    }
    
    if (DataLogger6)
    {
        delete DataLogger6;
        DataLogger6 = NULL;
    }
}

-(int)SelfTest:(id)sender
{
	/* keep the compiler happy */
	(void)(sender);
	return 0;
}

-(int)Load:(id)sender
{
	/* keep the compiler happy */
	(void)(sender);
	return 0;
}

-(int)Unload:(id)sender
{
	/* keep the compiler happy */
	(void)(sender);
	return 0;
}

-(NSString *)ModuleName
{
    return @"GT DataLogger";
}

-(int)RegisterModule:(id)sender
{
    NSDictionary * dic = (NSDictionary *)sender;
    lua_State * lua = (lua_State *)[[dic objectForKey:@"lua"] longValue];
    //Register FCT class
    tolua_DataLogger_open(lua);
    //Register FCT variant
    int fixtureid = [[dic objectForKey:@"id"] intValue];
    switch (fixtureid) {
        case 0:
            tolua_DataLogger1_open(lua);
            break;
        case 1:
            tolua_DataLogger2_open(lua);
            break;
        case 2:
            tolua_DataLogger3_open(lua);
            break;
        case 3:
            tolua_DataLogger4_open(lua);
            break;
        case 4:
            tolua_DataLogger5_open(lua);
            break;
        case 5:
            tolua_DataLogger6_open(lua);
            break;
        default:
            break;
    }
    
    //Register Script
    NSBundle * bundle = [NSBundle bundleForClass:[self class]];
    NSString * str = [NSString stringWithFormat:@"package.path = package.path..';'..'%@'..'/?.lua'",[bundle resourcePath]];
    pTestEngine = [dic objectForKey:@"TestEngine"];
    [pTestEngine RegisterString:[str UTF8String]];
    [pTestEngine RegisterString:"dl = require \"Logger\""];
    return 0;
}
@end
