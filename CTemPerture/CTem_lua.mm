/*
** Lua binding: CTem
** Generated automatically by tolua++-1.0.92 on Fri Aug 25 20:59:05 2017.
*/

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"

/* Exported function */
TOLUA_API int  tolua_CTem_open (lua_State* tolua_S);

#include "CTem.h"

/* function to release collected object via destructor */
#ifdef __cplusplus

static int tolua_collect_CTem (lua_State* tolua_S)
{
 CTem* self = (CTem*) tolua_tousertype(tolua_S,1,0);
	Mtolua_delete(self);
	return 0;
}
#endif


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"CTem");
}

/* method: new of class  CTem */
#ifndef TOLUA_DISABLE_tolua_CTem_CTem_new00
static int tolua_CTem_CTem_new00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CTem",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   CTem* tolua_ret = (CTem*)  Mtolua_new((CTem)());
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CTem");
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

/* method: new_local of class  CTem */
#ifndef TOLUA_DISABLE_tolua_CTem_CTem_new00_local
static int tolua_CTem_CTem_new00_local(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CTem",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   CTem* tolua_ret = (CTem*)  Mtolua_new((CTem)());
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CTem");
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

/* method: delete of class  CTem */
#ifndef TOLUA_DISABLE_tolua_CTem_CTem_delete00
static int tolua_CTem_CTem_delete00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CTem",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CTem* self = (CTem*)  tolua_tousertype(tolua_S,1,0);
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

/* method: count of class  CTem */
#ifndef TOLUA_DISABLE_tolua_CTem_CTem_count00
static int tolua_CTem_CTem_count00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CTem",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CTem* self = (CTem*)  tolua_tousertype(tolua_S,1,0);
  int mm = ((int)  tolua_tonumber(tolua_S,2,0));
  int nn = ((int)  tolua_tonumber(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'count'", NULL);
#endif
  {
   int tolua_ret = (int)  self->count(mm,nn);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'count'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_CTem_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  #ifdef __cplusplus
  tolua_cclass(tolua_S,"CTem","CTem","",tolua_collect_CTem);
  #else
  tolua_cclass(tolua_S,"CTem","CTem","",NULL);
  #endif
  tolua_beginmodule(tolua_S,"CTem");
   tolua_function(tolua_S,"new",tolua_CTem_CTem_new00);
   tolua_function(tolua_S,"new_local",tolua_CTem_CTem_new00_local);
   tolua_function(tolua_S,".call",tolua_CTem_CTem_new00_local);
   tolua_function(tolua_S,"delete",tolua_CTem_CTem_delete00);
   tolua_function(tolua_S,"count",tolua_CTem_CTem_count00);
  tolua_endmodule(tolua_S);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_CTem (lua_State* tolua_S) {
 return tolua_CTem_open(tolua_S);
};
#endif

