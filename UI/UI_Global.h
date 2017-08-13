//
//  UI_Global.h
//  UI
//
//  Created by Hogan on 17/8/10.
//  Copyright © 2017年 com.Young. All rights reserved.
//
#ifndef UI_UI_Global_H
#define UI_UI_Global_H
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "UserInterface.h"
#include "/Users/mac/Documents/程序/YOUNG/CoreLib/TestContext.h"
extern CUserInterface * UI;
typedef enum __DEBUG_ACTION {
    DEBUG_SKIP = -1,        //Skip current item
    DEBUG_DISABLE,
    DEBUG_STEP,
    DEBUG_RUN,
    DEBUG_RETEST,
    DEBUG_ABORT,
}DEBUG_STATUS;

extern DEBUG_STATUS DEBUG_CMD;
// 脚本导出全局变量及函数头文件
int pause();
int resume();
int CheckBreakPoints(char * index);

//TestContext
extern CTestContext * pTestContext0;
extern CTestContext * pTestContext1;
extern CTestContext * pTestContext2;
extern CTestContext * pTestContext3;
extern CTestContext * pTestContext4;
extern CTestContext * pTestContext5;


#endif