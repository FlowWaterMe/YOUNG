/*
** Lua binding: DataLogger
** Generated automatically by tolua++-1.0.92 on Thu Jul  2 18:20:27 2015.
*/

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"

/* Exported function */
TOLUA_API int  tolua_DataLogger_open (lua_State* tolua_S);

#include "DataLogger.h"

/* function to release collected object via destructor */
#ifdef __cplusplus

static int tolua_collect_CDataLogger (lua_State* tolua_S)
{
 CDataLogger* self = (CDataLogger*) tolua_tousertype(tolua_S,1,0);
	Mtolua_delete(self);
	return 0;
}
#endif


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"CDataLogger");
}

/* method: new of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_new00
static int tolua_DataLogger_CDataLogger_new00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   CDataLogger* tolua_ret = (CDataLogger*)  Mtolua_new((CDataLogger)());
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CDataLogger");
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

/* method: new_local of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_new00_local
static int tolua_DataLogger_CDataLogger_new00_local(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   CDataLogger* tolua_ret = (CDataLogger*)  Mtolua_new((CDataLogger)());
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CDataLogger");
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

/* method: delete of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_delete00
static int tolua_DataLogger_CDataLogger_delete00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
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

/* method: pdca_init of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_pdca_init00
static int tolua_DataLogger_CDataLogger_pdca_init00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,1,&tolua_err) ||
     !tolua_isstring(tolua_S,4,1,&tolua_err) ||
     !tolua_isstring(tolua_S,5,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  const char* mlbsn = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* sw_name = ((const char*)  tolua_tostring(tolua_S,3,"intelli_fct"));
  const char* sw_version = ((const char*)  tolua_tostring(tolua_S,4,"1.0"));
  const char* limit_version = ((const char*)  tolua_tostring(tolua_S,5,"1.0"));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'pdca_init'", NULL);
#endif
  {
   const char* tolua_ret = (const char*)  self->pdca_init(mlbsn,sw_name,sw_version,limit_version);
   tolua_pushstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'pdca_init'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: push_item of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_push_item00
static int tolua_DataLogger_CDataLogger_push_item00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isstring(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isstring(tolua_S,6,0,&tolua_err) ||
     !tolua_isstring(tolua_S,7,0,&tolua_err) ||
     !tolua_isstring(tolua_S,8,0,&tolua_err) ||
     !tolua_isstring(tolua_S,9,0,&tolua_err) ||
     !tolua_isstring(tolua_S,10,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,11,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  char* name = ((char*)  tolua_tostring(tolua_S,2,0));
  char* subname = ((char*)  tolua_tostring(tolua_S,3,0));
  char* subsubname = ((char*)  tolua_tostring(tolua_S,4,0));
  int status = ((int)  tolua_tonumber(tolua_S,5,0));
  char* value = ((char*)  tolua_tostring(tolua_S,6,0));
  char* lower = ((char*)  tolua_tostring(tolua_S,7,0));
  char* upper = ((char*)  tolua_tostring(tolua_S,8,0));
  char* unit = ((char*)  tolua_tostring(tolua_S,9,0));
  char* failmsg = ((char*)  tolua_tostring(tolua_S,10,NULL));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'push_item'", NULL);
#endif
  {
   int tolua_ret = (int)  self->push_item(name,subname,subsubname,status,value,lower,upper,unit,failmsg);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'push_item'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: push_attr of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_push_attr00
static int tolua_DataLogger_CDataLogger_push_attr00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  char* value = ((char*)  tolua_tostring(tolua_S,2,0));
  char* key = ((char*)  tolua_tostring(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'push_attr'", NULL);
#endif
  {
   int tolua_ret = (int)  self->push_attr(value,key);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'push_attr'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: push_result of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_push_result00
static int tolua_DataLogger_CDataLogger_push_result00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  int result = ((int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'push_result'", NULL);
#endif
  {
   int tolua_ret = (int)  self->push_result(result);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'push_result'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: PuddingBlob of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_PuddingBlob00
static int tolua_DataLogger_CDataLogger_PuddingBlob00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  const char* name = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* file_path = ((const char*)  tolua_tostring(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'PuddingBlob'", NULL);
#endif
  {
   int tolua_ret = (int)  self->PuddingBlob(name,file_path);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'PuddingBlob'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: QuerySFC of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_QuerySFC00
static int tolua_DataLogger_CDataLogger_QuerySFC00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  const char* key = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* pStation = ((const char*)  tolua_tostring(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'QuerySFC'", NULL);
#endif
  {
   const char* tolua_ret = (const char*)  self->QuerySFC(key,pStation);
   tolua_pushstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'QuerySFC'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: PushSFC of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_PushSFC00
static int tolua_DataLogger_CDataLogger_PushSFC00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'PushSFC'", NULL);
#endif
  {
   int tolua_ret = (int)  self->PushSFC();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'PushSFC'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: CheckFetalError of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_CheckFetalError00
static int tolua_DataLogger_CDataLogger_CheckFetalError00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  const char* mlbsn = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'CheckFetalError'", NULL);
#endif
  {
   const char* tolua_ret = (const char*)  self->CheckFetalError(mlbsn);
   tolua_pushstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'CheckFetalError'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: CheckProcessControl of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_CheckProcessControl00
static int tolua_DataLogger_CDataLogger_CheckProcessControl00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  const char* mlbsn = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'CheckProcessControl'", NULL);
#endif
  {
   const char* tolua_ret = (const char*)  self->CheckProcessControl(mlbsn);
   tolua_pushstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'CheckProcessControl'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: ipReport of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_ipReport00
static int tolua_DataLogger_CDataLogger_ipReport00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  char* filepath = ((char*)  tolua_tostring(tolua_S,2,NULL));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'ipReport'", NULL);
#endif
  {
   int tolua_ret = (int)  self->ipReport(filepath);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'ipReport'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: SetFileHeader of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_SetFileHeader00
static int tolua_DataLogger_CDataLogger_SetFileHeader00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  char* szfileheader = ((char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'SetFileHeader'", NULL);
#endif
  {
   int tolua_ret = (int)  self->SetFileHeader(szfileheader);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'SetFileHeader'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: push_keys of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_push_keys00
static int tolua_DataLogger_CDataLogger_push_keys00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  char* szItems = ((char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'push_keys'", NULL);
#endif
  {
   self->push_keys(szItems);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'push_keys'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: push_values of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_push_values00
static int tolua_DataLogger_CDataLogger_push_values00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  char* szItems = ((char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'push_values'", NULL);
#endif
  {
   self->push_values(szItems);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'push_values'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: push_uppers of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_push_uppers00
static int tolua_DataLogger_CDataLogger_push_uppers00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  char* szItems = ((char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'push_uppers'", NULL);
#endif
  {
   self->push_uppers(szItems);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'push_uppers'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: push_lowers of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_push_lowers00
static int tolua_DataLogger_CDataLogger_push_lowers00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  char* szItems = ((char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'push_lowers'", NULL);
#endif
  {
   self->push_lowers(szItems);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'push_lowers'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: push_units of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_push_units00
static int tolua_DataLogger_CDataLogger_push_units00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  char* szItems = ((char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'push_units'", NULL);
#endif
  {
   self->push_units(szItems);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'push_units'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: SaveToFile of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_SaveToFile00
static int tolua_DataLogger_CDataLogger_SaveToFile00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  char* filepath = ((char*)  tolua_tostring(tolua_S,2,NULL));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'SaveToFile'", NULL);
#endif
  {
   int tolua_ret = (int)  self->SaveToFile(filepath);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'SaveToFile'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: csvReport of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_csvReport00
static int tolua_DataLogger_CDataLogger_csvReport00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  char* filepath = ((char*)  tolua_tostring(tolua_S,2,NULL));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'csvReport'", NULL);
#endif
  {
   int tolua_ret = (int)  self->csvReport(filepath);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'csvReport'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: uartLog of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_uartLog00
static int tolua_DataLogger_CDataLogger_uartLog00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  char* filepath = ((char*)  tolua_tostring(tolua_S,2,NULL));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'uartLog'", NULL);
#endif
  {
   int tolua_ret = (int)  self->uartLog(filepath);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'uartLog'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: testflowLog of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_testflowLog00
static int tolua_DataLogger_CDataLogger_testflowLog00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  char* filepath = ((char*)  tolua_tostring(tolua_S,2,NULL));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'testflowLog'", NULL);
#endif
  {
   int tolua_ret = (int)  self->testflowLog(filepath);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'testflowLog'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: GenerateReport of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_GenerateReport00
static int tolua_DataLogger_CDataLogger_GenerateReport00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'GenerateReport'", NULL);
#endif
  {
   int tolua_ret = (int)  self->GenerateReport();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'GenerateReport'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: AddBlob of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_AddBlob00
static int tolua_DataLogger_CDataLogger_AddBlob00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  const char* szpath = ((const char*)  tolua_tostring(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'AddBlob'", NULL);
#endif
  {
   int tolua_ret = (int)  self->AddBlob(szpath);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'AddBlob'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: SendBlob of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_SendBlob00
static int tolua_DataLogger_CDataLogger_SendBlob00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  const char* szblobname = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* szblobfile = ((const char*)  tolua_tostring(tolua_S,3,0));
  int state = ((int)  tolua_tonumber(tolua_S,4,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'SendBlob'", NULL);
#endif
  {
   int tolua_ret = (int)  self->SendBlob(szblobname,szblobfile,state);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'SendBlob'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: SetFixtureID of class  CDataLogger */
