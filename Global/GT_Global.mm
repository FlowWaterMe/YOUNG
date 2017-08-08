//
//  Global_Variant.m
//  Global
//
//  Created by Hogan on 17/8/7.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import "GT_Global.h"
#include <lua.hpp>
#include <tolua++.h>
#include "Global_Variant.h"
#include "/Users/mac/Documents/程序/YOUNG/CoreLib/TestContext.h"
@implementation GT_Global
TestEngine  * pTestEngine = nil;
void Global_Init();
void Global_Release();
-(id)init{
    self = [self init];
    if (self)
    {
        Global_Init();
    }
    return self;
}

-(void)dealloc
{
    Global_Release();
    [self dealloc];
}

-(NSString * )IP_GetInfo:(IP_UUTHandle)ipHandle item:(IP_ENUM_GHSTATIONINFO)ipItem
{
    size_t sLength=0;
    IP_API_Reply reply = IP_getGHStationInfo(ipHandle, ipItem, NULL, &sLength);
    if(!IP_success(reply))
    {
        NSLog(@"Error from First call IP_getGHStationInfo(): ");
    }
    IP_reply_destroy(reply);
    
    char *cpValue = new char[sLength+1];
    
    reply = IP_getGHStationInfo(ipHandle, ipItem, &cpValue, &sLength);
    if(!IP_success(reply))
        NSLog(@"Error from second call IP_getGHStationInfo(): ");
    IP_reply_destroy(reply);
    NSString * ipInfo = [NSString stringWithUTF8String:cpValue];
    delete cpValue;
    return ipInfo;
}


-(void)getCBAuthConfig
{
    NSMutableString* strCBAuthStationNameToCheck = [[NSMutableString alloc] initWithString:@""];
    NSMutableString* strCBAuthNumberToCheck = [[NSMutableString alloc] initWithString:@""];
    NSString* strCBAuthMaxFailForStation = nil;
    NSMutableString* strCBAuthToClearOnPass = [[NSMutableString alloc] initWithString:@""];
    NSMutableString* strCBAuthToClearOnFail = [[NSMutableString alloc] initWithString:@""];
    NSString* strCBAuthStationSetControlBit = nil;
    
    CBAuth* cbAuth = [[CBAuth alloc] init];
    
    NSDictionary* dicNameAndNumberToCheck = [cbAuth getControlBitsToCheck];
    NSArray* arrCBAuthStationName = [dicNameAndNumberToCheck allKeys];
    for (int i=0; i<[arrCBAuthStationName count]; i++)
    {
        [strCBAuthStationNameToCheck appendFormat:@"%@;", [arrCBAuthStationName objectAtIndex:i]];
        NSNumber* num = [dicNameAndNumberToCheck objectForKey:[arrCBAuthStationName objectAtIndex:i]];
        [strCBAuthNumberToCheck appendFormat:@"0x%02x;", [num intValue]];
    }
    strCBAuthMaxFailForStation = [NSString stringWithFormat:@"%d",[cbAuth getControlBitsMaxFailForStation]];
    
    NSArray* arr1 = [cbAuth getControlBitsToClearOnPass];
    for (int i=0; i<[arr1 count]; i++)
    {
        [strCBAuthToClearOnPass appendFormat:@"0x%02x;", [[arr1 objectAtIndex:i] intValue]];
    }
    
    NSArray* arr2 = [cbAuth getControlBitsToClearOnFail];
    for (int i=0; i<[arr2 count]; i++)
    {
        [strCBAuthToClearOnFail appendFormat:@"0x%02x;", [[arr2 objectAtIndex:i] intValue]];
    }
    
    if ([cbAuth getStationSetControlBit]) {
        strCBAuthStationSetControlBit = @"YES";
    }else
    {
        strCBAuthStationSetControlBit = @"NO";
    }
    
    [CTestContext::m_dicGlobal setValue:strCBAuthStationNameToCheck forKey:kContextCBAuthStationNameToCheck];
    [CTestContext::m_dicGlobal setValue:strCBAuthNumberToCheck forKey:kContextCBAuthNumberToCheck];
    [CTestContext::m_dicGlobal setValue:strCBAuthMaxFailForStation forKey:kContextCBAuthMaxFailForStation];
    [CTestContext::m_dicGlobal setValue:strCBAuthToClearOnPass forKey:kContextCBAuthToClearOnPass];
    [CTestContext::m_dicGlobal setValue:strCBAuthToClearOnFail forKey:kContextCBAuthToClearOnFail];
    [CTestContext::m_dicGlobal setValue:strCBAuthStationSetControlBit forKey:kContextCBAuthStationSetControlBit];
    
    [cbAuth release];
    [strCBAuthStationNameToCheck release];
    [strCBAuthNumberToCheck release];
    [strCBAuthToClearOnPass release];
    [strCBAuthToClearOnFail release];
}

