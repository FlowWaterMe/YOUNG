//
//  GT_Engine.h
//  Engine
//
//  Created by Hogan on 17/8/3.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TestEngine.h"
//#include "//Users/mac/Documents/程序/YOUNG/HYTestManager/ScriptEngine.h"

#define UUT_MODULE  1

@interface GT_Engine : TestEngine{
@private
//    CScriptEngine * m_ScriptEngine[UUT_MODULE];     //Script Engine
//    CTestContext * m_pTestContext[UUT_MODULE];      //Test Context,will export into script in global bundle
    NSThread * threadUintTest[UUT_MODULE];
    NSThread * m_threadManager;
    NSLock * engineLock;
    NSMutableDictionary * dicModuleConfig;
    
    int m_ModuleFinish;
    int m_ModuleTesting;
}
@end