#ifndef TOLUA_DISABLE_tolua_DataLogger_CDataLogger_SetFixtureID00
static int tolua_DataLogger_CDataLogger_SetFixtureID00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CDataLogger",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CDataLogger* self = (CDataLogger*)  tolua_tousertype(tolua_S,1,0);
  int fixtureid = ((int)  tolua_tonumber(tolua_S,2,0));
  int headerid = ((int)  tolua_tonumber(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'SetFixtureID'", NULL);
#endif
  {
   int tolua_ret = (int)  self->SetFixtureID(fixtureid,headerid);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'SetFixtureID'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: getSFC */
#ifndef TOLUA_DISABLE_tolua_DataLogger_getSFC00
static int tolua_DataLogger_getSFC00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isstring(tolua_S,1,0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* mlbsn = ((const char*)  tolua_tostring(tolua_S,1,0));
  const char* key = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* station = ((const char*)  tolua_tostring(tolua_S,3,"FCT"));
  {
   const char* tolua_ret = (const char*)  getSFC(mlbsn,key,station);
   tolua_pushstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getSFC'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: putSFC */
#ifndef TOLUA_DISABLE_tolua_DataLogger_putSFC00
static int tolua_DataLogger_putSFC00(lua_State* tolua_S)
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
  const char* url = ((const char*)  tolua_tostring(tolua_S,1,0));
  {
   const char* tolua_ret = (const char*)  putSFC(url);
   tolua_pushstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'putSFC'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: putSFC */
#ifndef TOLUA_DISABLE_tolua_DataLogger_putSFC01
static int tolua_DataLogger_putSFC01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isstring(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* url = ((const char*)  tolua_tostring(tolua_S,1,0));
  int timout = ((int)  tolua_tonumber(tolua_S,2,0));
  {
   const char* tolua_ret = (const char*)  putSFC(url,timout);
   tolua_pushstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
tolua_lerror:
 return tolua_DataLogger_putSFC00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_DataLogger_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  #ifdef __cplusplus
  tolua_cclass(tolua_S,"CDataLogger","CDataLogger","",tolua_collect_CDataLogger);
  #else
  tolua_cclass(tolua_S,"CDataLogger","CDataLogger","",NULL);
  #endif
  tolua_beginmodule(tolua_S,"CDataLogger");
   tolua_function(tolua_S,"new",tolua_DataLogger_CDataLogger_new00);
   tolua_function(tolua_S,"new_local",tolua_DataLogger_CDataLogger_new00_local);
   tolua_function(tolua_S,".call",tolua_DataLogger_CDataLogger_new00_local);
   tolua_function(tolua_S,"delete",tolua_DataLogger_CDataLogger_delete00);
   tolua_function(tolua_S,"pdca_init",tolua_DataLogger_CDataLogger_pdca_init00);
   tolua_function(tolua_S,"push_item",tolua_DataLogger_CDataLogger_push_item00);
   tolua_function(tolua_S,"push_attr",tolua_DataLogger_CDataLogger_push_attr00);
   tolua_function(tolua_S,"push_result",tolua_DataLogger_CDataLogger_push_result00);
   tolua_function(tolua_S,"PuddingBlob",tolua_DataLogger_CDataLogger_PuddingBlob00);
   tolua_function(tolua_S,"QuerySFC",tolua_DataLogger_CDataLogger_QuerySFC00);
   tolua_function(tolua_S,"PushSFC",tolua_DataLogger_CDataLogger_PushSFC00);
   tolua_function(tolua_S,"CheckFetalError",tolua_DataLogger_CDataLogger_CheckFetalError00);
   tolua_function(tolua_S,"CheckProcessControl",tolua_DataLogger_CDataLogger_CheckProcessControl00);
   tolua_function(tolua_S,"ipReport",tolua_DataLogger_CDataLogger_ipReport00);
   tolua_function(tolua_S,"SetFileHeader",tolua_DataLogger_CDataLogger_SetFileHeader00);
   tolua_function(tolua_S,"push_keys",tolua_DataLogger_CDataLogger_push_keys00);
   tolua_function(tolua_S,"push_values",tolua_DataLogger_CDataLogger_push_values00);
   tolua_function(tolua_S,"push_uppers",tolua_DataLogger_CDataLogger_push_uppers00);
   tolua_function(tolua_S,"push_lowers",tolua_DataLogger_CDataLogger_push_lowers00);
   tolua_function(tolua_S,"push_units",tolua_DataLogger_CDataLogger_push_units00);
   tolua_function(tolua_S,"SaveToFile",tolua_DataLogger_CDataLogger_SaveToFile00);
   tolua_function(tolua_S,"csvReport",tolua_DataLogger_CDataLogger_csvReport00);
   tolua_function(tolua_S,"uartLog",tolua_DataLogger_CDataLogger_uartLog00);
   tolua_function(tolua_S,"testflowLog",tolua_DataLogger_CDataLogger_testflowLog00);
   tolua_function(tolua_S,"GenerateReport",tolua_DataLogger_CDataLogger_GenerateReport00);
   tolua_function(tolua_S,"AddBlob",tolua_DataLogger_CDataLogger_AddBlob00);
   tolua_function(tolua_S,"SendBlob",tolua_DataLogger_CDataLogger_SendBlob00);
   tolua_function(tolua_S,"SetFixtureID",tolua_DataLogger_CDataLogger_SetFixtureID00);
  tolua_endmodule(tolua_S);
  tolua_function(tolua_S,"getSFC",tolua_DataLogger_getSFC00);
  tolua_function(tolua_S,"putSFC",tolua_DataLogger_putSFC00);
  tolua_function(tolua_S,"putSFC",tolua_DataLogger_putSFC01);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_DataLogger (lua_State* tolua_S) {
 return tolua_DataLogger_open(tolua_S);
};
#endif

