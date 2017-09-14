//
//  DataLogger.cpp
//  DataLogger
//
//  Created by Ryan on 12-9-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include "DataLogger.h"
#include <string.h>
#include <CoreLib/common.h>

#include <CoreLib/TestContext.h>
#include <CoreLib/TestEngine.h>
#include <CoreLib/PathManager.h>

#define LOG_DIR @"/vault/Intelli_Log"

static int ip_Count_Index = 0;
static NSMutableArray * arrDataLogger=[NSMutableArray new];

static int csv_Count_Index=0;
static NSMutableArray * arrCsvLogger=[NSMutableArray new];

//NSString * CDataLogger::m_strCsvFilePath=nil;

static   NSLock * report_lock = nil;

extern TestEngine * pTestEngine;

CDataLogger::CDataLogger()
{
    m_CsvReporter = [CsvReporter new];
    m_PuddingReporter = [PuddingReporter new];
    m_arrBlob = [NSMutableArray new];
}

CDataLogger::CDataLogger(int idUUT)
{
    m_CsvReporter = [CsvReporter new];
    m_PuddingReporter = [PuddingReporter new];
    m_arrBlob = [NSMutableArray new];

    m_UUT_ID = idUUT;
    
    if (!report_lock)
    {
        report_lock = [NSLock new];
    }
}

CDataLogger::~CDataLogger()
{
    if (m_CsvReporter)
    {
        [m_CsvReporter release];
    }
    if (m_PuddingReporter)
    {
        [m_PuddingReporter release];
    }
    
    if (arrDataLogger)
    {
        [arrDataLogger release];
    }
    
    if (arrCsvLogger)
    {
        [arrCsvLogger release];
    }
    
    
    if (m_arrBlob)
    {
        [m_arrBlob release];
    }
    
    [report_lock release];
}


#pragma mark Pudding_Report
//PDCA
const char * CDataLogger::pdca_init(const char *mlbsn,const char * sw_name,const char * sw_version,const char * limit_version)
{
    [report_lock lock];
    ip_Count_Index=0;
    csv_Count_Index=0;
    [arrDataLogger removeAllObjects];
    [arrCsvLogger removeAllObjects];
    [report_lock unlock];
    
    [m_arrBlob removeAllObjects];
    [m_PuddingReporter flush];
    [m_CsvReporter flush];
    BOOL bPudding =  [[CTestContext::m_dicConfiguration valueForKey:kConfigPuddingPDCA] boolValue];
    if (!bPudding) return NULL; //NO need pudding
    
    [m_PuddingReporter puddingInit:[NSString stringWithUTF8String:mlbsn] sw_ver:[NSString stringWithUTF8String:sw_version] sw_name:[NSString stringWithUTF8String:sw_name] limit_ver:[NSString stringWithUTF8String:limit_version] unit_position:this->m_UUT_ID];

    return NULL;
}

//int CDataLogger::CheckFetalError(const char *mlbsn, char *pFetalError)
const char * CDataLogger::CheckFetalError(const char *mlbsn)
{
#if 0
    NSMutableString * strFetalError = [NSMutableString new];
    BOOL b = [m_PuddingReporter.m_DataPudding puddingCheckAmIOk:[NSString stringWithUTF8String:mlbsn] :strFetalError];
    return b;
#else
    NSMutableString * strFetalError = [NSMutableString new];
    //    BOOL b = [m_PuddingReporter.m_DataPudding puddingCheckAmIOk:[NSString stringWithUTF8String:mlbsn] :strFetalError];
    BOOL b = [m_PuddingReporter CheckAmIOk:[NSString stringWithUTF8String:mlbsn] withErrrMsg:strFetalError];
    NSString * str = [NSString stringWithString:strFetalError];
    [strFetalError release];
    if (b)
    {
        return nil;
    }
    else {
        return [str UTF8String];
    }
    //    return b;
#endif
}

const char * CDataLogger::CheckProcessControl(const char *mlbsn)
{
    NSMutableString * strFetalError = [NSMutableString new];
    BOOL b = [DataPudding CheckProcessControl:[NSString stringWithUTF8String:mlbsn] withErrorMsg:strFetalError];
    NSString * str = [NSString stringWithString:strFetalError];
    [strFetalError release];
    if (b)
    {
        return nil;
    }
    else {
        return [str UTF8String];
    }
}


int CDataLogger::PuddingBlob(const char* name, const char* file_path)
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:file_path]]==FALSE)
    {
        return -2;
    }
    BOOL b = [m_PuddingReporter PuddingBlob:[NSString stringWithUTF8String:name] file:[NSString stringWithUTF8String:file_path]];
    if (b == YES) return 0;
    return -1;
}

