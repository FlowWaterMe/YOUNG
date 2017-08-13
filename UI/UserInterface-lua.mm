/*
** Lua binding: UserInterface
** Generated automatically by tolua++-1.0.92 on Sun Aug 13 18:24:07 2017.
*/

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"

/* Exported function */
TOLUA_API int  tolua_UserInterface_open (lua_State* tolua_S);

#import "UserInterface.h"

/* function to release collected object via destructor */
#ifdef __cplusplus

static int tolua_collect_CUserInterface (lua_State* tolua_S)
{
 CUserInterface* self = (CUserInterface*) tolua_tousertype(tolua_S,1,0);
	Mtolua_delete(self);
	return 0;
}
#endif


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"CUserInterface");
 tolua_usertype(tolua_S,"uiMainWndDelegate");
}

/* method: new of class  CUserInterface */
#ifndef TOLUA_DISABLE_tolua_UserInterface_CUserInterface_new00
static int tolua_UserInterface_CUserInterface_new00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CUserInterface",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   CUserInterface* tolua_ret = (CUserInterface*)  Mtolua_new((CUserInterface)());
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CUserInterface");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'new'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: new_local of class  CUserInterface */
#ifndef TOLUA_DISABLE_tolua_UserInterface_CUserInterface_new00_local
static int tolua_UserInterface_CUserInterface_new00_local(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CUserInterface",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   CUserInterface* tolua_ret = (CUserInterface*)  Mtolua_new((CUserInterface)());
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CUserInterface");
    tolua_register_gc(tolua_S,lua_gettop(tolua_S));
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'new'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: new of class  CUserInterface */
#ifndef TOLUA_DISABLE_tolua_UserInterface_CUserInterface_new01
static int tolua_UserInterface_CUserInterface_new01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CUserInterface",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"uiMainWndDelegate",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  uiMainWndDelegate* wnd = ((uiMainWndDelegate*)  tolua_tousertype(tolua_S,2,0));
  {
   CUserInterface* tolua_ret = (CUserInterface*)  Mtolua_new((CUserInterface)(wnd));
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CUserInterface");
  }
 }
 return 1;
tolua_lerror:
 return tolua_UserInterface_CUserInterface_new00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: new_local of class  CUserInterface */
#ifndef TOLUA_DISABLE_tolua_UserInterface_CUserInterface_new01_local
static int tolua_UserInterface_CUserInterface_new01_local(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CUserInterface",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"uiMainWndDelegate",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  uiMainWndDelegate* wnd = ((uiMainWndDelegate*)  tolua_tousertype(tolua_S,2,0));
  {
   CUserInterface* tolua_ret = (CUserInterface*)  Mtolua_new((CUserInterface)(wnd));
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CUserInterface");
    tolua_register_gc(tolua_S,lua_gettop(tolua_S));
  }
 }
 return 1;
