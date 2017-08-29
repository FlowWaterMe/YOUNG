/*
** Lua binding: CTemGlobal
** Generated automatically by tolua++-1.0.92 on Fri Aug 25 20:59:05 2017.
*/

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"

/* Exported function */
TOLUA_API int  tolua_CTemGlobal_open (lua_State* tolua_S);

#include "CTemGlobal.h"

/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"CTem");
}

/* get function: temobj */
#ifndef TOLUA_DISABLE_tolua_get_temobj_ptr
static int tolua_get_temobj_ptr(lua_State* tolua_S)
{
   tolua_pushusertype(tolua_S,(void*)temobj,"CTem");
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: temobj */
#ifndef TOLUA_DISABLE_tolua_set_temobj_ptr
static int tolua_set_temobj_ptr(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!tolua_isusertype(tolua_S,2,"CTem",0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  temobj = ((CTem*)  tolua_tousertype(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_CTemGlobal_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,1);
 tolua_beginmodule(tolua_S,NULL);
  tolua_variable(tolua_S,"temobj",tolua_get_temobj_ptr,tolua_set_temobj_ptr);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_CTemGlobal (lua_State* tolua_S) {
 return tolua_CTemGlobal_open(tolua_S);
};
#endif