int CDataLogger::push_item(char * name,char * subname,char * subsubname,int status,char * value,char * lower,char * upper,char * unit,char * failmsg)
{
    
    BOOL bPudding =  [[CTestContext::m_dicConfiguration valueForKey:kConfigPuddingPDCA] boolValue];
    if (!bPudding) return 0; //NO need pudding
    
    if (!lower) lower = (char *)"N/A";
    if (!upper) upper = (char *)"N/A";
    if (!unit) unit = (char *)"N/A";
    if (!subname) subname=(char *)"";
    if (!subsubname) subsubname=(char *)"";
    
    /*PDCA priority
     enum IP_PDCA_PRIORITY
     {
     IP_PRIORITY_STATION_CALIBRATION_AUDIT	= -2,
     IP_PRIORITY_REALTIME_WITH_ALARMS		= 0,
     IP_PRIORITY_REALTIME					= 1,
     IP_PRIORITY_DELAYED_WITH_DAILY_ALARMS	= 2,
     IP_PRIORITY_DELAYED_IMPORT				= 3,
     IP_PRIORITY_ARCHIVE					= 4,
     };
     int priority[] = {0, -2, 1, 2, 3, 4};
     */
    NSNumber* numPriority = [NSNumber numberWithInt:IP_PRIORITY_REALTIME_WITH_ALARMS];
    int priority[] = {0, -2, 1, 2, 3, 4};
    int specified_priority_index = [[CTestContext::m_dicConfiguration valueForKey:kConfigPriority] intValue];
    if (specified_priority_index < sizeof(priority)) {
        numPriority = [NSNumber numberWithInt:priority[specified_priority_index]];
    }else
    {
        NSLog(@"Warning: Specified PDCA priority index is out of range, will use default setting IP_PRIORITY_REALTIME_WITH_ALARMS");
    }
    
    
    NSArray * arrKey = [NSArray arrayWithObjects:kPuddingItemName,kPuddingItemSubName,kPuddingItemSubSubName,kPuddingItemResult,kPuddingItemValue,kPuddingItemLowLimit,kPuddingItemUpLimit,kPuddingItemUnit, kPuddingItemFailMsg,kPuddingPriority,nil];
    NSArray * arrObj = [NSArray arrayWithObjects:[NSString stringWithUTF8String:name],[NSString stringWithUTF8String:subname],[NSString stringWithUTF8String:subsubname],[NSNumber numberWithInt:status],[NSString stringWithUTF8String:value],[NSString stringWithUTF8String:lower],[NSString stringWithUTF8String:upper],[NSString stringWithUTF8String:unit],[NSString stringWithFormat:@"%s",failmsg],numPriority, nil];
    NSDictionary * dic = [NSDictionary dictionaryWithObjects:arrObj forKeys:arrKey];
    [m_PuddingReporter AddItem:dic];
    return 0;
}

int CDataLogger::push_result(int result)
{
    BOOL bPudding =  [[CTestContext::m_dicConfiguration valueForKey:kConfigPuddingPDCA] boolValue];
    if (!bPudding) return 0; //NO need pudding
    
    [m_PuddingReporter SetResult:result];
    return 0;
}

int CDataLogger::push_attr(char *attr, char *key)
{
    BOOL bPudding =  [[CTestContext::m_dicConfiguration valueForKey:kConfigPuddingPDCA] boolValue];
    if (!bPudding) return 0; //NO need pudding
    
    if (!attr) return -1;
    if (!key) return -2;
    
    [m_PuddingReporter AddAttribute:[NSString stringWithUTF8String:key] withValue:[NSString stringWithUTF8String:attr]];
    return 0;
}

int CDataLogger::PushSFC()
{
    BOOL bPudding =  [[CTestContext::m_dicConfiguration valueForKey:kConfigPuddingPDCA] boolValue];
    if (!bPudding) return 0; //NO need pudding
    
    return 0;
}

const char * CDataLogger::QuerySFC(const char *key,const char * pStation)
{
    if (!key) return NULL;
    NSMutableArray * arrResult = [NSMutableArray array];
    [m_PuddingReporter.m_DataPudding queryRecordFromSFC:[NSString stringWithUTF8String:pStation] :[NSArray arrayWithObject:[NSString stringWithUTF8String:key]] :arrResult];
    if ([arrResult count])
    {
        NSString * str = [arrResult objectAtIndex:0];
        return [[NSString stringWithString:str] UTF8String];
    }
    
    return 0;
}

