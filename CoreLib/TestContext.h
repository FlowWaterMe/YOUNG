//
//  TestContext.h
//  CoreLib
//
//  Created by Hogan on 17/8/7.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef CoreLib_TestContext_h
#define CoreLib_TestContext_h
class CTestContext
{
public:
    CTestContext();
    ~CTestContext();
public:
    const char* getContext(char *szKey,int index = 0)const;
public:
    static NSMutableDictionary * m_dicGlobal;
    static NSMutableDictionary * m_dicConfiguration;
    NSMutableDictionary * m_dicContext;
};
#endif

