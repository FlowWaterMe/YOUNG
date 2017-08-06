//
//  ScriptEngine.h
//  CoreLib
//
//  Created by Hogan on 17/8/6.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#pragma once
#import <lua.hpp>

class CScriptEngine {
public:
    CScriptEngine();
    virtual ~CScriptEngine();
    
public:
    virtual int Init();
    int LoadString(char * szText);
    int LoadFile(const char * szFile);
    int DoString(const char * szText);
    int DoFile(const char * szFile);
    void Reslease();
    lua_State * GetLuaState() const;
protected:
    virtual void RegisterAll();
public:
    lua_State * m_pLuaState;
};