//global function
const char * getSFC(const char * mlbsn,const char * key,const char * pStation)
{
    if (!key) return NULL;
    NSMutableArray * arrResult = [NSMutableArray new];
    [DataPudding querySFC:[NSString stringWithUTF8String:mlbsn] StationName:[NSString stringWithUTF8String:pStation] Keys:[NSArray arrayWithObject:[NSString stringWithUTF8String:key]] Result:arrResult];
    if ([arrResult count])
    {
        NSString * str = [arrResult objectAtIndex:0];
        return [[NSString stringWithString:str] UTF8String];
    }
    
    return NULL;
}

const char * putSFC(const char * url)
{
    NSURL * strURL = [NSURL URLWithString:[NSString stringWithUTF8String:url]];
    if (!strURL)
    {
        NSLog(@"Invalid URL : %@",[NSString stringWithUTF8String:url]);
        return NULL;
    }
    
    NSString * str = [NSString stringWithContentsOfURL:strURL encoding:NSUTF8StringEncoding error:NULL];
    
    NSLog(@"SFC Response : %@",str);
    
    return [str UTF8String];
}

const char * putSFC(const char * url,int timout)
{
    NSURL * strURL = [NSURL URLWithString:[NSString stringWithUTF8String:url]];
    if (!strURL)
    {
        NSLog(@"Invalid URL : %@",[NSString stringWithUTF8String:url]);
        return NULL;
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:strURL cachePolicy:0 timeoutInterval:timout];
    NSURLResponse* response=nil;
    NSError* error=nil;
    NSData* data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString * str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"SFC Response : %@",str);
    return [str UTF8String];
}

int GetTestingModule()
{
    int x=0;
    for (int i=0; i<=3; i++) {
        if ([pTestEngine IsTesting:i])
        {
            x++;
        }
    }
    return x;
}

int CDataLogger::ipReport1(char *filepath)
{
    ip_Count_Index++;
    if (ip_Count_Index<[pTestEngine WorkingMdoules])
    //if (ip_Count_Index<GetTestingModule())
    {
        [arrDataLogger addObject:[NSNumber numberWithLong:(long)this]];
        NSLog(@"pudding report skip");
    }
    else
    {
        BOOL bPudding =  [[CTestContext::m_dicConfiguration valueForKey:kConfigPuddingPDCA] boolValue];
        if (!bPudding) return 0; //NO need pudding
        
        [arrDataLogger addObject:[NSNumber numberWithLong:(long)this]];
        for (id v in arrDataLogger)
        {
            CDataLogger * p = (CDataLogger *)[v longValue];
            [p->m_PuddingReporter generateReport:nil];
            [p->m_PuddingReporter flush];
            NSLog(@"pudding now");
        }
        //clear for next
        ip_Count_Index = 0;
        [arrDataLogger removeAllObjects];
    }
    return 0;
}

int CDataLogger::ipReport(char *filepath)
{
    //return this->ipReport1(filepath);
    BOOL bPudding =  [[CTestContext::m_dicConfiguration valueForKey:kConfigPuddingPDCA] boolValue];
    if (!bPudding) return 0; //NO need pudding
    [m_PuddingReporter generateReport:nil];
    [m_PuddingReporter flush];
    return 0;
}



//CSV export function
int CDataLogger::SetFileHeader(char *szfileheader)
{
    [m_CsvReporter setCSVtitle:[NSString stringWithUTF8String:szfileheader]];
    return 0;
}

void CDataLogger::push_keys(char* szItems)
{
    [m_CsvReporter push_keys:[NSString stringWithUTF8String:szItems]];
}
void CDataLogger::push_values(char* szItems)
{
    [m_CsvReporter push_values:[NSString stringWithUTF8String:szItems]];
}
void CDataLogger::push_uppers(char* szItems)
{
    [m_CsvReporter push_uppers:[NSString stringWithUTF8String:szItems]];
}
void CDataLogger::push_lowers(char* szItems)
{
    [m_CsvReporter push_lowers:[NSString stringWithUTF8String:szItems]];
}
void CDataLogger::push_units(char* szItems)
{
    [m_CsvReporter push_units:[NSString stringWithUTF8String:szItems]];
}


