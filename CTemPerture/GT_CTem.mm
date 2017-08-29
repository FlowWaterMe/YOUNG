//
//  GT_CTem.m
//  CTemPerture
//
//  Created by Hogan on 17/8/24.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import "GT_CTem.h"

TestEngine *pTestEngine = nil ;

TOLUA_API int  tolua_CTem_open (lua_State* tolua_S);
TOLUA_API int  tolua_CTemGlobal_open (lua_State* tolua_S);

@implementation GT_CTem
-(id)init
{
    self = [super init] ;
    if(self)
    {
        
    }
    return self ;
}

- (void)dealloc
{
    [super dealloc];
}


#pragma mark-DriverModule interface
-(NSString *)ModuleName           //模块名称说明
{
    return @"GT CTem" ;
}

-(int)RegisterModule:(id)sender
{
    
    int err;
    NSMutableDictionary * dic = (NSMutableDictionary *)sender;
    lua_State * lua = (lua_State *)[[dic objectForKey:@"lua"] longValue];
    //Register FCT class
    tolua_CTem_open(lua);
    tolua_CTemGlobal_open(lua);
//    tolua_CTemGlobal_open(lua);
//
//    //Register Script
    NSBundle * bundle = [NSBundle bundleForClass:[self class]];
//   // NSLog(@"......%@",[bundle resourcePath]) ;
    NSString * str = [NSString stringWithFormat:@"package.path = package.path..';'..'%@'..'/?.lua'",[bundle resourcePath]];
    pTestEngine = [dic objectForKey:@"TestEngine"];
    int fixId = [[dic objectForKey:@"id"] intValue];
//
    CScriptEngine * se = (CScriptEngine *)[pTestEngine GetScripEngine:fixId];
    err = se->DoString([str UTF8String]);
    err = se->DoString("ctem = require \"ctemp\"");
//
    if (err)
    {
//        NSRunAlertPanel(@"Load Error", @"%s", @"OK", nil, nil,lua_tostring(se->m_pLuaState, -1));
    }
//
//    if (fixId==0)
//    {
////        NSString * strscript = [[NSBundle bundleForClass:[self class]] pathForResource:@"ctemp" ofType:@"lua"];
////        ListLuaFile([strscript UTF8String],"ctemp");
//    }
    return 0;
}


-(int)SelfTest:(id)sender          //模块自我测试
{
    return 0 ;
}

-(int)Load:(id)sender
{
    if ([NSBundle loadNibNamed:@"CTemWindow" owner:self]==FALSE)
        return -1 ;
    
    return 0 ;
}

-(int)Unload:(id)sender
{
    return 0 ;
}

@end


