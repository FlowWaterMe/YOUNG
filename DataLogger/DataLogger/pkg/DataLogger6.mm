/*
** Lua binding: DataLogger6
** Generated automatically by tolua++-1.0.92 on Tue Jun 10 13:20:30 2014.
*/

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"

/* Exported function */
TOLUA_API int  tolua_DataLogger6_open (lua_State* tolua_S);

#include "DataLogger_Global.h"

/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"CDataLogger");
}

/* get function: DataLogger6 */
#ifndef TOLUA_DISABLE_tolua_get_DataLogger_ptr
static int tolua_get_DataLogger_ptr(lua_State* tolua_S)
{
   tolua_pushusertype(tolua_S,(void*)DataLogger6,"CDataLogger");
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: DataLogger6 */
#ifndef TOLUA_DISABLE_tolua_set_DataLogger_ptr
static int tolua_set_DataLogger_ptr(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!tolua_isusertype(tolua_S,2,"CDataLogger",0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  DataLogger6 = ((CDataLogger*)  tolua_tousertype(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_DataLogger6_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,1);
 tolua_beginmodule(tolua_S,NULL);
  tolua_variable(tolua_S,"DataLogger",tolua_get_DataLogger_ptr,tolua_set_DataLogger_ptr);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_DataLogger6 (lua_State* tolua_S) {
 return tolua_DataLogger6_open(tolua_S);
};
#endif

