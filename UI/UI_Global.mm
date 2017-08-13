//
//  UI_Global.m
//  UI
//
//  Created by Hogan on 17/8/10.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import "UI_Global.h"
#include "uiMainWndDelegate.h"
extern uiMainWndDelegate * mainWnd;
CUserInterface * UI;
CTestContext * pTestContext0;
CTestContext * pTestContext1;
CTestContext * pTestContext2;
CTestContext * pTestContext3;
CTestContext * pTestContext4;
CTestContext * pTestContext5;
DEBUG_STATUS DEBUG_CMD = DEBUG_DISABLE;
int pause()
{
    [mainWnd btPause:nil];
    return 0;
}
int resume()
{
    [mainWnd btResume:nil];
    return 0;
}
int CheckBreakPoints(char * index)
{
    int x = [[mainWnd arrBreakPoints]indexOfObject:[NSString stringWithUTF8String:index]]!=NSNotFound;
    return x;
    
}

//TestContext
//extern CTestContext * pTestContext0;
//extern CTestContext * pTestContext1;
//extern CTestContext * pTestContext2;
//extern CTestContext * pTestContext3;
//extern CTestContext * pTestContext4;
//extern CTestContext * pTestContext5;