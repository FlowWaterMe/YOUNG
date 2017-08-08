/*
** Lua binding: Global_Function
** Generated automatically by tolua++-1.0.92 on Tue Aug  8 21:03:28 2017.
*/

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"

/* Exported function */
TOLUA_API int  tolua_Global_Function_open (lua_State* tolua_S);

#include "Global_Function.h"
#include "/Users/mac/Documents/程序/YOUNG/CoreLib/TestContext.h"

/* function to release collected object via destructor */
#ifdef __cplusplus

static int tolua_collect_CTestContext (lua_State* tolua_S)
{
 CTestContext* self = (CTestContext*) tolua_tousertype(tolua_S,1,0);
	Mtolua_delete(self);
	return 0;
}
#endif


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"CTestContext");
}

/* function: Delay */
#ifndef TOLUA_DISABLE_tolua_Global_Function_Delay00
static int tolua_Global_Function_Delay00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  int ms = ((int)  tolua_tonumber(tolua_S,1,0));
  {
   Delay(ms);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'Delay'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: Now */
#ifndef TOLUA_DISABLE_tolua_Global_Function_Now00
static int tolua_Global_Function_Now00(lua_State* tolua_S)
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
   double tolua_ret = (double)  Now();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'Now'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: Log */
#ifndef TOLUA_DISABLE_tolua_Global_Function_Log00
static int tolua_Global_Function_Log00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isstring(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  char* szLog = ((char*)  tolua_tostring(tolua_S,1,0));
  int uid = ((int)  tolua_tonumber(tolua_S,2,0));
  {
   int tolua_ret = (int)  Log(szLog,uid);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'Log'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: DbgLog */
#ifndef TOLUA_DISABLE_tolua_Global_Function_DbgLog00
static int tolua_Global_Function_DbgLog00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isstring(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  char* szLog = ((char*)  tolua_tostring(tolua_S,1,0));
  int uid = ((int)  tolua_tonumber(tolua_S,2,0));
  {
   int tolua_ret = (int)  DbgLog(szLog,uid);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'DbgLog'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: lock */
#ifndef TOLUA_DISABLE_tolua_Global_Function_lock00
static int tolua_Global_Function_lock00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isstring(tolua_S,1,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  char* name = ((char*)  tolua_tostring(tolua_S,1,NULL));
  {
   int tolua_ret = (int)  lock(name);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'lock'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: unlock */
#ifndef TOLUA_DISABLE_tolua_Global_Function_unlock00
static int tolua_Global_Function_unlock00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isstring(tolua_S,1,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  char* name = ((char*)  tolua_tostring(tolua_S,1,NULL));
  {
   int tolua_ret = (int)  unlock(name);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'unlock'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: LockInstrument */
#ifndef TOLUA_DISABLE_tolua_Global_Function_LockInstrument00
static int tolua_Global_Function_LockInstrument00(lua_State* tolua_S)
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
  const char* szLockName = ((const char*)  tolua_tostring(tolua_S,1,0));
  {
   LockInstrument(szLockName);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'LockInstrument'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UnlockInstrument */
#ifndef TOLUA_DISABLE_tolua_Global_Function_UnlockInstrument00
static int tolua_Global_Function_UnlockInstrument00(lua_State* tolua_S)
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
  const char* szLockName = ((const char*)  tolua_tostring(tolua_S,1,0));
  {
   UnlockInstrument(szLockName);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UnlockInstrument'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UnlockAllInstrument */
#ifndef TOLUA_DISABLE_tolua_Global_Function_UnlockAllInstrument00
static int tolua_Global_Function_UnlockAllInstrument00(lua_State* tolua_S)
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
   UnlockAllInstrument();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UnlockAllInstrument'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: CheckUsb */
#ifndef TOLUA_DISABLE_tolua_Global_Function_CheckUsb00
static int tolua_Global_Function_CheckUsb00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  unsigned long usb_address = ((unsigned long)  tolua_tonumber(tolua_S,1,0));
  {
   int tolua_ret = (int)  CheckUsb(usb_address);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'CheckUsb'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: WaitUsb */
#ifndef TOLUA_DISABLE_tolua_Global_Function_WaitUsb00
static int tolua_Global_Function_WaitUsb00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  unsigned long usb_address = ((unsigned long)  tolua_tonumber(tolua_S,1,0));
  int timeout = ((int)  tolua_tonumber(tolua_S,2,3000));
  {
   int tolua_ret = (int)  WaitUsb(usb_address,timeout);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'WaitUsb'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: set_bit */
#ifndef TOLUA_DISABLE_tolua_Global_Function_set_bit00
static int tolua_Global_Function_set_bit00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  unsigned long pdata = ((unsigned long)  tolua_tonumber(tolua_S,1,0));
  unsigned char index = ((unsigned char)  tolua_tonumber(tolua_S,2,0));
  {
   set_bit(&pdata,index);
   tolua_pushnumber(tolua_S,(lua_Number)pdata);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'set_bit'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: clr_bit */
#ifndef TOLUA_DISABLE_tolua_Global_Function_clr_bit00
static int tolua_Global_Function_clr_bit00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  unsigned long pdata = ((unsigned long)  tolua_tonumber(tolua_S,1,0));
  unsigned char index = ((unsigned char)  tolua_tonumber(tolua_S,2,0));
  {
   clr_bit(&pdata,index);
   tolua_pushnumber(tolua_S,(lua_Number)pdata);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'clr_bit'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: get_bit */
#ifndef TOLUA_DISABLE_tolua_Global_Function_get_bit00
static int tolua_Global_Function_get_bit00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  unsigned long data = ((unsigned long)  tolua_tonumber(tolua_S,1,0));
  unsigned char index = ((unsigned char)  tolua_tonumber(tolua_S,2,0));
  {
   unsigned char tolua_ret = (unsigned char)  get_bit(data,index);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'get_bit'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: bit_and */
#ifndef TOLUA_DISABLE_tolua_Global_Function_bit_and00
static int tolua_Global_Function_bit_and00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  unsigned long x = ((unsigned long)  tolua_tonumber(tolua_S,1,0));
  unsigned long y = ((unsigned long)  tolua_tonumber(tolua_S,2,0));
  {
   unsigned long tolua_ret = (unsigned long)  bit_and(x,y);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'bit_and'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: bit_or */
#ifndef TOLUA_DISABLE_tolua_Global_Function_bit_or00
static int tolua_Global_Function_bit_or00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  unsigned long x = ((unsigned long)  tolua_tonumber(tolua_S,1,0));
  unsigned long y = ((unsigned long)  tolua_tonumber(tolua_S,2,0));
  {
   unsigned long tolua_ret = (unsigned long)  bit_or(x,y);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'bit_or'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: bit_not */
#ifndef TOLUA_DISABLE_tolua_Global_Function_bit_not00
static int tolua_Global_Function_bit_not00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  unsigned long x = ((unsigned long)  tolua_tonumber(tolua_S,1,0));
  {
   unsigned long tolua_ret = (unsigned long)  bit_not(x);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'bit_not'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: bit_xor */
#ifndef TOLUA_DISABLE_tolua_Global_Function_bit_xor00
static int tolua_Global_Function_bit_xor00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  unsigned long x = ((unsigned long)  tolua_tonumber(tolua_S,1,0));
  unsigned long y = ((unsigned long)  tolua_tonumber(tolua_S,2,0));
  {
   unsigned long tolua_ret = (unsigned long)  bit_xor(x,y);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'bit_xor'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: bit_nor */
#ifndef TOLUA_DISABLE_tolua_Global_Function_bit_nor00
static int tolua_Global_Function_bit_nor00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  unsigned long x = ((unsigned long)  tolua_tonumber(tolua_S,1,0));
  unsigned long y = ((unsigned long)  tolua_tonumber(tolua_S,2,0));
  {
   unsigned long tolua_ret = (unsigned long)  bit_nor(x,y);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'bit_nor'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UUT_SYNCH */
#ifndef TOLUA_DISABLE_tolua_Global_Function_UUT_SYNCH00
static int tolua_Global_Function_UUT_SYNCH00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  int uut_id = ((int)  tolua_tonumber(tolua_S,1,0));
  char* pstatus = ((char*)  tolua_tostring(tolua_S,2,NULL));
  {
   int tolua_ret = (int)  UUT_SYNCH(uut_id,pstatus);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UUT_SYNCH'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UUT_ABORT */
#ifndef TOLUA_DISABLE_tolua_Global_Function_UUT_ABORT00
static int tolua_Global_Function_UUT_ABORT00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  int uut_id = ((int)  tolua_tonumber(tolua_S,1,0));
  {
   int tolua_ret = (int)  UUT_ABORT(uut_id);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UUT_ABORT'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: UUT_SetStatus */
#ifndef TOLUA_DISABLE_tolua_Global_Function_UUT_SetStatus00
static int tolua_Global_Function_UUT_SetStatus00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  int uut_id = ((int)  tolua_tonumber(tolua_S,1,0));
  char* pstatus = ((char*)  tolua_tostring(tolua_S,2,NULL));
  {
   int tolua_ret = (int)  UUT_SetStatus(uut_id,pstatus);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'UUT_SetStatus'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: Execute */
#ifndef TOLUA_DISABLE_tolua_Global_Function_Execute00
static int tolua_Global_Function_Execute00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isstring(tolua_S,1,0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,1,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,1,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* szcmd = ((const char*)  tolua_tostring(tolua_S,1,0));
  const char* poutput = ((const char*)  tolua_tostring(tolua_S,2,NULL));
  int waituntilreturn = ((int)  tolua_tonumber(tolua_S,3,1));
  int itimeout = ((int)  tolua_tonumber(tolua_S,4,30000));
  {
   int tolua_ret = (int)  Execute(szcmd,poutput,waituntilreturn,itimeout);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'Execute'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: Finish */
#ifndef TOLUA_DISABLE_tolua_Global_Function_Finish00
static int tolua_Global_Function_Finish00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  int pid = ((int)  tolua_tonumber(tolua_S,1,0));
  int sig = ((int)  tolua_tonumber(tolua_S,2,3));
  {
   int tolua_ret = (int)  Finish(pid,sig);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'Finish'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: POpen */
#ifndef TOLUA_DISABLE_tolua_Global_Function_popen00
static int tolua_Global_Function_popen00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isstring(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,1,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* szcmd = ((const char*)  tolua_tostring(tolua_S,1,0));
  int waituntilreturn = ((int)  tolua_tonumber(tolua_S,2,1));
  int itimeout = ((int)  tolua_tonumber(tolua_S,3,30000));
  {
   unsigned long tolua_ret = (unsigned long)  POpen(szcmd,waituntilreturn,itimeout);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'popen'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: PRead */
#ifndef TOLUA_DISABLE_tolua_Global_Function_pread00
static int tolua_Global_Function_pread00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  unsigned long pcontext = ((unsigned long)  tolua_tonumber(tolua_S,1,0));
  int len = ((int)  tolua_tonumber(tolua_S,2,-1));
  {
   const char* tolua_ret = (const char*)  PRead(pcontext,len);
   tolua_pushstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'pread'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: PWrite */
#ifndef TOLUA_DISABLE_tolua_Global_Function_pwrite00
static int tolua_Global_Function_pwrite00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  unsigned long pcontext = ((unsigned long)  tolua_tonumber(tolua_S,1,0));
  char* szbuffer = ((char*)  tolua_tostring(tolua_S,2,0));
  {
   int tolua_ret = (int)  PWrite(pcontext,szbuffer);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'pwrite'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: PWait */
#ifndef TOLUA_DISABLE_tolua_Global_Function_pwait00
static int tolua_Global_Function_pwait00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  unsigned long pcontext = ((unsigned long)  tolua_tonumber(tolua_S,1,0));
  int itimeout = ((int)  tolua_tonumber(tolua_S,2,30000));
  {
   int tolua_ret = (int)  PWait(pcontext,itimeout);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'pwait'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: PClose */
#ifndef TOLUA_DISABLE_tolua_Global_Function_pclose00
static int tolua_Global_Function_pclose00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  unsigned long pcontext = ((unsigned long)  tolua_tonumber(tolua_S,1,0));
  {
   int tolua_ret = (int)  PClose(pcontext);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'pclose'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: TestCancel */
#ifndef TOLUA_DISABLE_tolua_Global_Function_TestCancel00
static int tolua_Global_Function_TestCancel00(lua_State* tolua_S)
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
   int tolua_ret = (int)  TestCancel();
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'TestCancel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: msgbox */
#ifndef TOLUA_DISABLE_tolua_Global_Function_msgbox00
static int tolua_Global_Function_msgbox00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isstring(tolua_S,1,0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isstring(tolua_S,4,0,&tolua_err) ||
     !tolua_isstring(tolua_S,5,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* title = ((const char*)  tolua_tostring(tolua_S,1,0));
  const char* msg = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* button1 = ((const char*)  tolua_tostring(tolua_S,3,0));
  const char* button2 = ((const char*)  tolua_tostring(tolua_S,4,0));
  const char* button3 = ((const char*)  tolua_tostring(tolua_S,5,0));
  {
   int tolua_ret = (int)  msgbox(title,msg,button1,button2,button3);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'msgbox'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: syncAlertPanel */
#ifndef TOLUA_DISABLE_tolua_Global_Function_syncAlertPanel00
static int tolua_Global_Function_syncAlertPanel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  int uut_id = ((int)  tolua_tonumber(tolua_S,1,0));
  const char* msg = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   syncAlertPanel(uut_id,msg);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'syncAlertPanel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: showSelectPanel */
#ifndef TOLUA_DISABLE_tolua_Global_Function_showSelectPanel00
static int tolua_Global_Function_showSelectPanel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isnumber(tolua_S,1,0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  int uut_id = ((int)  tolua_tonumber(tolua_S,1,0));
  const char* msg = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   int tolua_ret = (int)  showSelectPanel(uut_id,msg);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'showSelectPanel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* function: MessageBox */
#ifndef TOLUA_DISABLE_tolua_Global_Function_MessageBox00
static int tolua_Global_Function_MessageBox00(lua_State* tolua_S)
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
  const char* msg = ((const char*)  tolua_tostring(tolua_S,1,0));
  {
   int tolua_ret = (int)  MessageBox(msg);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'MessageBox'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: new of class  CTestContext */
#ifndef TOLUA_DISABLE_tolua_Global_Function_CTestContext_new00
static int tolua_Global_Function_CTestContext_new00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CTestContext",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   CTestContext* tolua_ret = (CTestContext*)  Mtolua_new((CTestContext)());
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CTestContext");
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

/* method: new_local of class  CTestContext */
#ifndef TOLUA_DISABLE_tolua_Global_Function_CTestContext_new00_local
static int tolua_Global_Function_CTestContext_new00_local(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CTestContext",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   CTestContext* tolua_ret = (CTestContext*)  Mtolua_new((CTestContext)());
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CTestContext");
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

/* method: delete of class  CTestContext */
#ifndef TOLUA_DISABLE_tolua_Global_Function_CTestContext_delete00
static int tolua_Global_Function_CTestContext_delete00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CTestContext",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CTestContext* self = (CTestContext*)  tolua_tousertype(tolua_S,1,0);
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

/* method: getContext of class  CTestContext */
#ifndef TOLUA_DISABLE_tolua_Global_Function_CTestContext_getContext00
static int tolua_Global_Function_CTestContext_getContext00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"const CTestContext",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const CTestContext* self = (const CTestContext*)  tolua_tousertype(tolua_S,1,0);
  char* szkey = ((char*)  tolua_tostring(tolua_S,2,0));
  int bStation = ((int)  tolua_tonumber(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'getContext'", NULL);
#endif
  {
   const char* tolua_ret = (const char*)  self->getContext(szkey,bStation);
   tolua_pushstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getContext'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_Global_Function_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_function(tolua_S,"Delay",tolua_Global_Function_Delay00);
  tolua_function(tolua_S,"Now",tolua_Global_Function_Now00);
  tolua_function(tolua_S,"Log",tolua_Global_Function_Log00);
  tolua_function(tolua_S,"DbgLog",tolua_Global_Function_DbgLog00);
  tolua_function(tolua_S,"lock",tolua_Global_Function_lock00);
  tolua_function(tolua_S,"unlock",tolua_Global_Function_unlock00);
  tolua_function(tolua_S,"LockInstrument",tolua_Global_Function_LockInstrument00);
  tolua_function(tolua_S,"UnlockInstrument",tolua_Global_Function_UnlockInstrument00);
  tolua_function(tolua_S,"UnlockAllInstrument",tolua_Global_Function_UnlockAllInstrument00);
  tolua_function(tolua_S,"CheckUsb",tolua_Global_Function_CheckUsb00);
  tolua_function(tolua_S,"WaitUsb",tolua_Global_Function_WaitUsb00);
  tolua_function(tolua_S,"set_bit",tolua_Global_Function_set_bit00);
  tolua_function(tolua_S,"clr_bit",tolua_Global_Function_clr_bit00);
  tolua_function(tolua_S,"get_bit",tolua_Global_Function_get_bit00);
  tolua_function(tolua_S,"bit_and",tolua_Global_Function_bit_and00);
  tolua_function(tolua_S,"bit_or",tolua_Global_Function_bit_or00);
  tolua_function(tolua_S,"bit_not",tolua_Global_Function_bit_not00);
  tolua_function(tolua_S,"bit_xor",tolua_Global_Function_bit_xor00);
  tolua_function(tolua_S,"bit_nor",tolua_Global_Function_bit_nor00);
  tolua_function(tolua_S,"UUT_SYNCH",tolua_Global_Function_UUT_SYNCH00);
  tolua_function(tolua_S,"UUT_ABORT",tolua_Global_Function_UUT_ABORT00);
  tolua_function(tolua_S,"UUT_SetStatus",tolua_Global_Function_UUT_SetStatus00);
  tolua_function(tolua_S,"Execute",tolua_Global_Function_Execute00);
  tolua_function(tolua_S,"Finish",tolua_Global_Function_Finish00);
  tolua_function(tolua_S,"popen",tolua_Global_Function_popen00);
  tolua_function(tolua_S,"pread",tolua_Global_Function_pread00);
  tolua_function(tolua_S,"pwrite",tolua_Global_Function_pwrite00);
  tolua_function(tolua_S,"pwait",tolua_Global_Function_pwait00);
  tolua_function(tolua_S,"pclose",tolua_Global_Function_pclose00);
  tolua_function(tolua_S,"TestCancel",tolua_Global_Function_TestCancel00);
  tolua_function(tolua_S,"msgbox",tolua_Global_Function_msgbox00);
  tolua_function(tolua_S,"syncAlertPanel",tolua_Global_Function_syncAlertPanel00);
  tolua_function(tolua_S,"showSelectPanel",tolua_Global_Function_showSelectPanel00);
  tolua_function(tolua_S,"MessageBox",tolua_Global_Function_MessageBox00);
  #ifdef __cplusplus
  tolua_cclass(tolua_S,"CTestContext","CTestContext","",tolua_collect_CTestContext);
  #else
  tolua_cclass(tolua_S,"CTestContext","CTestContext","",NULL);
  #endif
  tolua_beginmodule(tolua_S,"CTestContext");
   tolua_function(tolua_S,"new",tolua_Global_Function_CTestContext_new00);
   tolua_function(tolua_S,"new_local",tolua_Global_Function_CTestContext_new00_local);
   tolua_function(tolua_S,".call",tolua_Global_Function_CTestContext_new00_local);
   tolua_function(tolua_S,"delete",tolua_Global_Function_CTestContext_delete00);
   tolua_function(tolua_S,"getContext",tolua_Global_Function_CTestContext_getContext00);
  tolua_endmodule(tolua_S);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_Global_Function (lua_State* tolua_S) {
 return tolua_Global_Function_open(tolua_S);
};
#endif

