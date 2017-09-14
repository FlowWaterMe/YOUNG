//
//  TestContext.h
//  CoreLib
//
//  Created by Hogan on 17/8/7.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kContextStationName     @"StationName"
#define kContextStationID       @"StationID"
#define kContextStationType     @"StationType"
#define kContextLineName        @"LineName"
#define kContextLineNumber      @"LineNumber"
#define kContextStationNumber   @"StationNumber"
#define kContextVaultPath       @"VaultPath"
#define kContextCsvPath         @"CsvLogPath"
#define kContextUartPath        @"UartLogPath"
#define kContextTestFlow        @"TestFlowPath"
#define kContextPdcaServer      @"PDCA_Server"
#define kContextSfcServer       @"SFC_server"
#define kContextSfcURL          @"SFC_URL"
#define kContextAppDir          @"Application_Dir"
#define kContextTMVersion       @"TM_Version"

#define kContextID              @"uid"
#define kContextUsbLocation     @"USBlocation"
#define kContextMLBSN           @"MLB_SN"
#define kContextCFG             @"CFG"
#define kContextStartTime       @"StartTime"
#define kContextStopTime        @"StopTime"
#define kContextTotalTime       @"TotalTime"
#define kContextEnableTest      @"IsEnableTest"


#define kContextPanelSN         @"kContextPanelSN"
#define kContextBuildEvent      @"kContextBuildEvent"
#define kContextSBuild          @"kContextSBuil"


#define kContextFixtureID       @"FixtureID"

#define kContextCBAuthStationNameToCheck    @"CBAuthStationNameToCheck"
#define kContextCBAuthNumberToCheck         @"CBAuthNumberToCheck"
#define kContextCBAuthMaxFailForStation     @"CBAuthMaxFailForStation"
#define kContextCBAuthToClearOnPass         @"CBAuthToClearOnPass"
#define kContextCBAuthToClearOnFail         @"CBAuthToClearOnFail"
#define kContextCBAuthStationSetControlBit  @"CBAuthStationSetControlBit"

#ifndef CoreLib_TestContext_h
#define CoreLib_TestContext_h
class CTestContext
{
public:
    CTestContext();
    ~CTestContext();
public:
    const char* getContext(char *szKey,int index = 0)const;
public:
    static NSMutableDictionary * m_dicGlobal;
    static NSMutableDictionary * m_dicConfiguration;
    NSMutableDictionary * m_dicContext;
};
#endif

