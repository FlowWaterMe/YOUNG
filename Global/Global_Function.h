//
//  Global_Function.h
//  Global
//
//  Created by Hogan on 17/8/7.
//  Copyright © 2017年 com.Young. All rights reserved.
//

//
//  Global_Function.h
//  Global
//
//  Created by Ryan on 12-11-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#pragma once
#include <iostream>
//Global Function
void Delay(int ms);     //Delay with milliseconds
double Now();           //Returns the interval between the receiver and the first instant of 1 January 1970, GMT
int Log(char * szLog,int uid=0);
int DbgLog(char * szLog,int uid);


//bit opeartion
void set_bit(unsigned long * pdata,unsigned char index);
void clr_bit(unsigned long * pdata,unsigned char index);
unsigned char get_bit(unsigned long data,unsigned char index);
unsigned long bit_and(unsigned long x,unsigned long y);     //and
unsigned long bit_or(unsigned long x,unsigned long y);      //or
unsigned long bit_not(unsigned long x);                     //not
unsigned long bit_xor(unsigned long x,unsigned long y);     //xor
unsigned long bit_nor(unsigned long x,unsigned long y);     //nor

int UUT_SYNCH(int uut_id,char * pstatus=NULL);    //同步所有夹具
int UUT_ABORT(int uut_id);
int UUT_SetStatus(int uut_id,char * pstatus=NULL);

int lock(char * name=NULL);
int unlock(char * name=NULL);

// This set of Locks allows for locking arbitrary critical section by name.
// Note that while each named lock is unique, they have global scope, making UnlockAllInstrument() an ungraceful reset.
void LockInstrument(const char * szLockName);
void UnlockInstrument(const char * szLockName);
void UnlockAllInstrument();

//usb operation
int CheckUsb(unsigned long usb_address);    //1: usb connecting, 0: usb disconnect.
int WaitUsb(unsigned long usb_address,int timeout=3000);    //waiting for a usb device conntected


//process function
//int Execute(const char * szcmd,int waituntilreturn=1,int timeout=30000);
int Execute(const char * szcmd,const char * poutput=NULL,int waituntilreturn=1,int itimeout=30000);

int Finish(int pid,int sig=3);

unsigned long POpen(const char * szcmd,int waituntilreturn=1,int itimeout=30000);
const char * PRead(unsigned long pcontext,int len=-1);
int PWrite(unsigned long pcontext,char * szbuffer);
int PWait(unsigned long pcontext,int itimeout=30000);
int PClose(unsigned long pcontext);

//test thread has been canelled or not
int TestCancel();

int msgbox(const char * title,const char * msg,const char * button1,const char * button2,const char * button3);

void syncAlertPanel(int uut_id , const char* msg);
int showSelectPanel(int uut_id, const char* msg) ;
int MessageBox(const char*msg) ;