tolua_lerror:
 return tolua_UserInterface_CUserInterface_new00_local(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: delete of class  CUserInterface */
#ifndef TOLUA_DISABLE_tolua_UserInterface_CUserInterface_delete00
static int tolua_UserInterface_CUserInterface_delete00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CUserInterface",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CUserInterface* self = (CUserInterface*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'delete'", NULL);
#endif
  Mtolua_delete(self);
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'delete'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: ShowTestError of class  CUserInterface */
#ifndef TOLUA_DISABLE_tolua_UserInterface_CUserInterface_ShowTestError00
static int tolua_UserInterface_CUserInterface_ShowTestError00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CUserInterface",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,1,&tolua_err) ||
     !tolua_isstring(tolua_S,3,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CUserInterface* self = (CUserInterface*)  tolua_tousertype(tolua_S,1,0);
  int mid = ((int)  tolua_tonumber(tolua_S,2,0));
  const char* msg = ((const char*)  tolua_tostring(tolua_S,3,NULL));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'ShowTestError'", NULL);
#endif
  {
   int tolua_ret = (int)  self->ShowTestError(mid,msg);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'ShowTestError'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: ShowTestStart of class  CUserInterface */
#ifndef TOLUA_DISABLE_tolua_UserInterface_CUserInterface_ShowTestStart00
static int tolua_UserInterface_CUserInterface_ShowTestStart00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CUserInterface",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CUserInterface* self = (CUserInterface*)  tolua_tousertype(tolua_S,1,0);
  int mid = ((int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'ShowTestStart'", NULL);
#endif
  {
   int tolua_ret = (int)  self->ShowTestStart(mid);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'ShowTestStart'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: ShowTestPause of class  CUserInterface */
#ifndef TOLUA_DISABLE_tolua_UserInterface_CUserInterface_ShowTestPause00
static int tolua_UserInterface_CUserInterface_ShowTestPause00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CUserInterface",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CUserInterface* self = (CUserInterface*)  tolua_tousertype(tolua_S,1,0);
  int mid = ((int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'ShowTestPause'", NULL);
#endif
  {
   int tolua_ret = (int)  self->ShowTestPause(mid);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'ShowTestPause'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: ShowItemStart of class  CUserInterface */
#ifndef TOLUA_DISABLE_tolua_UserInterface_CUserInterface_ShowItemStart00
static int tolua_UserInterface_CUserInterface_ShowItemStart00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CUserInterface",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CUserInterface* self = (CUserInterface*)  tolua_tousertype(tolua_S,1,0);
  int index = ((int)  tolua_tonumber(tolua_S,2,0));
  int mid = ((int)  tolua_tonumber(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'ShowItemStart'", NULL);
#endif
  {
   int tolua_ret = (int)  self->ShowItemStart(index,mid);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'ShowItemStart'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: ShowItemFinish of class  CUserInterface */
#ifndef TOLUA_DISABLE_tolua_UserInterface_CUserInterface_ShowItemFinish00
static int tolua_UserInterface_CUserInterface_ShowItemFinish00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CUserInterface",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isstring(tolua_S,5,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,6,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,7,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CUserInterface* self = (CUserInterface*)  tolua_tousertype(tolua_S,1,0);
  int index = ((int)  tolua_tonumber(tolua_S,2,0));
  char* value = ((char*)  tolua_tostring(tolua_S,3,0));
  int states = ((int)  tolua_tonumber(tolua_S,4,0));
  char* remark = ((char*)  tolua_tostring(tolua_S,5,0));
  int mid = ((int)  tolua_tonumber(tolua_S,6,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'ShowItemFinish'", NULL);
#endif
  {
   int tolua_ret = (int)  self->ShowItemFinish(index,value,states,remark,mid);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'ShowItemFinish'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: ShowTestStop of class  CUserInterface */
#ifndef TOLUA_DISABLE_tolua_UserInterface_CUserInterface_ShowTestStop00
static int tolua_UserInterface_CUserInterface_ShowTestStop00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CUserInterface",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CUserInterface* self = (CUserInterface*)  tolua_tousertype(tolua_S,1,0);
  int mid = ((int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'ShowTestStop'", NULL);
#endif
  {
   int tolua_ret = (int)  self->ShowTestStop(mid);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'ShowTestStop'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: ShowTestFinish of class  CUserInterface */
#ifndef TOLUA_DISABLE_tolua_UserInterface_CUserInterface_ShowTestFinish00
static int tolua_UserInterface_CUserInterface_ShowTestFinish00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CUserInterface",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CUserInterface* self = (CUserInterface*)  tolua_tousertype(tolua_S,1,0);
  int states = ((int)  tolua_tonumber(tolua_S,2,0));
  int mid = ((int)  tolua_tonumber(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'ShowTestFinish'", NULL);
#endif
  {
   int tolua_ret = (int)  self->ShowTestFinish(states,mid);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'ShowTestFinish'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: UiCtrl of class  CUserInterface */
#ifndef TOLUA_DISABLE_tolua_UserInterface_CUserInterface_UiCtrl00
static int tolua_UserInterface_CUserInterface_UiCtrl00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CUserInterface",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CUserInterface* self = (CUserInterface*)  tolua_tousertype(tolua_S,1,0);
  const char* cmd = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* buf = ((const char*)  tolua_tostring(tolua_S,3,0));
  int index = ((int)  tolua_tonumber(tolua_S,4,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'UiCtrl'", NULL);
#endif
  {
   int tolua_ret = (int)  self->UiCtrl(cmd,buf,index);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UiCtrl'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_UserInterface_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  #ifdef __cplusplus
  tolua_cclass(tolua_S,"CUserInterface","CUserInterface","",tolua_collect_CUserInterface);
  #else
  tolua_cclass(tolua_S,"CUserInterface","CUserInterface","",NULL);
  #endif
  tolua_beginmodule(tolua_S,"CUserInterface");
   tolua_function(tolua_S,"new",tolua_UserInterface_CUserInterface_new00);
   tolua_function(tolua_S,"new_local",tolua_UserInterface_CUserInterface_new00_local);
   tolua_function(tolua_S,".call",tolua_UserInterface_CUserInterface_new00_local);
   tolua_function(tolua_S,"new",tolua_UserInterface_CUserInterface_new01);
   tolua_function(tolua_S,"new_local",tolua_UserInterface_CUserInterface_new01_local);
   tolua_function(tolua_S,".call",tolua_UserInterface_CUserInterface_new01_local);
   tolua_function(tolua_S,"delete",tolua_UserInterface_CUserInterface_delete00);
   tolua_function(tolua_S,"ShowTestError",tolua_UserInterface_CUserInterface_ShowTestError00);
   tolua_function(tolua_S,"ShowTestStart",tolua_UserInterface_CUserInterface_ShowTestStart00);
   tolua_function(tolua_S,"ShowTestPause",tolua_UserInterface_CUserInterface_ShowTestPause00);
   tolua_function(tolua_S,"ShowItemStart",tolua_UserInterface_CUserInterface_ShowItemStart00);
   tolua_function(tolua_S,"ShowItemFinish",tolua_UserInterface_CUserInterface_ShowItemFinish00);
   tolua_function(tolua_S,"ShowTestStop",tolua_UserInterface_CUserInterface_ShowTestStop00);
   tolua_function(tolua_S,"ShowTestFinish",tolua_UserInterface_CUserInterface_ShowTestFinish00);
   tolua_function(tolua_S,"UiCtrl",tolua_UserInterface_CUserInterface_UiCtrl00);
  tolua_endmodule(tolua_S);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_UserInterface (lua_State* tolua_S) {
 return tolua_UserInterface_open(tolua_S);
};
#endif

