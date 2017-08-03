//
//  UserInformation.h
//  HYTestManager
//
//  Created by Hogan on 17/8/3.
//  Copyright © 2017年 com.Young. All rights reserved.
//
#ifndef UI_UserInformation_h
#define UI_UserInformation_h
#import <Foundation/Foundation.h>
#import "Common.h"

class CUserInformation {
public:
    CUserInformation();
    ~CUserInformation();
    
public:
    int AddUser(USER_INFOR u);
    int RemoveUser(const char * szName);
    int LoadFromFile(const char * szpath);
    int SaveToFile(const char * szpath);
    int CheckUser(USER_INFOR u);
    int UpdateUser(USER_INFOR u);
    USER_INFOR * FindUser(const char * szName);
    USER_INFOR * GetCurrentUser();
    NSArray * GetUserList();
protected:
    USER_INFOR * m_pCurrentUser;
    NSMutableArray * m_arrUserList;
};
#endif