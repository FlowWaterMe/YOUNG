//
//  DataLogger.h
//  DataLogger
//
//  Created by Ryan on 12-9-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#pragma once
#ifndef DataLogger_DataLogger_h
#define DataLogger_DataLogger_h
#include <stddef.h>

#include "testReport.h"
#include "CsvReporter.h"
#include "PuddingReporter.h"


class CDataLogger {
public:
    CDataLogger();
    CDataLogger(int uut_id);
    ~CDataLogger();
    
public:
//interface for add
    //push one item
    //pudding
    const char * pdca_init(const char * mlbsn,const char * sw_name="intelli_fct",const char * sw_version="1.0",const char * limit_version="1.0");
    //int push_item(char * name,int status,char * value=NULL,char * lower=NULL,char * upper=NULL,char * unit=NULL);
    int push_item(char * name,char * subname,char * subsubname,int status,char * value,char * lower,char * upper,char * unit,char * failmsg=NULL);
    int push_attr(char * value,char * key);
    int push_result(int result);
    int PuddingBlob(const char* name, const char* file_path);
    //SFC
    const char * QuerySFC(const char * key,const char * station="FCT");

    int PushSFC();
    //Check
    //int CheckFetalError(const char * mlbsn,char * pFetalError);
    const char * CheckFetalError(const char *mlbsn);
    int ipReport(char *filepath=NULL);  //generate pudding report
    int ipReport1(char *filepath);
    
    const char * CheckProcessControl(const char * mlbsn);
    
    //Csv log
    int SetFileHeader(char * szfileheader);

    void push_keys(char* szItems);
    void push_values(char* szItems);
    void push_uppers(char* szItems);
    void push_lowers(char* szItems);
    void push_units(char* szItems);
    
    int csvReport(char *filepath=NULL); //generate csv report
    int csvReport1(char *filepath=NULL); //generate csv report
    
    int uartLog(char *filepath=NULL);   //generate uart log
    int testflowLog(char *filepath=NULL);   //generate test flow log

    
    int SaveToFile(char * filepath=NULL);
    int GenerateReport();   //Create all report.
    
    //Blob
    int AddBlob(const char * szpath);
    int SendBlob(const char *szblobname, const char *szblobfile,int state);
    
    //Fixture ID
    int SetFixtureID(int fixtureid,int headerid);
protected:
    int ZipBlobFile(const char * szpath);

protected:
    int m_UUT_ID;
    
protected:
    NSMutableArray * m_arrBlob;
    
public:
    CsvReporter* m_CsvReporter;
    PuddingReporter * m_PuddingReporter;
    
};

const char * getSFC(const char * mlbsn,const char * key,const char * station="FCT");
const char * putSFC(const char * url);
const char * putSFC(const char * url,int timout);

#endif
