//
//  GT_UserInterface.m
//  UI
//
//  Created by Hogan on 17/8/4.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import "GT_UserInterface.h"
#include <lua.hpp>
#include <tolua++.h>
//
#include "UI_Global.h"
//#include "Corelib/TestItem.h"
@implementation GT_UserInterface
#define Config_File @"config.plist"
TestEngine * m_pTestEngine = nil;
NSTreeNode * items = nil;
-(id)init
{
    self = [super init];
    if(self)
    {
        m_dicConfiguration = [NSMutableDictionary new];
    }
    return self;
}

-(void)dealloc
{
    [m_dicConfiguration release];
    [super dealloc];
}

-(NSString *)ModuleName
{
    return @"Tester User Interface.";
}
TOLUA_API int tolua_UI_Global_open (lua_State* tolua_S);
TOLUA_API int  tolua_UserInterface_open (lua_State* tolua_S);

-(int)RegisterModule:(id)sender     //登记模块
{
    NSMutableDictionary * dic = (NSMutableDictionary *)sender;
    [dic setValue:instrMenu forKey:@"menuInstruments"];
    lua_State * lua = (lua_State *)[[dic objectForKey:@"lua"] longValue];
    m_pTestEngine = [dic objectForKey:@"TestEngine"];
    //Get Test Context
    pTestContext0 = (CTestContext *)[m_pTestEngine GetTestContext:0];
    pTestContext1 = (CTestContext *)[m_pTestEngine GetTestContext:1];
    pTestContext2 = (CTestContext *)[m_pTestEngine GetTestContext:2];
    pTestContext3 = (CTestContext *)[m_pTestEngine GetTestContext:3];
    pTestContext4 = (CTestContext *)[m_pTestEngine GetTestContext:4];
    pTestContext5 = (CTestContext *)[m_pTestEngine GetTestContext:5];
  
    
    tolua_UserInterface_open(lua);
    tolua_UI_Global_open(lua);
    
    int fixtureid = 0;//[[dic objectForKey:@"id"] intValue];
    NSBundle * bundle = [NSBundle bundleForClass:[self class]];
    NSString * str = [NSString stringWithFormat:@"package.path = package.path..';'..'%@'..'/?.lua'",[bundle resourcePath]];
//    str = @"/Users/mac/Documents/程序/YOUNG/Build/Products/Debug/ui.bundle/Contents/Resources/ui.lua";	
    CScriptEngine * se = (CScriptEngine *)[m_pTestEngine GetScripEngine:fixtureid];
    int err = se->DoString([str UTF8String]);
    err = se->DoString("ui = require \"ui\"");
    
    return 0;
}
-(int)SelfTest:(id)sender          //模块自我测试
{
    return 0;
}
-(int)Load:(id)sender
{
    [NSBundle loadNibNamed:@"UIV1" owner:self];
//    NSMenu * mainMenu = [NSApp mainMenu];
//    NSMenu * appMenu = [[mainMenu itemAtIndex:0]submenu];
//    [appMenu setTitle:@"HY V1.0"];
    return 0;
}
-(int)Unload:(id)sender
{
    return 0;
}


@end
