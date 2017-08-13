//
//  UserInterface.h
//  UI
//
//  Created by Hogan on 17/8/10.
//  Copyright © 2017年 com.Young. All rights reserved.
//
#ifndef UI_UserInterface_h
#define UI_UserInterface_h

#import <Foundation/Foundation.h>
#include "uiMainWndDelegate.h"

class CUserInterface
{
public:
    CUserInterface();
    CUserInterface(uiMainWndDelegate * wnd);
    ~CUserInterface();
    
public:
    virtual int ShowTestError(int mid=0,const char * msg=NULL);
    virtual int ShowTestStart(int mid=0);
    virtual int ShowTestPause(int mid=0);
    virtual int ShowItemStart(int index,int mid=0);
    virtual int ShowItemFinish(int index,char * value,int states,char * remark,int mid=0);
    virtual int ShowTestStop(int mid=0);
    virtual int ShowTestFinish(int states,int mid=0);
    virtual int UiCtrl(const char *cmd, const char *buf,int index=0);
protected:
    uiMainWndDelegate * m_pMainWnd;
};

#endif