int CDataLogger::csvReport1(char *filepath)
{
    csv_Count_Index++;
    if (csv_Count_Index<[pTestEngine WorkingMdoules])
    //if (csv_Count_Index<GetTestingModule())
    {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:(long)this],@"object",[NSString stringWithUTF8String:filepath],@"filepath", nil];
        //[arrCsvLogger addObject:[NSNumber numberWithLong:(long)this]];
        [arrCsvLogger addObject:dic];
        NSLog(@"csv report skip");
    }
    else
    {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:(long)this],@"object",[NSString stringWithUTF8String:filepath],@"filepath", nil];
        //[arrCsvLogger addObject:[NSNumber numberWithLong:(long)this]];
        [arrCsvLogger addObject:dic];
        for (id v in arrCsvLogger)
        {
            CDataLogger * p = (CDataLogger *)[[v valueForKey:@"object"] longValue];
            NSString * str = [v valueForKey:@"filepath"];
            [p->m_CsvReporter generateReport:str];
            [p->m_CsvReporter flush];
            
            NSLog(@"csv report now");
        }
        //clear for next
        csv_Count_Index = 0;
        [arrDataLogger removeAllObjects];
    }
    return 0;

}

int CDataLogger::csvReport(char *filepath)
{
    //return csvReport1(filepath);
    NSString * strFilePath = [NSString stringWithUTF8String:filepath];
    [m_CsvReporter generateReport:strFilePath];
    [m_CsvReporter flush];
    return 0;
}


int CDataLogger::uartLog(char *filepath)
{
    [report_lock lock];
    //NSLog(@"Call uarlog : %d!",m_UUT_ID);
    if (!filepath)
    {
        //uart log
        NSMutableString * strUartLog = [NSMutableString stringWithString:@"[LOG_DIR]/uart_log/[sn]_[station id]_[sit id]_[timestamp]_uart.txt"];
        [strUartLog replaceOccurrencesOfString:@"[LOG_DIR]" withString:LOG_DIR options:0 range:NSMakeRange(0, [strUartLog length])];
        [strUartLog replaceOccurrencesOfString:@"[sn]" withString:@"NO_SERIALNUMBER" options:0 range:NSMakeRange(0, [strUartLog length])];
        [strUartLog replaceOccurrencesOfString:@"[station id]" withString:@"station_id" options:0 range:NSMakeRange(0, [strUartLog length])];
        [strUartLog replaceOccurrencesOfString:@"[sit id]" withString:[NSString stringWithFormat:@"%d",m_UUT_ID] options:0 range:NSMakeRange(0, [strUartLog length])];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-­dd-­hh-­mm-­ss"];
        NSString * strTimes=[dateFormatter stringFromDate:[NSDate date]];    
        [strUartLog replaceOccurrencesOfString:@"[timestamp]" withString:strTimes options:0 range:NSMakeRange(0, [strUartLog length])];
        [dateFormatter release];
        filepath = (char *)[strUartLog UTF8String];
    }
    
    
    //post notification to save uart & test flow log
    NSMutableDictionary * dicUserinfor = [NSMutableDictionary dictionary];
    [dicUserinfor setObject:[NSString stringWithUTF8String:filepath] forKey:KEY_NF_UARTPATH];
//    [dicUserinfor setObject:strTestFlow forKey:KEY_NF_TESTFLOW];
    [dicUserinfor setObject:[NSNumber numberWithInt:m_UUT_ID] forKey:KEY_FIXTURE_ID];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSaveLog object:nil userInfo:dicUserinfor];
    
    //pudding blob
    if ([[CTestContext::m_dicConfiguration valueForKey:kConfigPuddingBlobUart] intValue])
    {
        AddBlob(filepath);
    }
    
    [report_lock unlock];
    return 0;
}

