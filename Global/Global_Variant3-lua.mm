/*
** Lua binding: Global_Variant3
** Generated automatically by tolua++-1.0.92 on Tue Aug  8 21:03:28 2017.
*/

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"

/* Exported function */
TOLUA_API int  tolua_Global_Variant3_open (lua_State* tolua_S);

#include "Global_Variant.h"

/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"CTestContext");
}

/* get function: TestContext2 */
#ifndef TOLUA_DISABLE_tolua_get_TestContext_ptr
static int tolua_get_TestContext_ptr(lua_State* tolua_S)
{
   tolua_pushusertype(tolua_S,(void*)TestContext2,"CTestContext");
 return 1;
}
#endif //#ifndef TOLUA_DISABLE

/* set function: TestContext2 */
#ifndef TOLUA_DISABLE_tolua_set_TestContext_ptr
static int tolua_set_TestContext_ptr(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
  tolua_Error tolua_err;
  if (!tolua_isusertype(tolua_S,2,"CTestContext",0,&tolua_err))
   tolua_error(tolua_S,"#vinvalid type in variable assignment.",&tolua_err);
#endif
  TestContext2 = ((CTestContext*)  tolua_tousertype(tolua_S,2,0))
;
 return 0;
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_Global_Variant3_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,1);
 tolua_beginmodule(tolua_S,NULL);
  tolua_variable(tolua_S,"TestContext",tolua_get_TestContext_ptr,tolua_set_TestContext_ptr);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_Global_Variant3 (lua_State* tolua_S) {
 return tolua_Global_Variant3_open(tolua_S);
};
#endif