-(void)IntialStation
{
    
    //station information
    IP_UUTHandle ipHandle;
    IP_reply_destroy(IP_UUTStart(&ipHandle));
    NSString * ipInfo;
    NSString * ipInfo2 ;
    
    ipInfo = [self IP_GetInfo:ipHandle item:IP_PRODUCT];
    ipInfo2 = [self IP_GetInfo:ipHandle item:IP_STATION_TYPE];
    [CTestContext::m_dicGlobal setValue:[NSString stringWithFormat:@"%@ %@",ipInfo, ipInfo2] forKey:kContextStationName];
    NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",ipInfo, ipInfo2]);
    
    ipInfo = [self IP_GetInfo:ipHandle item:IP_STATION_ID];
    [CTestContext::m_dicGlobal setValue:ipInfo forKey:kContextStationID];
    
    ipInfo = [self IP_GetInfo:ipHandle item:IP_LINE_NUMBER];
    [CTestContext::m_dicGlobal setValue:ipInfo forKey:kContextLineNumber];
    ipInfo2 = [self IP_GetInfo:ipHandle item:IP_STATION_NUMBER];
    [CTestContext::m_dicGlobal setValue:ipInfo2 forKey:kContextStationNumber];
    [CTestContext::m_dicGlobal setValue:[NSString stringWithFormat:@"%@_%@",ipInfo, ipInfo2] forKey:kContextLineName];
    
    ipInfo = [self IP_GetInfo:ipHandle item:IP_STATION_TYPE];
    [CTestContext::m_dicGlobal setValue:ipInfo forKey:kContextStationType];
    
    ipInfo = [self IP_GetInfo:ipHandle item:IP_PDCA_IP];
    [CTestContext::m_dicGlobal setValue:ipInfo forKey:kContextPdcaServer];
    
    ipInfo = [self IP_GetInfo:ipHandle item:IP_SFC_IP];
    [CTestContext::m_dicGlobal setValue:ipInfo forKey:kContextSfcServer];
    
    ipInfo = [self IP_GetInfo:ipHandle item:IP_SFC_URL];
    [CTestContext::m_dicGlobal setValue:ipInfo forKey:kContextSfcURL];
    NSLog(@"%@",ipInfo);
    
    IP_reply_destroy(IP_UUTCancel(ipHandle));
    
    [CTestContext::m_dicGlobal setValue:@"/vault/Intelli_Log" forKey:kContextVaultPath];
    [CTestContext::m_dicGlobal setValue:@"csv_log" forKey:kContextCsvPath];
    [CTestContext::m_dicGlobal setValue:@"uart_log" forKey:kContextUartPath];
    [CTestContext::m_dicGlobal setValue:@"testflow_log" forKey:kContextTestFlow];
    
    //App dir
    NSString * str = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [CTestContext::m_dicGlobal setValue:str forKey:kContextAppDir];
    
    //TM Version
    id ver = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [CTestContext::m_dicGlobal setValue:[ver description] forKey:kContextTMVersion];
    
    //
    CTestContext * pTestContext[] = {TestContext0,TestContext1,TestContext2,TestContext3,TestContext4,TestContext5};
    /*
     -----------------------------------------------------------------------
     author:ZL Meng
     Date:Jul.17 2015
     Description:
     修改测试线程数从6个改成1个
     -----------------------------------------------------------------------
     */
    for (int i=0; i<=UUT_MODULE-1; i++) {
        NSDictionary * dic = pTestContext[i]->m_dicContext;
        [dic setValue:[NSNumber numberWithInt:i] forKey:kContextID];
        //        [dic setValue:[NSString stringWithFormat:@"0x%08x",0xFA121000+0x1000*i] forKey:kContextUsbLocation];
        [dic setValue:[NSNumber numberWithInt:0] forKey:kContextStartTime];
        [dic setValue:[NSNumber numberWithInt:0] forKey:kContextStopTime];
        [dic setValue:[NSNumber numberWithInt:0] forKey:kContextTotalTime];
        [dic setValue:@"" forKey:kContextMLBSN];
        [dic setValue:@"" forKey:kContextCFG];
    }
    [self getCBAuthConfig];
}