int CDataLogger::testflowLog(char *filepath)
{
    [report_lock lock];
    //test flow log
    if (!filepath)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-­dd-­hh-­mm-­ss"];
        NSString * strTimes=[dateFormatter stringFromDate:[NSDate date]];    
        [dateFormatter release];
    
        NSMutableString * strTestFlow = [NSMutableString stringWithString:@"[LOG_DIR]/testflow_log/[SerialNumber]_[station id]_[site id]_[timestamp]_flow.txt"];
        [strTestFlow replaceOccurrencesOfString:@"[LOG_DIR]" withString:LOG_DIR options:0 range:NSMakeRange(0, [strTestFlow length])];
        [strTestFlow replaceOccurrencesOfString:@"[SerialNumber]" withString:@"NO_SERIALNUMBER" options:0 range:NSMakeRange(0, [strTestFlow length])];
        [strTestFlow replaceOccurrencesOfString:@"[station id]" withString:@"station_id" options:0 range:NSMakeRange(0, [strTestFlow length])];
        [strTestFlow replaceOccurrencesOfString:@"[site id]" withString:[NSString stringWithFormat:@"%d",m_UUT_ID] options:0 range:NSMakeRange(0, [strTestFlow length])];
        [strTestFlow replaceOccurrencesOfString:@"[timestamp]" withString:strTimes options:0 range:NSMakeRange(0, [strTestFlow length])];
        
        filepath = (char *)[strTestFlow UTF8String];
    }
    NSMutableDictionary * dicUserinfor = [NSMutableDictionary dictionary];
    //[dicUserinfor setObject:[NSString stringWithUTF8String:filepath] forKey:KEY_NF_UARTPATH];
    [dicUserinfor setObject:[NSString stringWithUTF8String:filepath] forKey:KEY_NF_TESTFLOW];
    [dicUserinfor setObject:[NSNumber numberWithInt:m_UUT_ID] forKey:KEY_FIXTURE_ID];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationSaveLog object:nil userInfo:dicUserinfor];
    
    //pudding blob?
    if ([[CTestContext::m_dicConfiguration valueForKey:kConfigPuddingBlobTestFlow] intValue])
    {
        AddBlob(filepath);
    }
    [report_lock unlock];
    return 0;
}

int CDataLogger::GenerateReport()       //NO use
{
    csvReport();
    ipReport();
    uartLog();
    testflowLog();
    return 0;
}

int CDataLogger::SaveToFile(char *filepath)
{
    GenerateReport();
    return 0;
}

#pragma mark Blob
int CDataLogger::AddBlob(const char *szpath)
{
    NSString * str = [NSString stringWithUTF8String:szpath];
    [m_arrBlob addObject:str];
    return 0;
}

int CDataLogger::SendBlob(const char *szblobname, const char *szblobfile,int state)
{
    BOOL bPudding =  [[CTestContext::m_dicConfiguration valueForKey:kConfigPuddingPDCA] boolValue];
    if (!bPudding) return 0; //NO need pudding
    
    int iblob = [[CTestContext::m_dicConfiguration valueForKey:kConfigPuddingBlob] intValue];
    switch (iblob) {
        case 0:
            return 0;   //no need pudding blob file
            break;
        case 1:     //pudding anyway
            break;
        case 2:     //pudding failed
            if (state>0)
            {
                return 0;
            }
            break;
            
        default:
            break;
    }

    int ret = ZipBlobFile(szblobfile);
    if (ret<0) return ret;

    //get resolute path
    NSString *blob_dir  = [[PathManager sharedManager] blobPath];
    NSString *blob_file = [blob_dir stringByAppendingPathComponent:[NSString stringWithUTF8String:szblobfile]];
    
    ret = this->PuddingBlob(szblobname, [blob_file UTF8String]);
    [m_arrBlob removeAllObjects];
    
    bPudding = [[CTestContext::m_dicConfiguration valueForKey:kConfigRemoveLocalBlob] boolValue];
    if (bPudding)   //Remove local blob
    {
        NSError * err;
        if (![[NSFileManager defaultManager] removeItemAtPath:blob_file error:&err])
        {
            NSLog(@"%@",[err description]);
            return -1;
        }
    }
    return ret;
}

int CDataLogger::ZipBlobFile(const char *szpath)
{
    NSString * strCMD=@"ditto -ck ";
    NSString * blob_dir = [[PathManager sharedManager] blobPath];
    NSString * blob_file = [blob_dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%s", szpath]];
    NSString * stage_dir = [blob_file stringByDeletingPathExtension];

    NSError * err;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:stage_dir withIntermediateDirectories:YES attributes:nil error:&err])
    {
        NSLog(@"%@",[err description]);
        return -1;
    }
    
    for (NSString * f in m_arrBlob)
    {
        f = [f stringByResolvingSymlinksInPath];
        NSString * d = [stage_dir stringByAppendingPathComponent:[f lastPathComponent]];
        if (![[NSFileManager defaultManager] copyItemAtPath:f toPath:d error:&err])
        {
            NSLog(@"%@",[err description]);
        }
    }
    
    strCMD = [strCMD stringByAppendingFormat:@"%@ %@",stage_dir, blob_file];
    
    system([strCMD UTF8String]);
    
    //Clear
    if (![[NSFileManager defaultManager] removeItemAtPath:stage_dir error:&err])
    {
        NSLog(@"%@",[err description]);
    }
    
    
    return 0;

}

//Fixture ID
int CDataLogger::SetFixtureID(int fixtureid, int headerid)
{
    if ([m_PuddingReporter SetDutPosition:fixtureid withHeadID:headerid])
    {
        return 0;
    }
    return -1;
}