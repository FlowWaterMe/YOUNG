//
//  UserInterface.m
//  UI
//
//  Created by Hogan on 17/8/10.
//  Copyright © 2017年 com.Young. All rights reserved.
//



#include <iostream>
#include "UserInterface.h"


CUserInterface::CUserInterface()
{
}

CUserInterface::CUserInterface(uiMainWndDelegate * wnd)
{
    m_pMainWnd=wnd;
}

CUserInterface::~CUserInterface()
{
    m_pMainWnd = nil;
}

#if 0
int CUserInterface::ShowTestStart(int mid)
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:mid],@"id", nil];
    [m_pMainWnd performSelectorOnMainThread:@selector(OnTestStart:) withObject:dic waitUntilDone:YES];
    return 0;
}

int CUserInterface::ShowTestPause(int mid)
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:mid],@"id", nil];
    [m_pMainWnd performSelectorOnMainThread:@selector(OnTestPasue:) withObject:dic waitUntilDone:YES];
    return 0;
}

int CUserInterface::ShowTestStop(int mid)
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:mid],@"id", nil];
    [m_pMainWnd performSelectorOnMainThread:@selector(OnTestStop:) withObject:dic waitUntilDone:YES];
    return 0;
}

int CUserInterface::ShowItemStart(int index,int mid)
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:index] forKey:@"index"];
    [dic setValue:[NSNumber numberWithInt:mid] forKey:@"id"];
    [m_pMainWnd performSelectorOnMainThread:@selector(OnTestItemStart:) withObject:dic waitUntilDone:YES];
    return 0;
}

int CUserInterface::ShowItemFinish(int index, char *value, int states, char *remark,int mid)
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:index] forKey:@"index"];
    [dic setValue:[NSNumber numberWithInt:mid] forKey:@"id"];
    if (remark) {
        [dic setValue:[NSString stringWithUTF8String:remark] forKey:@"remark"];
    }
    else
    {
        [dic setValue:@"" forKey:@"remark"];
    }
    
    NSString * strValue = [NSString stringWithUTF8String:value];
    [dic setValue:strValue forKey:@"value"];
    [dic setValue:[NSNumber numberWithBool:states] forKey:@"state"];
    
    [m_pMainWnd performSelectorOnMainThread:@selector(OnTestItemFinish:) withObject:dic waitUntilDone:YES];
    return 0;
}

int CUserInterface::ShowTestFinish(int states,int mid)
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:states],@"states",[NSNumber numberWithInt:mid],@"id",nil];
    [m_pMainWnd performSelectorOnMainThread:@selector(OnTestFinish:) withObject:dic waitUntilDone:YES];
    return 0;
}

int CUserInterface::ShowTestError(int mid,const char * msg)
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:mid],@"id",[NSString stringWithUTF8String:msg],@"msg",nil];
    [m_pMainWnd performSelectorOnMainThread:@selector(OnTestError:) withObject:dic waitUntilDone:YES];
    return 0;
}
#else
#include "/Users/mac/Documents/程序/YOUNG/HYTestManager/HYTestManager/Common.h"
int CUserInterface::ShowTestStart(int mid)
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:mid],@"id", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOnTestStart object:nil userInfo:dic];
    return 0;
}

int CUserInterface::ShowTestPause(int mid)
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:mid],@"id", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOnTestPause object:nil userInfo:dic];
    return 0;
}

int CUserInterface::ShowTestStop(int mid)
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:mid],@"id", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOnTestStop object:nil userInfo:dic];
    return 0;
}

int CUserInterface::ShowItemStart(int index,int mid)
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:index] forKey:@"index"];
    [dic setValue:[NSNumber numberWithInt:mid] forKey:@"id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOnTestItemStart object:nil userInfo:dic];
    return 0;
}

int CUserInterface::ShowItemFinish(int index, char *value, int states, char *remark,int mid)
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:index] forKey:@"index"];
    [dic setValue:[NSNumber numberWithInt:mid] forKey:@"id"];
    if (remark) {
        [dic setValue:[NSString stringWithUTF8String:remark] forKey:@"remark"];
    }
    else
    {
        [dic setValue:@"" forKey:@"remark"];
    }
    
    NSString * strValue = [NSString stringWithUTF8String:value];
    [dic setValue:strValue forKey:@"value"];
    [dic setValue:[NSNumber numberWithInt:states] forKey:@"state"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOnTestItemFinish object:nil userInfo:dic];
    return 0;
}

int CUserInterface::ShowTestFinish(int states,int mid)
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:states],@"states",[NSNumber numberWithInt:mid],@"id",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOnTestFinish object:nil userInfo:dic];
    return 0;
}

int CUserInterface::ShowTestError(int mid,const char * msg)
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:mid],@"id",[NSString stringWithUTF8String:msg],@"msg",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOnTestError object:nil userInfo:dic];
    return 0;
}

int CUserInterface::UiCtrl(const char *cmd, const char *buf,int index)
{
    NSString * strCmd=@"";
    if (buf)
    {
        strCmd = [NSString stringWithFormat:@"%s",cmd];
    }
    
    NSString * strBuffer=@"";
    if (buf)
    {
        strBuffer = [NSString stringWithFormat:@"%s",buf];
    }
    
    NSString * strIndex = [NSString stringWithFormat:@"%d",index];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:strIndex,@"id",strCmd,@"cmd",strBuffer,@"buf",nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDoUiCtrl object:nil userInfo:dic];
    return 0;
}
#endif

