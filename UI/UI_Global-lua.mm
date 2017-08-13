/*
** Lua binding: UI_Global
** Generated automatically by tolua++-1.0.92 on Sun Aug 13 18:24:07 2017.
*/

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"

/* Exported function */
TOLUA_API int  tolua_UI_Global_open (lua_State* tolua_S);

#import "UI_Global.h"

/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"CUserInterface");
}

/* get function: UI */
#ifndef TOLUA_DISABLE_tolua_get_UI_ptr
static int tolua_get_UI_ptr(lua_State* tolua_S)
{
   tolua_pushusertype(tolua_S,(void*)UI,"CUserInterface");
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: UI */
#ifndef TOLUA_DISABLE_tolua_set_UI_ptr
static int tolua_set_UI_ptr(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!tolua_isusertype(tolua_S,2,"CUserInterface",0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  UI = ((CUserInterface*)  tolua_tousertype(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* get function: DEBUG_CMD */
#ifndef TOLUA_DISABLE_tolua_get_DEBUG_CMD
static int tolua_get_DEBUG_CMD(lua_State* tolua_S)
{
  tolua_pushnumber(tolua_S,(lua_Number)DEBUG_CMD);
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: DEBUG_CMD */
#ifndef TOLUA_DISABLE_tolua_set_DEBUG_CMD
static int tolua_set_DEBUG_CMD(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!tolua_isnumber(tolua_S,2,0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  DEBUG_CMD = ((DEBUG_STATUS) (int)  tolua_tonumber(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* function: pause */
#ifndef TOLUA_DISABLE_tolua_UI_Global_pause00
static int tolua_UI_Global_pause00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnoobj(tolua_S,1,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   int tolua_ret = (int)  pause();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'pause'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: resume */
#ifndef TOLUA_DISABLE_tolua_UI_Global_resume00
static int tolua_UI_Global_resume00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnoobj(tolua_S,1,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   int tolua_ret = (int)  resume();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'resume'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: CheckBreakPoints */
#ifndef TOLUA_DISABLE_tolua_UI_Global_CheckBreakPoints00
static int tolua_UI_Global_CheckBreakPoints00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isstring(tolua_S,1,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  char* index = ((char*)  tolua_tostring(tolua_S,1,0));
  {
   int tolua_ret = (int)  CheckBreakPoints(index);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'CheckBreakPoints'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_UI_Global_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,1);
 tolua_beginmodule(tolua_S,NULL);
  tolua_variable(tolua_S,"UI",tolua_get_UI_ptr,tolua_set_UI_ptr);
  tolua_constant(tolua_S,"DEBUG_SKIP",DEBUG_SKIP);
  tolua_constant(tolua_S,"DEBUG_DISABLE",DEBUG_DISABLE);
  tolua_constant(tolua_S,"DEBUG_STEP",DEBUG_STEP);
  tolua_constant(tolua_S,"DEBUG_RUN",DEBUG_RUN);
  tolua_constant(tolua_S,"DEBUG_RETEST",DEBUG_RETEST);
  tolua_constant(tolua_S,"DEBUG_ABORT",DEBUG_ABORT);
  tolua_variable(tolua_S,"DEBUG_CMD",tolua_get_DEBUG_CMD,tolua_set_DEBUG_CMD);
  tolua_function(tolua_S,"pause",tolua_UI_Global_pause00);
  tolua_function(tolua_S,"resume",tolua_UI_Global_resume00);
  tolua_function(tolua_S,"CheckBreakPoints",tolua_UI_Global_CheckBreakPoints00);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_UI_Global (lua_State* tolua_S) {
 return tolua_UI_Global_open(tolua_S);
};
#endif

