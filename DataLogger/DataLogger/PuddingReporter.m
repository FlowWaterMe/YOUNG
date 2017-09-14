//
//  PuddingReporter.m
//  DataLogger
//
//  Created by IvanGan on 12-5-2.
//
//
#import <CoreLib/Common.h>

#import "PuddingReporter.h"

static NSLock * puddingLock = nil;

@implementation PuddingReporter
@synthesize m_DataPudding;

+(void)initialize
{
	puddingLock = [NSLock new];
}

-(void)PuddingReport
{
    [puddingLock lock];
    //attribute
    for (NSString * key in [m_dicAttribute keyEnumerator])
    {
        if (![m_DataPudding puddingAddAttribute:key andKeyValue:[m_dicAttribute valueForKey:key]])
        {
            [puddingLock unlock];
            NSString * strError = [NSString stringWithFormat:@"Pudding attribute failed, current attribute : \r\n%@", [[m_dicAttribute valueForKey:key]description]];
            NSString * strLog = [NSString stringWithFormat:@"Error : %@ Reason:%@",@"Pudding Error",strError];
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationOnTestError object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:strLog,@"msg",[NSNumber numberWithInt:0],@"id", nil]];
            
           // NSRunAlertPanel(@"Pudding Error", @"Pudding attribute failed, current attribute : \r\n%@", @"OK", nil, nil,[[m_dicAttribute valueForKey:key]description]);
            return;
        }
        else
        {
            NSLog(@"Pudding Attribute OK!");
        }
    }
    
    //item
    for (NSDictionary * dic in m_arrItem)
    {
        if (![m_DataPudding puddingParametricDataForTestItem:[dic valueForKey:kPuddingItemName] SubTestItem:[dic valueForKey:kPuddingItemSubName] SubSubTestItem:[dic valueForKey:kPuddingItemSubSubName] LowLimit:[dic valueForKey:kPuddingItemLowLimit] UpLimit:[dic valueForKey:kPuddingItemUpLimit] TestValue:[dic valueForKey:kPuddingItemValue] TestUnit:[dic valueForKey:kPuddingItemUnit] TestResult:[[dic valueForKey:kPuddingItemResult]intValue] FailMsg:[dic valueForKey:kPuddingItemFailMsg] Priority:(enum IP_PDCA_PRIORITY)[[dic valueForKey:kPuddingPriority]intValue]]) {
            
            [puddingLock unlock];
           NSString * strError = [NSString stringWithFormat:@"Pudding test item failed, current Item : \r\n%@", [dic description]];
            NSString * strLog = [NSString stringWithFormat:@"Error : %@ Reason:%@",@"Pudding Error",strError];
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationOnTestError object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:strLog,@"msg",[NSNumber numberWithInt:0],@"id", nil]];
            
            return;
        }
        else
        {
            NSLog(@"Pudding Item OK!");
        }
    }
    
    //result
    if (![m_DataPudding puddingDoneAndCommit:m_TestResult])
    {
        [puddingLock unlock];
        NSString * strError = [NSString stringWithFormat:@"Pudding commit failed, with test result : \r\n%d", m_TestResult];
        NSString * strLog = [NSString stringWithFormat:@"Error : %@ Reason:%@",@"Pudding Error",strError];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationOnTestError object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:strLog,@"msg",[NSNumber numberWithInt:0],@"id", nil]];
        
    }
    else
    {
        NSLog(@"Pudding Successful!");
    }
    
    [puddingLock unlock];
}

-(void)generateReport:(id)sender
{
 //   [self PuddingReport];
    [self performSelectorOnMainThread:@selector(PuddingReport) withObject:nil waitUntilDone:YES];
}

-(id)init
{
    self = [super init];
    if (self)
    {
        m_arrItem = [NSMutableArray new];
        m_dicAttribute = [[NSMutableDictionary alloc]init];
        m_TestResult = -1;
    }
    
    return self;
}

-(DataPudding *)puddingInit:(NSString *)strMlbSn sw_ver:(NSString *)strSoftwareVer sw_name:(NSString *)strSoftwareName limit_ver:(NSString *)strLimitVer unit_position:(int)pos
{
    m_DataPudding = [[DataPudding alloc] puddingInit:strMlbSn sw_ver:strSoftwareVer sw_name:strSoftwareName limit_ver:strLimitVer unit_position:pos];
    return m_DataPudding;
}

-(void)dealloc
{
    [super dealloc];
}

-(int)AddAttribute:(NSString *)key withValue:(NSString *)value
{
    //[m_arrAttribute addObject:[NSDictionary dictionaryWithObject:value forKey:key]];
    [m_dicAttribute setValue:value forKey:key];
    return 0;
}
-(int)AddItem:(NSDictionary *)dicItem
{
    [m_arrItem addObject:dicItem];
    return 0;
}

- (BOOL)PuddingBlob:(NSString*)name file:(NSString*)path
{
    //- (BOOL)puddingBlobWithNameInPDCA:(NSString *)nameInPDCA FilePath:(NSString *)FilePath
    BOOL bResult =[m_DataPudding puddingBlobWithNameInPDCA:name FilePath:path];
    if (!bResult)
    {
        NSLog(@"Pudding blob failed!name : %@ path : %@",name,path);
    }
    //return [m_DataPudding puddingBlobWithNameInPDCA:name FilePath:path];
    return bResult;
}

-(int)SetResult:(int)result
{
    m_TestResult = result;
    return 0;
}

-(void)flush
{
    [m_arrItem removeAllObjects];
    [m_dicAttribute removeAllObjects];
    m_TestResult = -1;
}

-(BOOL)SetDutPosition:(int)fixtureID withHeadID:(int)HeadID
{
    [puddingLock lock];
    bool r = [m_DataPudding SetDutPosition:fixtureID withHeadID:HeadID];
    [puddingLock unlock];
    return r;
}


-(BOOL)CheckAmIOk:(NSString * )mlbsn withErrrMsg:(NSMutableString *)msg
{
    return [m_DataPudding puddingCheckAmIOk:mlbsn :msg];
}

@end
