//
//  ScriptEngine.m
//  CoreLib
//
//  Created by Hogan on 17/8/6.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import "ScriptEngine.h"

#include "/Users/mac/Documents/程序/YOUNG/Foreign/ToLua/tolua++-1.0.93/include/tolua++.h"
//#include "tolua++.h"

#pragma comment(lib,"libtolua++.a")
CScriptEngine::CScriptEngine(void)
{
    //Lua Initial
    m_pLuaState =luaL_newstate();
    luaL_openlibs(m_pLuaState);
    //open(m_pLuaState);
    //RegisterAll();
    tolua_open(m_pLuaState);
}

CScriptEngine::~CScriptEngine(void)
{
    printf("CScriptEngine::~CScriptEngine(void)\r\n");
    lua_close(m_pLuaState);
}

int CScriptEngine::Init()
{
    RegisterAll();
    return 0;
}

int CScriptEngine::LoadFile(const char *szFile)
{
    return luaL_loadfile(m_pLuaState, szFile);
}

int CScriptEngine::DoFile(const char * szFile)
{
    
    return luaL_dofile(m_pLuaState,szFile);
}

int CScriptEngine::DoString(const char * szText)
{
    return luaL_dostring(m_pLuaState,szText);
}
void CScriptEngine::RegisterAll()
{
    
}
lua_State * CScriptEngine::GetLuaState() const
{
    return m_pLuaState;
}

void CScriptEngine::Reslease()
{
}