-(int)Load:(id)sender
{
    
    return 0;
}

-(int)Unload:(id)sender
{
    return 0;
}

-(int)SelfTest:(id)sender
{
    return 0;
}
TOLUA_API int  tolua_Global_Function_open (lua_State* tolua_S);
TOLUA_API int  tolua_Global_Variant1_open (lua_State* tolua_S);
TOLUA_API int  tolua_Global_Variant2_open (lua_State* tolua_S);
TOLUA_API int  tolua_Global_Variant3_open (lua_State* tolua_S);
TOLUA_API int  tolua_Global_Variant4_open (lua_State* tolua_S);
TOLUA_API int  tolua_Global_Variant5_open (lua_State* tolua_S);
TOLUA_API int  tolua_Global_Variant6_open (lua_State* tolua_S);
-(int)RegisterModule:(id)sender
{
    NSDictionary * dic = (NSDictionary *)sender;
    lua_State * lua = (lua_State *)[[dic objectForKey:@"lua"]longValue];
    tolua_Global_Function_open(lua);
    pTestEngine = [dic objectForKey:@"TestEngine"];
    int fixtureid = [[dic objectForKey:@"id"] intValue];
    switch (fixtureid) {
        case 0:
            TestContext0 = (CTestContext *)[pTestEngine GetTestContext:0];
            tolua_Global_Variant1_open(lua);
            break;
        case 1:
            TestContext1 = (CTestContext *)[pTestEngine GetTestContext:1];
            tolua_Global_Variant2_open(lua);
            break;
        case 2:
            TestContext2 = (CTestContext *)[pTestEngine GetTestContext:2];
            tolua_Global_Variant3_open(lua);
            break;
        case 3:
            TestContext3 = (CTestContext *)[pTestEngine GetTestContext:3];
            tolua_Global_Variant4_open(lua);
            break;
        case 4:
            TestContext4 = (CTestContext *)[pTestEngine GetTestContext:4];
            tolua_Global_Variant5_open(lua);
            break;
        case 5:
            TestContext5 = (CTestContext *)[pTestEngine GetTestContext:5];
            tolua_Global_Variant6_open(lua);
            break;
        default:
            break;
    }
// register script
    
    NSBundle * bundle = [NSBundle bundleForClass:[self class];
    NSString * str = [NSString stringWithFormat:@"package.path = package.path..';'..'%@'..'/?.lua'",[bundle resourcePath]];
    [pTestEngine RegisterString:[str UTF8String]];
    [pTestEngine RegisterString:"tc = require \"Context\""];
    if(fixtureid == 0)
    {
        NSString * strscript = [bundle pathForResource:@"Context" ofType:@"lua"];
        ListLuaFile([strscript UTF8String],"tc");
        NSString * strTag = [NSString stringWithContentsOfFile:[bundle pathForResource:@"tags" ofType:@""] encoding:NSASCIIStringEncoding error:nil];
//        AddTags([NSDictionary dictionaryWithObjectsAndKeys:strTag,@kTagValue,nil]);
    }
    return 0;
}
@end

