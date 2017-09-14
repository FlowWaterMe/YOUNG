//
////  uiMainWndDelegate.m
////  UI
////
////  Created by Ryan on 12-11-5.
////  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
////
//
#import "uiMainWndDelegate.h"
#include "GT_UserInterface.h"
#include "UI_Global.h"
#include "CoreLib/Common.h"
#include "CoreLib/PathManager.h"

#include "CoreLib/ScriptEngine.h"
#include "CoreLib/KeyItem.h"
#include "CoreLib/TestItem.h"
//#include "uiDebugWndDelegate.h"
//#include "uiConfigWndDelegate.h"
//
//#include "CoreLib/RegexKitLite.h"
//#include "UI_Global.h"
//#include "uiLooptesterWndDelegate.h"
//
//#include "uiLoginWndDelegate.h"
//#include "uiBarcodeWndDelegate.h"
//
//#include "TestFailListPanelDelegate.h"
//
#define Config_File     @"UI_config.plist"
//
///*
// -----------------------------------------------------------------------
// author:ZL Meng
// Date:Jul.17 2015
// Description:
// 修改测试线程数从6个改成1个
// -----------------------------------------------------------------------
// */
//
#define UI_MODULE       1

#define crPASS  [NSColor greenColor]
#define crFAIL  [NSColor redColor]
#define crRUN   [NSColor blueColor]
#define crNA    [NSColor grayColor]
#define crERROR [NSColor yellowColor]
//#define crIDLE  [NSColor cyanColor]
#define crIDLE  [NSColor selectedTextBackgroundColor]
//
//
uiMainWndDelegate * mainWnd=nil;
extern TestEngine * m_pTestEngine;
//
//static BOOL IsRetest = NO;
//
@implementation uiMainWndDelegate
@synthesize arrBreakPoints;
@synthesize loadedIndexPath;
-(void)awakeFromNib
{
    //initial.....
//    m_TestAutomation = [Automation new];
    
    mainWnd = self;
    m_DebugCondition = [NSCondition new];
    UI = new CUserInterface(self);
    
//    testProgressController = [[uiTestProgressController alloc] init];
    
    scrollOutlineViewTaskTimer = nil;
    
    //Load Configuration
//    [self LoadConfig:Config_File];
//    [self LoadFixtureID];
    
    NSString * profileToLoad = @"DemoFirst.seq";//[self autoLoadProfile];
    if (!profileToLoad || ![profileToLoad length])
    {
//        profileToLoad = [CTestContext::m_dicConfiguration valueForKey:@kEngineProfilePath];
    }
    [self LoadProfile:profileToLoad];
    
    //Create LogDir
//    @try {
//        NSString * path = [CTestContext::m_dicConfiguration valueForKey:kConfigLogDir];
//        NSError * err;
//        if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err])
//        {
//            NSRunAlertPanel(@"Create Logpath failed!", @"%@", @"OK", nil,nil,[err description]);
//        }
//    }
//    @catch (NSException *exception) {
//        NSRunAlertPanel([exception name], @"%@", @"OK", nil, nil,[exception reason]);
//    }
//    @finally {
//    }
//
//    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationAttachMenu object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:m_menu,@"menus",m_window,@"windows", nil]];
//    //create timer
//    testTimer= [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
//    [testTimer fire];
//    
//    itemTimer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(ItemElapsedTimer:) userInfo:nil repeats:YES];
//    
//    outlineViewUpdateTimer = nil;   // create later.
//    
//    [outlineView setDoubleAction:@selector(OnDblClickOutlineView:)];
//    
//    arrBreakPoints = [NSMutableArray new];
    
    //Add notification monitor
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationOnTestStart object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationOnTestStop object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationOnTestFinish object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationOnTestPause object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationOnTestResume object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationOnTestItemStart object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationOnTestItemFinish object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationOnTestError object:nil];
    
    //Do Action Notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationDoTestStart object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationDoTestStop object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationDoTestFinish object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationDoTestPause object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationDoTestResume object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationDoTestItemStart object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationDoTestItemFinish object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationDoTestError object:nil];
    
    
    //Ui Ctrl Notificaition
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationDoUiCtrl object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationEnableUUTCtrl object:nil] ;
    //Do Change User
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUiNotification:) name:kNotificationDoChangeUser object:nil];
    
    //Engine finish
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnEngineNotification:) name:kNotificationOnEngineStart object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnEngineNotification:) name:kNotificationOnEngineFinish object:nil];
    
    

    //post notification to attchment menus
//    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationAttachMenu object:nil userInfo:[NSDictionary dictionaryWithObject:instrMenu forKey:@"menus"]];
//    instrMenu = [[NSApp mainMenu]valueForKey:@"Intrument"];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationAttachMenu object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:instrMenu,@"menus",winMain,@"windows", nil]];
    

    
    //UI update
//    [textStation setStringValue:[CTestContext::m_dicGlobal valueForKey:kContextStationName]];
//    [textLine setStringValue:[CTestContext::m_dicGlobal valueForKey:kContextLineName]];
//    [textStationID setStringValue:[CTestContext::m_dicGlobal valueForKey:kContextStationID]];
    
//    NSString * str = [CTestContext::m_dicConfiguration valueForKey:kConfigFixtureID];
//    if ((!str)||([str length]==0))
//    {
        //NSRunAlertPanel(@"Fixture ID", @"Please scan the fixture id first!", @"OK", nil, nil);
//    }
//    else
//    {
//        [textFixtureID setStringValue:[CTestContext::m_dicConfiguration valueForKey:kConfigFixtureID]];
//    }
    
//    [textSNInput setEnabled:[[CTestContext::m_dicConfiguration valueForKey:kConfigScanBarcode]boolValue]];
//    [textSNInput becomeFirstResponder];
//    
//    m_dicTestResult = [NSMutableDictionary new];
//    
//    memset(&m_CurrUser, 0, sizeof(USER_INFOR));
//    
//    
//    [textSWVersion setStringValue:[CTestContext::m_dicGlobal valueForKey:kContextTMVersion]];
//    
//    if ([[CTestContext::m_dicConfiguration valueForKey:kConfigAutomationMode] boolValue])
//    {
//        [m_TestAutomation WriteVersion:[CTestContext::m_dicGlobal valueForKey:kContextTMVersion] ScriptVersion:[textVersion stringValue]];
//    }
    
    
    /*
     * give config window an early peek at options
     */
//    [(id)[winConfiguration delegate] InitialCtrls:CTestContext::m_dicConfiguration];
//    
    /*
     -----------------------------------------------------------------------
     author:ZL Meng
     Date:Jul.17 2015
     Description:
     修改默认显示界面到详细
     -----------------------------------------------------------------------
     */
    
//    [btnShowTests setState:NSOnState];
//    [self btnShowTestsClicked:self];
//    
//    int state = 0;
//    NSString * dicKey[]={@kEngineUUT0Enable,@kEngineUUT1Enable,@kEngineUUT2Enable,@kEngineUUT3Enable,@kEngineUUT4Enable,@kEngineUUT5Enable};
//    NSButton  * btUUT[]={btUUT1,btUUT2,btUUT3,btUUT4,btUUT5,btUUT6};
//    NSTextField * txtUUT[] = {textUUT1,textUUT2,textUUT3,textUUT4,textUUT5,textUUT6};
//    for (int i=1; i<6; i++){
//        [btUUT[i] setState:state];
//        [txtUUT[i] setBackgroundColor:state?crIDLE:crNA];
//        [CTestContext::m_dicConfiguration setValue:[NSNumber numberWithInt:0] forKey:dicKey[i]];
//    }
//    
}
//
-(void)dealloc
{
//    if (scrollOutlineViewTaskTimer)
//    {
//        [scrollOutlineViewTaskTimer invalidate];
//    }
//    
//    [m_DebugCondition release];
//    [arrBreakPoints release];
//    [m_dicTestResult release];
//    if (UI)
//    {
//        delete UI;
//        UI=NULL;
//    }
    [super dealloc];
}
//
//
-(void)LoadFixtureID
{
    @try {
        CScriptEngine * pScriptEngine=(CScriptEngine *)[m_pTestEngine GetScripEngine:0];
        int err = 0;
        
        //Get global function
        lua_getglobal(pScriptEngine->m_pLuaState, "__GetFixtureID");
        err = lua_pcall(pScriptEngine->m_pLuaState, 0, 1, 0);
        if (err)
        {
            NSString * strError = [NSString stringWithUTF8String:lua_tostring(pScriptEngine->m_pLuaState, -1)];
            @throw [NSException exceptionWithName:@"Lua Error" reason:strError userInfo:nil];
        }
        
        if (lua_type(pScriptEngine->m_pLuaState, -1)==LUA_TNIL)
        {
            NSString * strError = @"Invalid fixtureID format.";
            @throw [NSException exceptionWithName:@"Lua Error" reason:strError userInfo:nil];
        }
        
        //Read Result
        const char * fixtureid = lua_tostring(pScriptEngine->m_pLuaState, -1);
        
        if (strlen(fixtureid)==0)
        {
            NSString * strError = @"FixtureID length is 0!";
            @throw [NSException exceptionWithName:@"Lua Error" reason:strError userInfo:nil];
        }
        
        //Save profile file path name
//        [CTestContext::m_dicConfiguration setValue:[NSString stringWithFormat:@"%s",fixtureid] forKey:kConfigFixtureID];
    }
    @catch (NSException *exception) {
        NSString * msg = [NSString stringWithFormat:@"Could get fixture from fixtrue,please check the cable connection is OK, with error message:\r\n%@",[exception description]];
        NSLog(@"%@",msg);
        NSRunAlertPanel(@"Auto Get Fixture ID failed!", @"%@", @"OK", nil, nil,msg);
    }
    @finally {
    }
}
//
//
//#pragma mark Configuration
////Load configuration from config.plist
//-(void)LoadConfig:(NSString *)fileConfig
//{
//    NSString * strFixtureID = [CTestContext::m_dicConfiguration valueForKey:kConfigFixtureID];
//    
//    [CTestContext::m_dicConfiguration release];
//    NSString *config_dir  = [[PathManager sharedManager] configPath];
//    
//    CTestContext::m_dicConfiguration = [[NSMutableDictionary dictionaryWithContentsOfFile:[config_dir stringByAppendingPathComponent:fileConfig]] retain];
//    
//    NSArray * arrkey = [NSArray arrayWithObjects:@kEngineUUT0Enable,
//                        @kEngineUUT1Enable,
//                        @kEngineUUT2Enable,
//                        @kEngineUUT3Enable,
//                        @kEngineUUT4Enable,
//                        @kEngineUUT5Enable,
//                        @kEngineProfilePath,
//                        kConfigScanBarcode,
//                        kConfigScanCFG,
//                        kConfigPuddingPDCA,
//                        kConfigTriggerType,
//                        kConfigFailCount,
//                        kConfigLogDir,
//                        kConfigQueryResult,
//                        kConfigQeryStationName,
//                        kConfigSN1Format,
//                        kConfigSN2Format,
//                        kConfigSN3Format,
//                        kConfigSN4Format,
//                        kConfigSN5Format,
//                        kConfigSN6Format,
//                        kConfigTriggerString,
//                        kConfigAutomationMode,
//                        kConfigCheckEECode,
//                        kConfigFixtureID,
//                        kConfigPuddingBlob,
//                        kConfigPuddingBlobUart,
//                        kConfigPuddingBlobTestFlow,
//                        kConfigRemoveLocalBlob,
//                        kConfigPriority,
//                        nil];
//    
//    NSArray * arrDefault = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
//                            [NSNumber numberWithInt:1],
//                            [NSNumber numberWithInt:1],
//                            [NSNumber numberWithInt:1],
//                            [NSNumber numberWithInt:1],
//                            [NSNumber numberWithInt:1],
//                            @"initial.lua",                 //profile
//                            [NSNumber numberWithBool:YES],  //barcode
//                            [NSNumber numberWithBool:NO],  //cfg
//                            [NSNumber numberWithBool:YES],  //pdca
//                            [NSNumber numberWithInt:2],  //trigger
//                            [NSNumber numberWithInt:-1],  //allowed fail count
//                            @"/vault/Intelli_Log",      //log directory
//                            [NSNumber numberWithBool:NO],      //Query previous station?
//                            @"ICT",                         //Query stations' name
//                            @".................",           //SN1 format
//                            @"",                            //SN2 format
//                            @"",                            //SN3 format
//                            @"",                            //SN4 format
//                            @"",                            //SN5 format
//                            @"",                            //SN6 format
//                            @"START",                       //Trigger String
//                            @"0",                           //Automation Mode
//                            [NSNumber numberWithBool:NO],  //EEEECode
//                            @"",                           //Automation Mode
//                            [NSNumber numberWithInt:1],     //Pudding Blob
//                            [NSNumber numberWithInt:1],     //Pudding Uart Blob
//                            [NSNumber numberWithInt:1],     //Pudding TestFlow Blob
//                            [NSNumber numberWithInt:1],     //Remove Local Blob
//                            [NSNumber numberWithInt:0],     //PDCA priority
//                            nil];
//    
//    if (!CTestContext::m_dicConfiguration)  //use default value
//    {
//        [CTestContext::m_dicConfiguration release];
//        CTestContext::m_dicConfiguration = [[NSMutableDictionary dictionaryWithObjects:arrDefault forKeys:arrkey] retain];
//    }
//    else {  //double check the default value
//        for (int i=0; i<[arrkey count]; i++) {
//            if (![CTestContext::m_dicConfiguration objectForKey:[arrkey objectAtIndex:i]])  //couldn't find the key then use default
//            {
//                [CTestContext::m_dicConfiguration setValue:[arrDefault objectAtIndex:i] forKey:[arrkey objectAtIndex:i]];
//            }
//        }
//    }
//    
//    //reinitial enable all the dut
//    [CTestContext::m_dicConfiguration setValue:[NSNumber numberWithInt:1] forKey:@kEngineUUT0Enable];
//    [CTestContext::m_dicConfiguration setValue:[NSNumber numberWithInt:1] forKey:@kEngineUUT1Enable];
//    [CTestContext::m_dicConfiguration setValue:[NSNumber numberWithInt:1] forKey:@kEngineUUT2Enable];
//    [CTestContext::m_dicConfiguration setValue:[NSNumber numberWithInt:1] forKey:@kEngineUUT3Enable];
//    [CTestContext::m_dicConfiguration setValue:[NSNumber numberWithInt:1] forKey:@kEngineUUT4Enable];
//    [CTestContext::m_dicConfiguration setValue:[NSNumber numberWithInt:1] forKey:@kEngineUUT5Enable];
//    
//    //Restore Fixture ID
//    if (strFixtureID)
//    {
//        [CTestContext::m_dicConfiguration setValue:strFixtureID forKey:kConfigFixtureID];
//    }
//    
//    bool tmpFlag = [[CTestContext::m_dicConfiguration valueForKey:kConfigTriggerType] intValue]!=1;
//    [btStart setEnabled:tmpFlag];
//    if (!tmpFlag)
//        [btStart setTitle:@"Auto"];
//    else
//        [btStart setTitle:@"Start(F5)"];
//}
//
////save configuration into config.plist file.
//-(void)SaveConfig:(NSString *)fileConfig
//{
//    NSString *config_dir  = [[PathManager sharedManager] configPath];
//    [CTestContext::m_dicConfiguration writeToFile:[config_dir stringByAppendingPathComponent:fileConfig] atomically:YES];
//    
//    //Create LogDir
//    @try {
//        NSString * path = [CTestContext::m_dicConfiguration valueForKey:kConfigLogDir];
//        NSError * err;
//        if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err])
//        {
//            NSRunAlertPanel(@"Create Logpath failed!", @"%@", @"OK", nil, nil,[err description]);
//        }
//    }
//    @catch (NSException *exception) {
//        NSRunAlertPanel([exception name], @"%@", @"OK", nil, nil,[exception reason]);
//    }
//    @finally {
//    }
//}
//
//
//#pragma mark User Interface Update entry function
//
////User Interface
//-(int) OnTestStart:(id)sender
//{
//    //reinitial...
//    IsRetest = NO;
//    
//    NSDictionary * dic = (NSDictionary *)sender;
//    int iID = [[dic objectForKey:@"id"] intValue];
//    NSTextField * txt[] = {textUUT1,textUUT2,textUUT3,textUUT4,textUUT5,textUUT6};
//    [txt[iID] setBackgroundColor:crRUN];
//    //show serial numer
//    CTestContext * pContext = (CTestContext *)[m_pTestEngine GetTestContext:iID];
//    NSString * strMLB = [pContext->m_dicContext valueForKey:kContextMLBSN];
//    if ([strMLB length]==0)
//    {
//        strMLB = [NSString stringWithFormat:@"UUT%d",iID+1];
//    }
//    NSString * strCFG = [pContext->m_dicContext valueForKey:kContextCFG];
//    if ([strCFG length]==0)
//    {
//        strCFG = @"Testing";
//    }
//    [txt[iID] setStringValue:[NSString stringWithFormat:@"%@\r\n%@",strMLB,strCFG]];
//    
//    //Intial UI to prepare test...
//    long index = 0;
//    TestItem * pItem= nil;
//    while (1) {
//        id item = [[outlineView itemAtRow:index++]representedObject];
//        if (!item) break;
//        if ([item isKindOfClass:[KeyItem class]]) continue;
//        pItem =(TestItem *)item;
//        pItem.uut1_value=pItem.uut2_value=pItem.uut3_value=pItem.uut4_value=pItem.uut5_value=pItem.uut6_value=pItem.uut7_value=pItem.uut8_value=@"";
//        pItem.state1=pItem.state2=pItem.state3=pItem.state4=pItem.state5=pItem.state6=pItem.state7=pItem.state8=-1; //idle
//        pItem.time=@"";
//    }
//    [outlineView setNeedsDisplay];
//    
//    NSButton * button[]={btUUT1,btUUT2,btUUT3,btUUT4,btUUT5,btUUT6};
//    [button[iID] setEnabled:NO];
//    
//    //start timer
//    uut_startTime[iID] =[[NSDate date]timeIntervalSince1970];
//    NSProgressIndicator * progressIndicator[]={progressUUT1,progressUUT2,progressUUT3,progressUUT4,progressUUT5,progressUUT6};
//    [progressIndicator[iID] startAnimation:nil];
//    
//    
//    //Save Start time
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString * strStartTime=[dateFormatter stringFromDate:[NSDate date]];
//    [pContext->m_dicContext setValue:strStartTime forKey:kContextStartTime];
//    [dateFormatter release];
//    
//    
//    //record
//    [m_dicTestResult removeObjectForKey:[NSString stringWithFormat:@"fail_item_%d",iID]];
//    [m_dicTestResult removeObjectForKey:[NSString stringWithFormat:@"fail_groups_%d",iID]];
//    [textPromptLog setString:@""];
//    
//    m_strFirstFailItem[iID]=nil;
//    
//    return 0;
//}
//-(int) OnTestStop:(id)sender
//{
//    NSDictionary * dic = (NSDictionary *)sender;
//    int iID = [[dic objectForKey:@"id"] intValue];
//    NSTextField * txt[] = {textUUT1,textUUT2,textUUT3,textUUT4,textUUT5,textUUT6};
//    [txt[iID] setBackgroundColor:crERROR];
//    //[txt[iID] setStringValue:@"ABORT"];
//    
//    //ui update
//    NSProgressIndicator * progressIndicator[]={progressUUT1,progressUUT2,progressUUT3,progressUUT4,progressUUT5,progressUUT6};
//    //    [progress startAnimation:nil];
//    [progressIndicator[iID] stopAnimation:nil];
//    NSButton * button[]={btUUT1,btUUT2,btUUT3,btUUT4,btUUT5,btUUT6};
//    [button[iID] setEnabled:YES];
//    
//    //Show message in the prompt log
//    NSString * strKey = [NSString stringWithFormat:@"fail_item_%d",iID];
//    NSMutableString * str = [m_dicTestResult valueForKey:strKey];
//    if (!str)
//    {
//        str=[NSMutableString string];
//        [m_dicTestResult setValue:str forKey:strKey];
//    }
//    [str appendString:@"Abort"];
//    [self ShowResultDetail:m_dicTestResult];
//    
//    
//    DEBUG_CMD = DEBUG_DISABLE;      //reset debug state;
//    
//    return 0;
//}
//-(int) OnTestPasue:(id)sender
//{
//    return 0;
//}
//-(int) OnTestResume:(id)sender
//{
//    return 0;
//}
//
//- (void) scrollOutlineViewTimer:(NSTimer*) timer
//{
//    static int lastScrollIndex = -1;
//    @synchronized(outlineView)
//    {
//        if (lastScrollIndex != scrollIndex)
//        {
//            [outlineView scrollRowToVisible:scrollIndex+1];
//            [outlineView setNeedsDisplay];
//        }
//        lastScrollIndex = scrollIndex;
//    }
//}
//-(int) OnTestItemStart:(id)sender
//{
//    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc]init];
//    
//    NSMutableDictionary * dicItem = (NSMutableDictionary *)sender;
//    
//    int index=[[dicItem valueForKey:@"index"] intValue];
//    int iID = [[dicItem valueForKey:@"id"]intValue];
//    
//    id item = [[outlineView itemAtRow:index] representedObject];
//    if ([item isKindOfClass:[TestItem class]]) {
//        TestItem * t = (TestItem *)item;
//        switch (iID) {
//            case 0:
//                t.uut1_value = @"Testing...";
//                break;
//            case 1:
//                t.uut2_value = @"Testing...";
//                break;
//            case 2:
//                t.uut3_value = @"Testing...";
//                break;
//            case 3:
//                t.uut4_value = @"Testing...";
//                break;
//            case 4:
//                t.uut5_value = @"Testing...";
//                break ;
//            case 5:
//                t.uut6_value = @"Testing...";
//                break ;
//            case 6:
//                t.uut7_value = @"Testing...";
//                break ;
//            case 7:
//                t.uut8_value = @"Testing...";
//                break ;
//            default:
//                break;
//        }
//        if ([btnShowTests state] == NSOnState)
//        {
//            @synchronized(outlineView)
//            {
//                scrollIndex = index;
//                if (!scrollOutlineViewTaskTimer)
//                {
//                    scrollOutlineViewTaskTimer = [NSTimer scheduledTimerWithTimeInterval:2
//                                                                                  target:self
//                                                                                selector:@selector(scrollOutlineViewTimer:)
//                                                                                userInfo:nil
//                                                                                 repeats:YES];
//                }
//            }
//            //            [outlineView scrollRowToVisible:index+1];
//            //            [outlineView setNeedsDisplay];
//        }
//    }
//    
//    [self ItemTimerStart:[outlineView itemAtRow:index]];
//    
//    [pool release];
//    return 0;
//}
//-(int) OnTestItemFinish:(id)sender
//{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    
//    NSMutableDictionary * dicItem = (NSMutableDictionary *)sender;
//    int index=[[dicItem valueForKey:@"index"] intValue];
//    int iID = [[dicItem valueForKey:@"id"] intValue];
//    
//    NSString* value = [dicItem valueForKey:@"value"];
//    
//    id item = [[outlineView itemAtRow:index] representedObject];
//    int state = [[dicItem valueForKey:@"state"] intValue];
//    
//    if ([item isKindOfClass:[TestItem class]]) {
//        TestItem * t = (TestItem *)item;
//        switch (iID) {
//            case 0:
//                t.uut1_value = value;
//                t.state1 = state;
//                break;
//            case 1:
//                t.uut2_value = value;
//                t.state2 = state;
//                break;
//            case 2:
//                t.uut3_value = value;
//                t.state3 = state;
//                break;
//            case 3:
//                t.uut4_value = value;
//                t.state4 = state;
//                break;
//            case 4:
//                t.uut5_value = value;
//                t.state5 = state;
//                break;
//            case 5:
//                t.uut6_value = value;
//                t.state6 = state;
//                break;
//            case 6:
//                t.uut7_value = value;
//                t.state7 = state;
//                break;
//            case 7:
//                t.uut8_value = value;
//                t.state8 = state;
//                break;
//            default:
//                break;
//        }
//        //[outlineView scrollRowToVisible:index+1];
//        //[outlineView setNeedsDisplay];
//        
//        //record
//        if (!state)
//        {
//            NSString * fail_item_key   = [NSString stringWithFormat:@"fail_item_%d",iID];
//            NSString * fail_groups_key = [NSString stringWithFormat:@"fail_groups_%d",iID];
//            
//            NSMutableString *str = [m_dicTestResult valueForKey:fail_item_key];
//            NSMutableArray  *arr = [m_dicTestResult valueForKey:fail_groups_key];
//            
//            if (!str) str = [NSMutableString string];
//            if (!arr) arr = [NSMutableArray array];
//            
//            [str appendFormat:@"%@,%@   ",t.index,t.description];
//            if (![arr containsObject:t.group]) {
//                [arr addObject:t.group];
//            }
//            
//            [m_dicTestResult setValue:str forKey:fail_item_key];
//            [m_dicTestResult setValue:arr forKey:fail_groups_key];
//            
//            [self ShowResultDetail:m_dicTestResult];
//            
//            if (!m_strFirstFailItem[iID]) //first fail item
//            {
//                m_strFirstFailItem[iID] = [str copy];
//            }
//        }
//    }
//    [self ItemTimerStop:[outlineView itemAtRow:index]];
//    [pool release];
//    return 0;
//}
-(int) OnTestFinish:(id)sender
{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    
//    NSMutableDictionary * dic = (NSMutableDictionary *)sender;
//    int iID = [[dic objectForKey:@"id"]intValue];
//    int states = [[dic objectForKey:@"states"]intValue];
//    NSTextField * txt[] = {textUUT1,textUUT2,textUUT3,textUUT4,textUUT5,textUUT6};
//    [txt[iID] setBackgroundColor:(states?crPASS:crFAIL)];
//    
//    m_TestResult[iID] = states;
//    //Stop timer...
//    uut_startTime[iID] =0;
//    CTestContext * pContext[]={pTestContext0,pTestContext1,pTestContext2,pTestContext3,pTestContext4,pTestContext5};
//    
//    //Need update pass/fail message on uut title.
//    if (![[CTestContext::m_dicConfiguration valueForKey:kConfigScanBarcode] boolValue])
//    {
//        NSString * str = [NSString stringWithFormat:@"UUT%d\r\n%@",iID+1,states?@"PASS":@"FAIL"];
//        [txt[iID] setStringValue:str];
//    }else
//    {
//        NSString * SN=[pContext[iID]->m_dicContext valueForKey:kContextMLBSN];
//        NSString * str = [NSString stringWithFormat:@"%@\r\n%@",SN,states?@"PASS":@"FAIL"];
//        [txt[iID] setStringValue:str];
//    }
//    
//    
//    
//    //Save Stop time
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString * strStartTime=[dateFormatter stringFromDate:[NSDate date]];
//    [pContext[iID]->m_dicContext setValue:strStartTime forKey:kContextStopTime];
//    [dateFormatter release];
//    
//    
//    NSTextField * textElapsedTime[]={textElapsedTimeUUT1,textElapsedTimeUUT2,textElapsedTimeUUT3,textElapsedTimeUUT4,textElapsedTimeUUT5,textElapsedTimeUUT6};
//    [pContext[iID]->m_dicContext setValue:[textElapsedTime[iID] stringValue] forKey:kContextTotalTime];
//    
//    
//    //ui update
//    NSProgressIndicator * progressIndicator[]={progressUUT1,progressUUT2,progressUUT3,progressUUT4,progressUUT5,progressUUT6};
//    //    [progress startAnimation:nil];
//    [progressIndicator[iID] stopAnimation:nil];
//    NSButton * button[]={btUUT1,btUUT2,btUUT3,btUUT4,btUUT5,btUUT6};
//    [button[iID] setEnabled:YES];
//    
//    [scrollOutlineViewTaskTimer invalidate];
//    scrollOutlineViewTaskTimer = nil;
//    
//    //update test statics
//    int pass_count = [textPass intValue];
//    int fail_count = [textFail intValue];
//    if (states)
//    {
//        pass_count++;
//    }
//    else {
//        fail_count++;
//    }
//    [textPass setIntValue:pass_count];
//    [textFail setIntValue:fail_count];
//    [textPassRate setStringValue:[NSString stringWithFormat:@"%.3f%%",(double)pass_count/(double)(pass_count+fail_count)*100]];
//    [textFailRate setStringValue:[NSString stringWithFormat:@"%.3f%%",(double)fail_count/(double)(pass_count+fail_count)*100]];
//    
//    //record
//    if (states) //pass
//    {
//        NSString * strKey = [NSString stringWithFormat:@"fail_item_%d",iID];
//        NSMutableString * str = [m_dicTestResult valueForKey:strKey];
//        if (!str)
//        {
//            str=[NSMutableString string];
//            [m_dicTestResult setValue:str forKey:strKey];
//        }
//        [str appendString:@"PASS"];
//        [self ShowResultDetail:m_dicTestResult];
//    }
//    else
//    {
//        TestFailListPanelDelegate * tp = (TestFailListPanelDelegate *)[panelFailList delegate];
//        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:m_strFirstFailItem[iID],kFailListItem,[pContext[iID]->m_dicContext valueForKey:kContextMLBSN],kFailListSN, nil];
//        [tp AddRecord:dic];
//        [m_strFirstFailItem[iID] release];
//    }
//    
//    DEBUG_CMD = DEBUG_DISABLE;      //reset debug state;
//    [pool release];
//    
//    //
//    [self SaveItemTime:iID];
//    
//    m_TestResult[iID] = -1;  //error
    return 0;
}
//-(int) OnTestError:(id)sender
//{
//    NSMutableDictionary * dic = (NSMutableDictionary *)sender;
//    int iID = [[dic objectForKey:@"id"]intValue];
//    NSString * strmsg=[dic objectForKey:@"msg"];
//    NSTextField * txt[] = {textUUT1,textUUT2,textUUT3,textUUT4,textUUT5,textUUT6};
//    
//    CTestContext * pContext = (CTestContext *)[m_pTestEngine GetTestContext:iID];
//    NSString * strMLB = [pContext->m_dicContext valueForKey:kContextMLBSN];
//    if ([strMLB length]==0)
//    {
//        strMLB = [NSString stringWithFormat:@"UUT%d",iID+1];
//    }
//    NSString * strCFG = @"Error";
//    [txt[iID] setStringValue:[NSString stringWithFormat:@"%@\r\n%@",strMLB,strCFG]];
//    
//    [txt[iID] setBackgroundColor:crERROR];
//    
//    uut_startTime[iID] =0;
//    NSProgressIndicator * progressIndicator[]={progressUUT1,progressUUT2,progressUUT3,progressUUT4,progressUUT5,progressUUT6};
//    [progressIndicator[iID] stopAnimation:nil];
//    
//    NSButton * button[]={btUUT1,btUUT2,btUUT3,btUUT4,btUUT5,btUUT6};
//    [button[iID] setEnabled:YES];
//    
//    DEBUG_CMD = DEBUG_DISABLE;      //reset debug state;
//    NSRunAlertPanel([NSString stringWithFormat:@"UUT%d",iID+1], @"%@", @"OK", nil, nil, strmsg);
//    
//    NSString * strKey = [NSString stringWithFormat:@"fail_item_%d",iID];
//    NSMutableString * str = [m_dicTestResult valueForKey:strKey];
//    if (!str)
//    {
//        str=[NSMutableString string];
//        [m_dicTestResult setValue:str forKey:strKey];
//    }
//    [str appendString:@"Error"];
//    [self ShowResultDetail:m_dicTestResult];
//    return 0;
//}
//
//#pragma mark timer
//-(void)UpdateElapsedTime:(id)arg
//{
//    NSTextField * txtElapsedTime[] = {textElapsedTimeUUT1,textElapsedTimeUUT2,textElapsedTimeUUT3,textElapsedTimeUUT4,textElapsedTimeUUT5,textElapsedTimeUUT6};
//    int index=[[arg objectForKey:@"index"] intValue];
//    NSString * strtimes=[arg objectForKey:@"times"];
//    [txtElapsedTime[index] setStringValue:strtimes];
//}
//- (void)timerFireMethod:(NSTimer*)theTimer
//{
//    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
//    
//    for (int i=0; i<=5; i++) {
//        if (uut_startTime[i]!=0) {
//            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:i],@"index",[NSString stringWithFormat:@"%.03f",now-uut_startTime[i]],@"times", nil];
//            //[self performSelectorOnMainThread:@selector(UpdateElapsedTime:) withObject:dic waitUntilDone:YES];
//            [self UpdateElapsedTime:dic];
//        }
//    }
//}
//
//#pragma mark test item timer
//static NSTimeInterval item_start_time = 0;
//id currItem=nil;
//-(int)ItemTimerStart:(id)item
//{
//    if (item_start_time==0) //first item
//    {
//        item_start_time = [[NSDate date] timeIntervalSince1970];
//    }
//    currItem = item;
//    return 0;
//}
//
//-(void)ReloadItem:(id)item
//{
//    [outlineView reloadItem:item];
//}
//
//-(int)ItemTimerStop:(id)item
//{
//    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
//    NSString * str = [NSString stringWithFormat:@"%.3f",now-item_start_time];
//    
//    id it = [currItem representedObject];
//    if ([it isKindOfClass:[TestItem class]]) {
//        TestItem * t = (TestItem *)it;
//        [t setValue:str forKey:@"time"];
//    }
//    
//    [self performSelectorOnMainThread:@selector(ReloadItem:) withObject:currItem waitUntilDone:NO];
//    
//    //prepare for next test item
//    //item_start_time=0;
//    item_start_time = [[NSDate date] timeIntervalSince1970];
//    NSInteger row = [outlineView rowForItem:item];
//    currItem = [outlineView itemAtRow:row+1];
//    //currItem = item;
//    return 0;
//}
//
//
//- (void)ItemElapsedTimer:(NSTimer*)theTimer
//{
//    if (!currItem) return;  //no specail item
//    if (item_start_time)
//    {
//        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
//        NSString * str = [NSString stringWithFormat:@"%.3f",now-item_start_time];
//        
//        id it = [currItem representedObject];
//        if ([it isKindOfClass:[TestItem class]]) {
//            TestItem * t = (TestItem *)it;
//            [t setValue:str forKey:@"time"];
//        }
//        
//        //        [outlineView reloadItem:currItem];
//        
//        if ([btnShowTests state] == NSOnState)
//        {
//            // schedule outlineView to update.
//            if (!outlineViewUpdateTimer)
//            {
//                [self performSelectorOnMainThread:@selector(scheduleOutlineViewUpdateTimer)
//                                       withObject:nil
//                                    waitUntilDone:NO ];
//            }
//        }
//    }
//}
//
//- (void) scheduleOutlineViewUpdateTimer
//{
//    @synchronized(self)
//    {
//        if (!outlineViewUpdateTimer)
//        {
//            outlineViewUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
//                                                                      target:self
//                                                                    selector:@selector(reloadOutlineView)
//                                                                    userInfo:nil
//                                                                     repeats:NO];
//        }
//    }
//}
//- (void) reloadOutlineView
//{
//    static NSTimeInterval lastReload = 0;
//    
//    // Make sure we have a minimum interval between reload.  Reloading view too frequently is (CPU time) expensive.
//    
//    outlineViewUpdateTimer = nil;
//    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
//    if (lastReload > 0.6)
//    {
//        // [outlineView reloadData]; // try to not reload... to see if we have good value.  reload is expesnive!
//        [outlineView setNeedsDisplay:YES];
//    }
//    lastReload = now;
//}
//
//-(void)SaveItemTime:(int)soltid
//{
//#define TIME_FILE   @"Test_Time_panel%d.txt"
//#define STR_LEN     30
//    int index=1;
//    int row=0;
//    NSMutableString * strbuf=[NSMutableString new];
//    while (1) {
//        id item = [outlineView itemAtRow:row++];
//        if (!item) break;
//        id it = [item representedObject];
//        if ([it isKindOfClass:[TestItem class]]) {
//            TestItem * t = (TestItem *)it;
//            NSString * str = t.time;
//            if (!str) continue;
//            if ([str length]==0) continue;
//            str = t.description;
//            
//            str = [str stringByPaddingToLength:STR_LEN withString:@" " startingAtIndex:0];
//            
//            [strbuf appendFormat:@"%@, %@,\t %@\r\n",[[NSString stringWithFormat:@"%d",index++] stringByPaddingToLength:4 withString:@" " startingAtIndex:0],str,t.time];
//        }
//    }
//    
//    
//    NSString * path = [NSString stringWithFormat:TIME_FILE,soltid];
//    NSString * str = [[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:path];
//    NSError * err;
//    if (![strbuf writeToFile:str atomically:YES encoding:NSASCIIStringEncoding error:&err])
//    {
//    }
//}
//
#pragma mark PROFILE_ANALYZER
-(int)LoadProfile:(NSString *)fileProfile
{
    //get absoule path;
    NSString * profile = fileProfile;
    [winMain setTitle:profile];
    if (![profile isAbsolutePath])
    {
        profile = [[NSBundle mainBundle] bundlePath];
        profile = [profile stringByDeletingLastPathComponent];
        profile = [profile stringByAppendingPathComponent:@"profile"];
        profile = [profile stringByAppendingPathComponent:fileProfile];
    }
    
    NSString * fileExtern = [[profile pathExtension] uppercaseString];
    if ([fileExtern isEqualToString:@"LUA"]||
        [fileExtern isEqualToString:@"PRF"]
        )
    {
        return [self LoadProfile_lua:profile];
    }
    else if ([fileExtern isEqualToString:@"SEQ"]) {
        return [self LoadProfile_Seq:profile];
    } else if ([fileExtern isEqualTo:@"IASEQ"]) {
        return [self loadSequenceBundle:fileProfile];
    }
    return 0;
}

- (NSString*) autoLoadProfile
{
//    NSString * stationType = [CTestContext::m_dicGlobal objectForKey:kContextStationType];//[CTestContext::m_dicConfiguration objectForKey:kContextStationType];
//    if (stationType)
//    {
//        NSString * applicationPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
//        NSDictionary * autoLoadPlist = [NSDictionary dictionaryWithContentsOfFile:[applicationPath stringByAppendingPathComponent:@"AutoLoad.plist"]];
//        NSDictionary * tmLookUp = [autoLoadPlist objectForKey:@"Profile"];
//        
//        if (stationType && tmLookUp)
//        {
//            return [tmLookUp objectForKey:stationType];
//        }
//    }
    return  nil;
}

-(int)LoadProfile_lua:(NSString *) fileProfile
{
    @try {
        
        CScriptEngine * pScriptEngine=nil;
        int err = 0;
        /*
         -----------------------------------------------------------------------
         author:ZL Meng
         Date:Jul.17 2015
         Description:
         修改测试线程数从6个改成1个
         -----------------------------------------------------------------------
         */
        for (int i=0; i<UI_MODULE; i++) {
            pScriptEngine = (CScriptEngine *)[m_pTestEngine GetScripEngine:i];
            err = pScriptEngine->DoFile([fileProfile UTF8String]);
            if (err)
            {
                NSString * strError = [NSString stringWithUTF8String:lua_tostring(pScriptEngine->m_pLuaState, -1)];
                @throw [NSException exceptionWithName:@"Lua Error" reason:strError userInfo:nil];
            }
        }
        
        lua_State  * lua = pScriptEngine->m_pLuaState;
        
        lua_getglobal(lua, "Module");     //Module Name
        const char * szModule = lua_tostring(lua, -1);
        if (!szModule)
        {
            szModule = "No specical the module name";
        }
        [textModule setStringValue:[NSString stringWithUTF8String:szModule]];
        
        lua_getglobal(lua, "Version");    //Version
        const char * szVersion = lua_tostring(lua, -1);
        if (!szVersion)
        {
            szVersion = "TM.V1.0.0.0";
        }
        [textVersion setStringValue:[NSString stringWithUTF8String:szVersion]];
        
        //Get global function        lua_getglobal(pScriptEngine->m_pLuaState, "LoadProfile");
        err = lua_pcall(pScriptEngine->m_pLuaState, 0, 1, 0);
        if (err)
        {
            NSString * strError = [NSString stringWithUTF8String:lua_tostring(pScriptEngine->m_pLuaState, -1)];
            @throw [NSException exceptionWithName:@"Lua Error" reason:strError userInfo:nil];
        }
        
        //Read Result
        const char * szItem = lua_tostring(pScriptEngine->m_pLuaState, -1);
        NSTreeNode * items = [self ParseTestItems:[NSString stringWithUTF8String:szItem]];
        
        //Post notificaiton to updata user interface.
        [[NSNotificationCenter defaultCenter]postNotificationName:@kNotificationReloadProfile object:self userInfo:[NSDictionary dictionaryWithObject:items forKey:@"items"]];
        
        //Save profile file path name
//        [CTestContext::m_dicConfiguration setValue:fileProfile forKey:kConfigProfilePath];
        
        
    }
    @catch (NSException *exception) {
        NSRunAlertPanel(@"Load Error", @"%@", @"OK", nil, nil, [exception description]);
    }
    return 0;
}
//
-(int)LoadProfile_Seq:(NSString *)filepath
{
    NSString * fileName = [filepath stringByDeletingPathExtension];
    
    NSString * profile = [fileName stringByAppendingPathExtension:@"imp"];
    
    int ret;
    if (![[NSFileManager defaultManager] fileExistsAtPath:profile])
    {
        NSRunAlertPanel(@"Load Implementation File", @"Warnning : Couldn't load implementation file, file not exist!", @"OK", nil, nil);
    }
    else
    {
        ret = [self LoadTestImplementation:profile];
        if (ret <0) return ret;
    }
    
    ret = [self LoadTestSequence:filepath];
    
    return ret;
}


-(int)LoadTestSequence:(NSString *)fileSequence
{
    @try {
        CScriptEngine * pScriptEngine=nil;
        int err = 0;
        /*
         -----------------------------------------------------------------------
         author:ZL Meng
         Date:Jul.17 2015
         Description:
         修改测试线程数从6个改成1个
         -----------------------------------------------------------------------
         */
        for (int i=0; i<UI_MODULE; i++) {
            pScriptEngine = (CScriptEngine *)[m_pTestEngine GetScripEngine:i];
            err = pScriptEngine->DoFile([fileSequence UTF8String]);
//            if (err)
//            {
//                NSString * strError = [NSString stringWithUTF8String:lua_tostring(pScriptEngine->m_pLuaState, -1)];
//                @throw [NSException exceptionWithName:@"Lua Error" reason:strError userInfo:nil];
//            }
        }
        
        lua_State  * lua = pScriptEngine->m_pLuaState;
        
        lua_getglobal(lua, "__Module");     //Module Name
        const char * szModule = lua_tostring(lua, -1);
        if (!szModule)
        {
            lua_getglobal(lua, "Module");     //Module Name
            szModule = lua_tostring(lua, -1);
            if (!szModule)
            {
                szModule = "No specical the module name";
            }
        }
//        [textModule setStringValue:[NSString stringWithUTF8String:szModule]];
        
//        lua_getglobal(lua, "__Version");    //Version
//        const char * szVersion = lua_tostring(lua, -1);
//        if (!szVersion)
//        {
//            lua_getglobal(lua, "Version");    //Version
//            szVersion = lua_tostring(lua, -1);
//            if (!szVersion)
//            {
//                szVersion = "TM.V1.0.0.0";
//            }
//        }
//        [textVersion setStringValue:[NSString stringWithUTF8String:szVersion]];
        
        //Get global function
        lua_getglobal(pScriptEngine->m_pLuaState, "LoadProfile");
        err = lua_pcall(pScriptEngine->m_pLuaState, 0, 1, 0);
//        if (err)
//        {
//            NSString * strError = [NSString stringWithUTF8String:lua_tostring(pScriptEngine->m_pLuaState, -1)];
//            @throw [NSException exceptionWithName:@"Script Error" reason:strError userInfo:nil];
//        }
        
        //Read Result
        const char * szItem = lua_tostring(pScriptEngine->m_pLuaState, -1);
        NSTreeNode * items = [self ParseTestItems:[NSString stringWithUTF8String:szItem]];
        
        //Post notificaiton to updata user interface.
        [[NSNotificationCenter defaultCenter]postNotificationName:@kNotificationReloadProfile object:self userInfo:[NSDictionary dictionaryWithObject:items forKey:@"items"]];
        
        //Save profile file path name
//        [CTestContext::m_dicConfiguration setValue:fileSequence forKey:kConfigProfilePath];
    }
    @catch (NSException *exception) {
        NSRunAlertPanel(@"Load Error", @"%@", @"OK", nil, nil, [exception description]);
        return -1;
    }
    @finally {
    }
    return 0;
}

-(int)LoadTestImplementation:(NSString *)fileSequence
{
    @try {
        CScriptEngine * pScriptEngine=nil;
        int err = 0;
        /*
         -----------------------------------------------------------------------
         author:ZL Meng
         Date:Jul.17 2015
         Description:
         修改测试线程数从6个改成1个
         -----------------------------------------------------------------------
         */
        for (int i=0; i<UI_MODULE; i++) {
            pScriptEngine = (CScriptEngine *)[m_pTestEngine GetScripEngine:i];
            err = pScriptEngine->DoFile([fileSequence UTF8String]);
            if (err)
            {
                NSString * strError = [NSString stringWithUTF8String:lua_tostring(pScriptEngine->m_pLuaState, -1)];
                @throw [NSException exceptionWithName:@"Script Error" reason:strError userInfo:nil];
            }
        }
    }
    @catch (NSException *exception) {
        NSRunAlertPanel(@"Load Error", @"%@", @"OK", nil, nil, [exception description]);
        return -1;
    }
    @finally {
        
    }
    return 0;
}
//
//
//Parse test item from the script files.
-(NSTreeNode *)ParseTestItems:(NSString *) strItems
{
    // We will use the built-in NSTreeNode with a representedObject that is our model object - the SimpleNodeData object.
    // First, create our model object.
    NSString *nodeName = @"root_item";
    KeyItem *nodeData = [KeyItem nodeDataWithName:nodeName];
    // The image for the nodeData is lazily filled in, for performance.
    NSTreeNode *result = [NSTreeNode treeNodeWithRepresentedObject:nodeData];
    
    NSArray * steps = [strItems componentsSeparatedByString:@"\n"];     //lines
    NSTreeNode * keyTreeNode=nil;
    for (NSString * item in steps){
        item = [item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray * contents = [item componentsSeparatedByString:@"\t"];  //
        if ([[contents objectAtIndex:0] isEqualToString:@"key"])    //KeyItem;
        {
            KeyItem * keyNodeData = [[KeyItem alloc] initWithName:[contents objectAtIndex:1]];
            keyTreeNode = [NSTreeNode treeNodeWithRepresentedObject:keyNodeData];
            [keyNodeData release];
            [[result mutableChildNodes]addObject:keyTreeNode];      //add to the root tree
        }
        else    //test item
        {
            NSArray  *arr = [contents subarrayWithRange:NSMakeRange(1, [contents count]-1)];
            
            if ([contents count] < 2) {
                continue;
            }
            
            NSString *index       = [arr objectAtIndex:0];
            NSString *description = [arr objectAtIndex:1];
            NSString *lower       = [arr count] > 2 ? [arr objectAtIndex:2] : nil;
            NSString *upper       = [arr count] > 3 ? [arr objectAtIndex:3] : nil;
            NSString *unit        = [arr count] > 4 ? [arr objectAtIndex:4] : nil;
            NSString *testkey     = [arr count] > 6 ? [arr objectAtIndex:6] : nil;
            
            BOOL waiver = NO;
            if ([arr count] > 7)
            {
                waiver = [[arr objectAtIndex:7] isEqualToString:@"waiver"];
            }
            
            
            TestItem * itemNodeData = [[TestItem new] autorelease];
            
            itemNodeData.index       = index;
            itemNodeData.description = description;
            itemNodeData.lower       = lower;
            itemNodeData.upper       = upper;
            itemNodeData.unit        = unit;
            itemNodeData.group       = [[keyTreeNode representedObject] name];
            itemNodeData.testkey     = testkey;
            itemNodeData.waiver      = waiver;
            
            
            NSTreeNode *itemTreeNode = [NSTreeNode treeNodeWithRepresentedObject:itemNodeData];
            
            if (keyTreeNode)
            {
                [[keyTreeNode mutableChildNodes]addObject:itemTreeNode];    //add to current key item.
            }
            else {
                [[result mutableChildNodes]addObject:itemTreeNode];    //add to current key item.
            }
        }
    }
    return result;
}
//
//
//#pragma mark - Manuel's Document Bundle
//#define TEMP_LUA_VAR "__test_manager__suppport__allitems__"
//
//- (BOOL) beginLoad
//{
//    /*
//     -----------------------------------------------------------------------
//     author:ZL Meng
//     Date:Jul.17 2015
//     Description:
//     修改测试线程数从6个改成1个
//     -----------------------------------------------------------------------
//     */
//    for (int i = 0; i < UI_MODULE ; i++) {
//        CScriptEngine *pScriptEngine;
//        
//        pScriptEngine = (CScriptEngine *)[m_pTestEngine GetScripEngine:i];
//        
//        lua_createtable(pScriptEngine->m_pLuaState, 0, 0);
//        lua_setglobal(pScriptEngine->m_pLuaState, TEMP_LUA_VAR);
//        
//        lua_createtable(pScriptEngine->m_pLuaState, 0, 0);
//        lua_setglobal(pScriptEngine->m_pLuaState, "items");
//    }
//    
//    return true;
//}
//
- (BOOL) finalizeLoad
{
//    @try {
//        CScriptEngine * pScriptEngine=nil;
//        char const    * all_items;
//        /*
//         -----------------------------------------------------------------------
//         author:ZL Meng
//         Date:Jul.17 2015
//         Description:
//         修改测试线程数从6个改成1个
//         -----------------------------------------------------------------------
//         */
//        for (int i = 0; i < UI_MODULE ; i++) {
//            pScriptEngine = (CScriptEngine *)[m_pTestEngine GetScripEngine:i];
//            
//            lua_getglobal(pScriptEngine->m_pLuaState, TEMP_LUA_VAR);
//            lua_setglobal(pScriptEngine->m_pLuaState, "items");
//            
//            lua_createtable(pScriptEngine->m_pLuaState, 0, 0);
//            lua_setglobal(pScriptEngine->m_pLuaState, TEMP_LUA_VAR);
//            
//        }
//        
//        [self loadSequenceBundle_touch];
//        
//        for (int i = 0; i <= 0 ; i++) {
//            int err;
//            
//            pScriptEngine = (CScriptEngine *)[m_pTestEngine GetScripEngine:i];
//            
//            lua_getglobal(pScriptEngine->m_pLuaState, "LoadProfile");
//            lua_pushnil(pScriptEngine->m_pLuaState);
//            err = lua_pcall(pScriptEngine->m_pLuaState, 1, 1, 0);
//            if (err)
//            {
//                NSString * strError = [NSString stringWithUTF8String:lua_tostring(pScriptEngine->m_pLuaState, -1)];
//                @throw [NSException exceptionWithName:@"Script Error" reason:strError userInfo:nil];
//            }
//            
//            all_items = lua_tostring(pScriptEngine->m_pLuaState, -1);
//        }
//        
//        //        [self dbgPrintItems];
//        
//        NSTreeNode * items = [self ParseTestItems:[NSString stringWithUTF8String:all_items]];
//        
//        
//        //Post notificaiton to updata user interface.
//        [[NSNotificationCenter defaultCenter]postNotificationName:@kNotificationReloadProfile object:self userInfo:[NSDictionary dictionaryWithObject:items forKey:@"items"]];
//        
        return YES;
//    }
//    @catch (NSException *exception) {
//        NSRunAlertPanel(@"Load Error", @"%@", @"OK", nil, nil, [exception description]);
//        return -1;
//    }
//    @finally {
//    }
}
//
-(BOOL)loadSequenceBundle_impfile:(NSString *)impfile
{
    @try {
        CScriptEngine *pScriptEngine = nil;
        /*
         -----------------------------------------------------------------------
         author:ZL Meng
         Date:Jul.17 2015
         Description:
         修改测试线程数从6个改成1个
         -----------------------------------------------------------------------
         */
        for (int i= 0; i<UI_MODULE; i++) {
            int err;
            
            pScriptEngine = (CScriptEngine *)[m_pTestEngine GetScripEngine:i];
            
            err = pScriptEngine->DoFile([impfile UTF8String]);
            
            if (err) {
                NSString * strError = [NSString stringWithUTF8String:lua_tostring(pScriptEngine->m_pLuaState, -1)];
                @throw [NSException exceptionWithName:@"Script Error" reason:strError userInfo:nil];
            }
        }
    }
    @catch (NSException *exception) {
        NSRunAlertPanel(@"Load Error", @"%@", @"OK", nil, nil, [exception description]);
        return NO;
    }
    
    return YES;
}
//
-(BOOL)loadSequenceBundle_seqfile:(NSString *)seqfile;
{
//    BOOL retval = YES;
//    
//    NSString *impfile = [[seqfile stringByDeletingPathExtension] stringByAppendingPathExtension:@"imp"];
//    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:impfile]) {
//        retval &= [self loadSequenceBundle_impfile:impfile];
//    }
//    
//    @try {
//        CScriptEngine * pScriptEngine=nil;
//        /*
//         -----------------------------------------------------------------------
//         author:ZL Meng
//         Date:Jul.17 2015
//         Description:
//         修改测试线程数从6个改成1个
//         -----------------------------------------------------------------------
//         */
//        for (int i = 0; i < UI_MODULE ; i++) {
//            int err;
//            
//            pScriptEngine = (CScriptEngine *)[m_pTestEngine GetScripEngine:i];
//            
//            err = pScriptEngine->DoFile([seqfile UTF8String]);
//            if (err) {
//                NSString * strError = [NSString stringWithUTF8String:lua_tostring(pScriptEngine->m_pLuaState, -1)];
//                @throw [NSException exceptionWithName:@"Lua Error" reason:strError userInfo:nil];
//            }
//            
//            
//            lua_getglobal(pScriptEngine->m_pLuaState, "Support__MergeTables");
//            lua_pushstring(pScriptEngine->m_pLuaState, [[[seqfile lastPathComponent] stringByDeletingPathExtension] UTF8String]);
//            lua_getglobal(pScriptEngine->m_pLuaState, TEMP_LUA_VAR);
//            lua_getglobal(pScriptEngine->m_pLuaState, "items");
//            
//            err = lua_pcall(pScriptEngine->m_pLuaState, 3, LUA_MULTRET, 0);
//            if (err) {
//                NSString * strError = [NSString stringWithUTF8String:lua_tostring(pScriptEngine->m_pLuaState, -1)];
//                @throw [NSException exceptionWithName:@"Lua Error" reason:strError userInfo:nil];
//            }
//            
//            lua_setglobal(pScriptEngine->m_pLuaState, TEMP_LUA_VAR);
//            
//        }
//        
//        return YES;
//    }
//    @catch (NSException *exception) {
//        NSRunAlertPanel(@"Load Error", @"%@", @"OK", nil, nil, [exception description]);
//        return NO;
//    }
//    
    return NO;
}
//
//- (BOOL) loadSequenceBundle_touch
//{
//    int err = 0;
//    for (int i = 0; i <= 5 ; i++) {
//        @try {
//            
//            CScriptEngine * pScriptEngine = (CScriptEngine *)[m_pTestEngine GetScripEngine:i];
//            
//            lua_getglobal(pScriptEngine->m_pLuaState, "ComposeTestKey");
//            if (lua_pcall(pScriptEngine->m_pLuaState, 0, 0, 0) != 0)
//            {
//                NSLog(@"error running function 'ComposeTestKey': %s", lua_tostring(pScriptEngine->m_pLuaState, -1));
//            }
//            
//            NSString * contents_dir = [self.loadedIndexPath stringByAppendingPathComponent:@"Contents"];
//            NSArray * contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:contents_dir error:nil];
//            
//            // Get all the limit files in directory.
//            NSMutableArray * limitFiles = [[NSMutableArray alloc] init];
//            for (NSString * aContent in contents)
//            {
//                if ([[aContent pathExtension] caseInsensitiveCompare:@"lim"] == NSOrderedSame)
//                {
//                    BOOL isDir = NO;
//                    NSString * limitFileFullPath = [contents_dir stringByAppendingPathComponent:aContent];
//                    if ([[NSFileManager defaultManager] fileExistsAtPath:limitFileFullPath isDirectory:&isDir] && !isDir)
//                    {
//                        [limitFiles addObject:limitFileFullPath];
//                    }
//                }
//            }
//            // Load them
//            for (NSString * limitfile in limitFiles)
//            {
//                lua_getglobal(pScriptEngine->m_pLuaState, "LoadSKULimitFile");
//                lua_pushstring(pScriptEngine->m_pLuaState, [limitfile UTF8String]);
//                if (lua_pcall(pScriptEngine->m_pLuaState, 1, 0, 0) != 0)
//                {
//                    NSLog(@"error running function `LoadSKULimitFile': %s", lua_tostring(pScriptEngine->m_pLuaState, -1));
//                }
//            }
//            
//            
//            // Get all the waiver files in directory.
//            NSMutableArray * waiverFiles = [[NSMutableArray alloc] init];
//            for (NSString * aContent in contents)
//            {
//                if ([[aContent pathExtension] caseInsensitiveCompare:@"wai"] == NSOrderedSame)
//                {
//                    BOOL isDir = NO;
//                    NSString * waiverFileFullPath = [contents_dir stringByAppendingPathComponent:aContent];
//                    if ([[NSFileManager defaultManager] fileExistsAtPath:waiverFileFullPath isDirectory:&isDir] && !isDir)
//                    {
//                        [waiverFiles addObject:waiverFileFullPath];
//                    }
//                }
//            }
//            // Load them
//            for (NSString * waiverfile in waiverFiles)
//            {
//                lua_getglobal(pScriptEngine->m_pLuaState, "LoadSKUWaiverFile");
//                lua_pushstring(pScriptEngine->m_pLuaState, [waiverfile UTF8String]);
//                if (lua_pcall(pScriptEngine->m_pLuaState, 1, 0, 0) != 0)
//                {
//                    NSLog(@"error running function `LoadSKUWaiverFile': %s", lua_tostring(pScriptEngine->m_pLuaState, -1));
//                }
//            }
//            
//            
//        }
//        @catch (NSException *exception) {
//            NSRunAlertPanel(@"Load Error", @"%@", @"OK", nil, nil, [exception description]);
//            return NO;
//        }
//    }
//    
//    [self dbgPrintItems];
//    
//    return YES;
//}
//
//- (void) dbgPrintItems
//{
//    for (int i = 0; i <= 0; i++) {
//        
//        CScriptEngine * pScriptEngine = (CScriptEngine *)[m_pTestEngine GetScripEngine:i];
//        
//        lua_getglobal(pScriptEngine->m_pLuaState, "tprint");
//        lua_getglobal(pScriptEngine->m_pLuaState, "items");
//        lua_pushnumber(pScriptEngine->m_pLuaState, 0);
//        if (lua_pcall(pScriptEngine->m_pLuaState, 2, 0, 0) != 0)
//        {
//            NSLog(@"error running function `PrintItems': %s", lua_tostring(pScriptEngine->m_pLuaState, -1));
//        }
//    }
//}
//
//
static bool monkey_proofed = true;
//
//- (void)clear_all:(id)sender
//{
//    if (self->m_CurrUser.Authority < AUTHORITY_OPERATOR) {
//        NSMenuItem *sheet_mitem = [toolsMenu itemWithTitle:@"Sheet Control"];
//        NSMenu     *sheet_menu  = [sheet_mitem submenu];
//        NSArray    *subitems    = [sheet_menu itemArray];
//        
//        for (int i= 0; i< [subitems count]; i++) {
//            [[subitems objectAtIndex:i] setState:false];
//        }
//        
//        monkey_proofed = false;
//        [self LoadProfile:[CTestContext::m_dicConfiguration valueForKey:@kEngineProfilePath]];
//    }
//}
//
//- (void)on_off:(id)sender
//{
//    bool state = [sender state];
//    
//    if (self->m_CurrUser.Authority < AUTHORITY_OPERATOR) {
//        state = !state;
//        
//        [sender setState:state];
//        
//        monkey_proofed = false;
//        [self LoadProfile:[CTestContext::m_dicConfiguration valueForKey:@kEngineProfilePath]];
//    }
//}
//
#define MONKEY_PROOFED 1

- (BOOL) loadSequenceBundle_internal:(NSString *)filename
{
    NSFileManager *fmgr = [NSFileManager defaultManager];
    
    NSString *index_file = [filename stringByAppendingPathComponent:@"index.plist"];
    NSString *contents_dir = [filename stringByAppendingPathComponent:@"Contents"];
    
    NSString *station_file = [filename stringByAppendingPathComponent:@"station.plist"];
    
    if ([fmgr fileExistsAtPath:station_file]) {
        // override use of index file with station.plist's mapping
        NSDictionary * station_index = [NSDictionary dictionaryWithContentsOfFile:station_file];
        
//        NSString * stationType = [CTestContext::m_dicGlobal objectForKey:kContextStationType];
//        if (station_index && stationType)
//        {
//            NSString * mappedIndex = [station_index objectForKey:stationType];
//            if (mappedIndex)
//            {
//                index_file = [filename stringByAppendingPathComponent:mappedIndex];
//            }
//            
//        }
    }
    
    if (![fmgr fileExistsAtPath:index_file]) {
        return NO;
    }
    
    BOOL dir_flag;
    
    if (![fmgr fileExistsAtPath:contents_dir isDirectory:&dir_flag] || (dir_flag!= YES)) {
        return NO;
    }
    
    id loaded_index =  [NSDictionary dictionaryWithContentsOfFile:index_file];
    
    if (![loaded_index isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    self.loadedIndexPath = filename;
    
    bool new_index  = ![self->last_loaded_index isEqualTo:loaded_index];
    NSMenu  *index_menu = new_index ? [[[NSMenu alloc] initWithTitle:@"Sheet Control"] autorelease] : nil;
    NSArray *sequence = [loaded_index objectForKey:@"Sequence"];
    BOOL     retval   = YES;
    
    [self beginLoad];
    
    if (index_menu) {
        NSMenuItem *submenuitem = [[NSMenuItem alloc] initWithTitle:@"Sheet Control" action:nil keyEquivalent:@""];
        NSMenuItem *old         = [toolsMenu itemWithTitle:@"Sheet Control"];
        
        if (old) {
            [toolsMenu removeItem:old];
        }
        
        [toolsMenu addItem:submenuitem];
        [toolsMenu setSubmenu:index_menu forItem:submenuitem];
        
        
        NSMenuItem *clear_all = [[[NSMenuItem alloc] initWithTitle:@"Clear all" action:@selector(clear_all:) keyEquivalent:@""] autorelease];
        NSMenuItem *separator = [NSMenuItem separatorItem];
        
        [clear_all setTarget:self];
        
        [index_menu addItem:clear_all];
        [index_menu addItem:separator];
    }
    
    for (id i in sequence) {
        NSString *name      = [i stringByDeletingPathExtension];
        NSString *extension = [[i pathExtension] uppercaseString];
        
        if (index_menu && [extension isEqualTo:@"SEQ"]) {
            NSMenuItem *mitem = [[NSMenuItem alloc] initWithTitle:name action:@selector(on_off:) keyEquivalent:@""];
            
            [mitem setTarget:self];
            [mitem setState:true];
            
            [index_menu addItem:mitem];
        }
    }
    
    [loaded_index retain];
    [self->last_loaded_index release];
    self->last_loaded_index = loaded_index;
    
    
    for (id i in sequence) {
        if (![i isKindOfClass:[NSString class]]) {
            retval = NO;
            continue;
        }
        
        NSString *file_to_load = [contents_dir stringByAppendingPathComponent:i];
        NSString *name         = [i stringByDeletingPathExtension];
        NSString *extension    = [[file_to_load pathExtension] uppercaseString];
        
        if ([extension isEqualTo:@"IMP"]) {
            retval &= [self loadSequenceBundle_impfile:file_to_load];
        } else if ([extension isEqualTo:@"LUA"]) {
            retval &= [self loadSequenceBundle_impfile:file_to_load];
        } else if ([extension isEqualTo:@"SEQ"]) {
            if ([[[[toolsMenu itemWithTitle:@"Sheet Control"] submenu] itemWithTitle:name] state] || monkey_proofed) {
                retval &= [self loadSequenceBundle_seqfile:file_to_load];
            }
        } else {
            NSRunAlertPanel(@"What you say?", @"Treating '%@; file as a Lua file", @"OK", nil, nil, i);
            retval &= [self loadSequenceBundle_impfile:file_to_load];
        }
    }
    
    monkey_proofed = true;
    
    NSString *modname    = [loaded_index objectForKey:@"Module"];
    NSString *modversion = [loaded_index objectForKey:@"Version"];
    
    modname = modname ? modname : @"Call me Ishmael";
    modversion = modversion ? modversion : @"3.14156";
    
    [textModule setStringValue:modname];
    [textVersion setStringValue:modversion];
    /*
     -----------------------------------------------------------------------
     author:ZL Meng
     Date:Jul.17 2015
     Description:
     修改测试线程数从6个改成1个
     -----------------------------------------------------------------------
     */
    for (int i = 0; i < UI_MODULE ; i++) {
        CScriptEngine *pScriptEngine;
        
        pScriptEngine = (CScriptEngine *)[m_pTestEngine GetScripEngine:i];
        
        lua_pushstring(pScriptEngine->m_pLuaState, [modname UTF8String]);
        lua_setglobal(pScriptEngine->m_pLuaState, "Module");
        
        lua_pushstring(pScriptEngine->m_pLuaState, [modversion UTF8String]);
        lua_setglobal(pScriptEngine->m_pLuaState, "Version");
        
        lua_pushinteger(pScriptEngine->m_pLuaState, i);
        lua_setglobal(pScriptEngine->m_pLuaState, "FixtureSlot");
        
        lua_pushstring(pScriptEngine->m_pLuaState, [[self->textFixtureID stringValue] UTF8String]);
    }
    
    retval &= [self finalizeLoad];
    
    
    //Save profile file path name
//    [CTestContext::m_dicConfiguration setValue:filename forKey:kConfigProfilePath];
    
    return retval;
}

- (int) loadSequenceBundle:(NSString *)filename
{
    BOOL retval;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
        retval = [self loadSequenceBundle_internal:filename];
    } else {
        NSBundle *mb = [NSBundle mainBundle];
        NSString *mbp = [mb bundlePath];
        NSString *profiledir = [[mbp stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"profile"];
        NSString *new_filename = [profiledir stringByAppendingPathComponent:filename];
        retval = [self loadSequenceBundle_internal:new_filename];
    }
    
    if (!retval) {
        NSRunAlertPanel(@"Load Error", @"%@", @"OK", nil, nil, @"Malformed .IASeq file");
    }
    
    return retval ? 0 : -1;
}
//
//#pragma mark - check barcode state
//-(int)CheckBarcodeState
//{
//    //check has scan barcode or not
//    CTestContext * pTestContext[]={pTestContext0,pTestContext1,pTestContext2,pTestContext3,pTestContext4,pTestContext5};
//    NSString * key[] = {@kEngineUUT0Enable,@kEngineUUT1Enable,@kEngineUUT2Enable,@kEngineUUT3Enable,@kEngineUUT4Enable,@kEngineUUT5Enable};
//    /*
//     -----------------------------------------------------------------------
//     author:ZL Meng
//     Date:Jul.17 2015
//     Description:
//     修改测试线程数从6个改成1个
//     -----------------------------------------------------------------------
//     */
//    for (int i=0; i<UI_MODULE; i++) {
//        id enable = [CTestContext::m_dicConfiguration valueForKey:key[i]];
//        if ([enable intValue])
//        {
//            NSString * str = [pTestContext[i]->m_dicContext valueForKey:kContextMLBSN];
//            str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            if (![str length]) return 0;    //Need re-scan barcode;
//        }
//    }
//    
//    return 1;
//}
//
//#pragma mark Action
-(IBAction)btStart:(id)sender
{
//
    if ([m_pTestEngine IsTesting:-1])
    {
        NSRunAlertPanel(@"TestManager", @"Engine is running,please stop the test sequence first!", @"OK", nil, nil);
        return;
    }
//
//    [btnShowFailOnly setState:NSOffState];
//    [btnShowFailOnly setEnabled:NO];
//    [self redisplayOutlineView:nil];
//    
//    if ([[CTestContext::m_dicConfiguration valueForKey:kConfigAutomationMode] intValue])    //Automation mode
//    {
//        if ([m_TestAutomation ReadSN:nil]<0)
//        {
//            return;
//        }
//        
//        NSTextField * textUUT[] = {textUUT1,textUUT2,textUUT3,textUUT4,textUUT5,textUUT6};
//        NSButton * btUUT[]={btUUT1,btUUT2,btUUT3,btUUT4,btUUT5,btUUT6};
//        NSString * strKey[]={@kEngineUUT0Enable,@kEngineUUT1Enable,@kEngineUUT2Enable,@kEngineUUT3Enable,@kEngineUUT4Enable,@kEngineUUT5Enable};
//        CTestContext * pContext[]={pTestContext0,pTestContext1,pTestContext2,pTestContext3,pTestContext4,pTestContext5};
//        
//#if 1
//        //Checn SN
//        /*
//         -----------------------------------------------------------------------
//         author:ZL Meng
//         Date:Jul.17 2015
//         Description:
//         修改测试线程数从6个改成1个
//         -----------------------------------------------------------------------
//         */
//        for (int i=0; i<UI_MODULE; i++) {
//            @try {
//                int ret = [uiBarcodeWndDelegate CheckSn:[pContext[i]->m_dicContext valueForKey:kContextMLBSN] Type:1];
//                if (ret>0)
//                {
//                    if (![btUUT[i] state])
//                    {
//                        [btUUT[i] performClick:nil];
//                    }
//                    
//                    if ([[CTestContext::m_dicConfiguration valueForKey:strKey[i]] intValue])
//                    {
//                        [textUUT[i] setStringValue:[NSString stringWithFormat:@"%@\r\n%@",[pContext[i]->m_dicContext valueForKey:kContextMLBSN],[pContext[i]->m_dicContext valueForKey:kContextCFG]]];
//                        [textUUT[i] setBackgroundColor:crIDLE];
//                    }
//                }
//            }
//            @catch (NSException *exception) {
//                //[btUUT[i] setState:0];
//                if ([btUUT[i] state])
//                {
//                    [btUUT[i] performClick:nil];
//                }
//                [textUUT[i] setStringValue:@"Invalid SN"];
//            }
//            @finally {
//            }
//        }
//#else
//        /*
//         -----------------------------------------------------------------------
//         author:ZL Meng
//         Date:Jul.17 2015
//         Description:
//         修改测试线程数从6个改成1个
//         -----------------------------------------------------------------------
//         */
//        for (int i=0; i<UI_MODULE; i++) {
//            if ([[CTestContext::m_dicConfiguration valueForKey:strKey[i]] intValue])
//            {
//                [textUUT[i] setStringValue:[NSString stringWithFormat:@"%@\r\n%@",[pContext[i]->m_dicContext valueForKey:kContextMLBSN],[pContext[i]->m_dicContext valueForKey:kContextCFG]]];
//                [textUUT[i] setBackgroundColor:crIDLE];
//            }
//        }
//#endif
//    }
//    else
//    {
//        DEBUG_CMD = DEBUG_DISABLE;
//        if ([[CTestContext::m_dicConfiguration valueForKey:kConfigScanBarcode] boolValue])
//        {
//            if (![self CheckBarcodeState])  //Need Scanbarcode
//            {
//                [self OnMenuScanBarcode:nil];
//                return;
//            }
//        }
//    }
//    
    [m_pTestEngine StartTest];
}
//
//-(IBAction)btStop:(id)sender
//{
//    if (![m_pTestEngine IsTesting:-1]) return;
//#if 1
//    IsRetest = [btRetest state];
//    [m_pTestEngine StopTest];
//#else
//    int ret = NSRunAlertPanel(@"GT Tester", @"Do you need to abort test or retest?", @"Cancel", @"Retest", @"Abort",nil);
//    switch (ret) {
//        case 1: //cancel
//            return; //do nothing
//            break;
//        case 0: //retest
//            IsRetest = YES;
//            break;
//        case -1:    //abort
//            break;
//        default:
//            break;
//    }
//    [m_pTestEngine StopTest];
//#endif
//}
//
//-(IBAction)btPause:(id)sender
//{
//    [m_DebugCondition lock];
//    [m_DebugCondition wait];
//    [m_DebugCondition unlock];
//}
//
//-(IBAction)btResume:(id)sender
//{
//    [m_DebugCondition lock];
//    [m_DebugCondition broadcast];
//    [m_DebugCondition unlock];
//}
//
//
//-(IBAction)OnDblClickOutlineView:(id)sender
//{
//    long row = [outlineView selectedRow];
//    id item = [[outlineView itemAtRow:row] representedObject];
//    if ([item isKindOfClass:[KeyItem class]]) return;   //Click on keyitem, do nothing
//    TestItem * pItem = (TestItem *)item;
//    uiDebugWndDelegate * winDbg = (uiDebugWndDelegate *)[panelDebug delegate];
//    if ([arrBreakPoints indexOfObject:pItem.description]!=NSNotFound)
//    {
//        [arrBreakPoints removeObject:pItem.description];
//        NSLog(@"Remove break point at : %@",pItem.description);
//        
//        [winDbg DebugLog:[NSString stringWithFormat:@"Remove break point at : %@",pItem.description]];
//        pItem.image = nil;
//    }
//    else
//    {
//        //        BREAK_INDEX = [pItem.index integerValue];
//        [arrBreakPoints addObject:pItem.description];
//        NSLog(@"Add break point at : %@",pItem.description);
//        [winDbg DebugLog:[NSString stringWithFormat:@"Add break point at : %@",pItem.description]];
//        pItem.image = [NSImage imageNamed:@"NSComputer"];
//    }
//    [outlineView setNeedsDisplay];
//}
//
//-(IBAction)btUUT:(id)sender
//{
//    long tag = [sender tag];
//    NSTextField * uut[]={textUUT1,textUUT2,textUUT3,textUUT4,textUUT5,textUUT6};
//    NSString * dicKey[]={@kEngineUUT0Enable,@kEngineUUT1Enable,@kEngineUUT2Enable,@kEngineUUT3Enable,@kEngineUUT4Enable,@kEngineUUT5Enable};
//    [uut[tag] setEnabled:[sender state]];
//    [uut[tag] setBackgroundColor:[sender state]?crIDLE:crNA];
//    [CTestContext::m_dicConfiguration setValue:[NSNumber numberWithLong:[sender state]] forKey:dicKey[tag]];
//}
//
//-(IBAction)btSelectAll:(id)sender
//{
//    long state = long([sender state]);
//    
//    [btUUT1 setState:state];
//    [btUUT2 setState:state];
//    [btUUT3 setState:state];
//    [btUUT4 setState:state];
//    [btUUT5 setState:state];
//    [btUUT6 setState:state];
//    
//    [self btUUT:btUUT1];
//    [self btUUT:btUUT2];
//    [self btUUT:btUUT3];
//    [self btUUT:btUUT4];
//    [self btUUT:btUUT5];
//    [self btUUT:btUUT6];
//}
//
//-(IBAction)btCheckStopButton:(id)sender
//{
//    long state = long([sender state]);
//    
//    if ([[textStopButtonPassword stringValue] isEqualToString:@"showmebutton2015"]) {
//        [btStop setEnabled:state];
//        [sender setState:state];
//        [textStopButtonPassword setStringValue:@""];
//    }
//    else
//    {
//        [sender setState:!state];
//        [textStopButtonPassword setStringValue:@""];
//    }
//    
//}
//
//-(IBAction)btReset:(id)sender
//{
//    if (NSRunAlertPanel(@"Statistics Reset ", @"Are you sure to reset the statistics of test data?", @"NO", @"YES",nil)==0)
//    {
//        [textPass setIntValue:0];
//        [textFail setIntValue:0];
//        [textPassRate setStringValue:@"0"];
//        [textFailRate setStringValue:@"0"];
//    }
//}
//
//-(IBAction) redisplayOutlineView:(id)sender
//{
//    [outlineView reloadData];
//    [outlineView expandItem:nil expandChildren:YES];
//    [outlineView setNeedsDisplay];
//}
//
//#define LACONIC_REPORT 1
//
//-(void)ShowResultDetail:(NSDictionary *)dic
//{
//#if LACONIC_REPORT
//    NSString * key[] = {@kEngineUUT0Enable,@kEngineUUT1Enable,@kEngineUUT2Enable,@kEngineUUT3Enable,@kEngineUUT4Enable,@kEngineUUT5Enable};
//    
//    NSMutableString * str = [NSMutableString string];
//    /*
//     -----------------------------------------------------------------------
//     author:ZL Meng
//     Date:Jul.17 2015
//     Description:
//     修改测试线程数从6个改成1个
//     -----------------------------------------------------------------------
//     */
//    for (int i = 0; i < UI_MODULE; i++) {
//        id enable = [CTestContext::m_dicConfiguration valueForKey:key[i]];
//        
//        if ([enable boolValue]) {
//            NSString  *lookup_key = [NSString stringWithFormat:@"fail_groups_%d", i];
//            NSArray   *groups     = [m_dicTestResult valueForKey:lookup_key];
//            NSString  *groupstr   = [groups componentsJoinedByString:@", "];
//            
//            [str appendFormat:@"UUT%d : %@\n", i+1, groupstr];
//        } else {
//            [str appendFormat:@"UUT%d : %@\n", i+1, @"SKIP"];
//        }
//    }
//    
//    [self performSelectorOnMainThread:@selector(ClearPromptLog) withObject:nil waitUntilDone:YES];
//    [self performSelectorOnMainThread:@selector(PromptLog:) withObject:str waitUntilDone:YES];
//    
//#else
//    NSString * key[] = {@kEngineUUT0Enable,@kEngineUUT1Enable,@kEngineUUT2Enable,@kEngineUUT3Enable,@kEngineUUT4Enable,@kEngineUUT5Enable};
//    NSMutableString * str = [NSMutableString string];
//    /*
//     -----------------------------------------------------------------------
//     author:ZL Meng
//     Date:Jul.17 2015
//     Description:
//     修改测试线程数从6个改成1个
//     -----------------------------------------------------------------------
//     */
//    for (int i=0; i<UI_MODULE; i++) {
//        id enable = [CTestContext::m_dicConfiguration valueForKey:key[i]];
//        if ([enable boolValue])
//        {
//            NSString * strResult = [m_dicTestResult valueForKey:[NSString stringWithFormat:@"fail_item_%d",i]];
//            [str appendFormat:@"UUT%d : %@\n",i+1,strResult];
//        }
//        else
//        {
//            [str appendFormat:@"UUT%d : %@\n",i+1,@"SKIP"];
//        }
//    }
//    [self performSelectorOnMainThread:@selector(ClearPromptLog) withObject:nil waitUntilDone:YES];
//    [self performSelectorOnMainThread:@selector(PromptLog:) withObject:str waitUntilDone:YES];
//#endif
//}
//
//#pragma mark Menu action function
//id current_sheet = nil;
//
//-(IBAction)OnPerformance:(id)sender
//{
//    current_sheet = winConfiguration;
//    id sheetWnd = [current_sheet delegate];
//    [sheetWnd InitialCtrls:CTestContext::m_dicConfiguration];
//    [NSApp beginSheet:winConfiguration modalForWindow:winMain modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:NULL];
//}
//
//-(IBAction)OnMenuProfile:(id)sender
//{
//    current_sheet = winProfile;
//    id sheetWnd = [current_sheet delegate];
//    [sheetWnd InitialCtrls:CTestContext::m_dicConfiguration];
//    [NSApp beginSheet:winProfile modalForWindow:winMain modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:NULL];
//}
//
//
//-(void)OnMenuScanBarcode:(id)sender
//{
//    current_sheet = panelBarcode;
//    if ([[current_sheet delegate] InitialCtrls:CTestContext::m_dicConfiguration]<0)
//    {
//        [self sheetDidEnd:winMain returnCode:YES contextInfo:nil];
//        int type = [[CTestContext::m_dicConfiguration valueForKey:kConfigTriggerType] intValue];
//        if (type==4)
//        {
//            [self btStart:sender];//if you want to start test when get right serial number;
//        }
//    }
//    else
//    {
//        [NSApp beginSheet:panelBarcode modalForWindow:winMain modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
//        
//    }
//}
//
//-(IBAction)OnMenuDebugTools:(id)sender
//{
//    [panelDebug makeKeyAndOrderFront:nil];
//}
//
//-(IBAction)OnMenuViewLog:(id)sender
//{
//    [panelLog makeKeyAndOrderFront:nil];
//}
//
//-(IBAction)OnMenuProfileEditor:(id)sender
//{
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:winMain,kPFMainWindow,[CTestContext::m_dicConfiguration valueForKey:kConfigProfilePath],kPFProfileName,nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationProfileEditor object:nil userInfo:dic];
//}
//
//-(IBAction)OnMenuLoopTester:(id)sender
//{
//    [panelLoopTester makeKeyAndOrderFront:nil];
//}
//
//-(IBAction)OnMenuViewDebugLog:(id)sender
//{
//    [panelDebugLog makeKeyAndOrderFront:nil];
//}
//
//
//-(IBAction)OnMenuViewUUTFailedList:(id)sender
//{
//    [panelFailList makeKeyAndOrderFront:nil];
//}
//
//#pragma mark popup menu function
//-(IBAction)OnPopupMenu:(id)sender
//{
//    [sender setState:![sender state]];
//    BOOL bState = [sender state];
//    NSString * title = [sender title];
//    NSTableColumn * col=nil;
//    if ([title isEqualToString:@"Show Limited"])
//    {
//        col = [outlineView tableColumnWithIdentifier:@"lower"];
//        [col setHidden:!bState];
//        col = [outlineView tableColumnWithIdentifier:@"upper"];
//        [col setHidden:!bState];
//    }
//    else if ([title isEqualToString:@"Show Unit"])
//    {
//        col = [outlineView tableColumnWithIdentifier:@"unit"];
//        [col setHidden:!bState];
//    }
//    else if ([title isEqualToString:@"Show Remark"])
//    {
//        col = [outlineView tableColumnWithIdentifier:@"remark"];
//        [col setHidden:!bState];
//    }
//}
//
//#pragma mark Sheet delegate function
//- (void)windowWillBeginSheet:(NSNotification *)notification
//{
//    //    id sheetWnd = [current_sheet delegate];
//    //    [sheetWnd InitialCtrls:CTestContext::m_dicConfiguration];
//}
//
//-(void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
//{
//    if (current_sheet == winConfiguration)
//    {
//        if (returnCode) {   //Clcik On Ok;
//            [self SaveConfig:Config_File];
//            [textSNInput setEnabled:[[CTestContext::m_dicConfiguration valueForKey:kConfigScanBarcode]boolValue]];
//            [textSNInput becomeFirstResponder];
//            [textFixtureID setStringValue:[CTestContext::m_dicConfiguration valueForKey:kConfigFixtureID]];
//            
//            if ([[CTestContext::m_dicConfiguration valueForKey:kConfigAutomationMode] intValue])    //Automation mode;
//            {
//                NSString * str = [textVersion stringValue];
//                [m_TestAutomation WriteVersion:[textSWVersion stringValue] ScriptVersion:str];
//            }
//            
//            //            [btStart setEnabled:[[CTestContext::m_dicConfiguration valueForKey:kConfigTriggerType] intValue]!=1];
//            bool tmpFlag = [[CTestContext::m_dicConfiguration valueForKey:kConfigTriggerType] intValue]!=1;
//            [btStart setEnabled:tmpFlag];
//            if (!tmpFlag)
//                [btStart setTitle:@"Auto"];
//            else
//                [btStart setTitle:@"Start(F5)"];
//        }
//    }
//    else if (current_sheet == panelBarcode) {
//        if (returnCode) //Scan OK
//        {
//            NSTextField * textUUT[] = {textUUT1,textUUT2,textUUT3,textUUT4,textUUT5,textUUT6};
//            NSString * strKey[]={@kEngineUUT0Enable,@kEngineUUT1Enable,@kEngineUUT2Enable,@kEngineUUT3Enable,@kEngineUUT4Enable,@kEngineUUT5Enable};
//            CTestContext * pContext[]={pTestContext0,pTestContext1,pTestContext2,pTestContext3,pTestContext4,pTestContext5};
//            /*
//             -----------------------------------------------------------------------
//             author:ZL Meng
//             Date:Jul.17 2015
//             Description:
//             修改测试线程数从6个改成1个
//             -----------------------------------------------------------------------
//             */
//            for (int i=0; i<UI_MODULE; i++) {
//                if ([[CTestContext::m_dicConfiguration valueForKey:strKey[i]] intValue])
//                {
//                    [textUUT[i] setStringValue:[NSString stringWithFormat:@"%@\r\n%@",[pContext[i]->m_dicContext valueForKey:kContextMLBSN],[pContext[i]->m_dicContext valueForKey:kContextCFG]]];
//                    [textUUT[i] setBackgroundColor:crIDLE];
//                }
//            }
//            
//            
//            //Check need skip test or not
//            [self CheckSkipTest];
//            
//            //            [m_pTestEngine StartTest];  //go test.
//            //Scan start to go start
//            if ([[CTestContext::m_dicConfiguration valueForKey:kConfigTriggerType] intValue]==3)
//            {
//                [self performSelectorOnMainThread:@selector(ScanForTest) withObject:nil waitUntilDone:NO];
//            }
//            
//        }
//    }
//    else if (current_sheet == winProfile) {
//        if (returnCode) {   //Clcik On Ok;
//            [self LoadProfile:[CTestContext::m_dicConfiguration valueForKey:@kEngineProfilePath]];
//            
//            if ([[CTestContext::m_dicConfiguration valueForKey:kConfigAutomationMode] intValue])    //Automation mode;
//            {
//                NSString * str = [textVersion stringValue];
//                [m_TestAutomation WriteVersion:[textSWVersion stringValue] ScriptVersion:str];
//            }
//        }
//        [self SaveConfig:Config_File];[self SaveConfig:Config_File];
//    }
//    
//}
//
//
//#pragma mark Scan dialogs for start test
//-(void)ScanForTest
//{
//    [textTriggerInput setStringValue:@""];
//    [panelScanStart center];
//    if ([NSApp runModalForWindow:panelScanStart]>0)
//    {
//        [panelScanStart orderOut:nil];
//        [self btStart:nil];
//    }
//    else
//    {
//        [panelScanStart orderOut:nil];
//    }
//}
//
//
//#pragma mark Check Need skip the test passed board
//-(int)QueryStationResult:(NSString *)sn withStation:(NSString *)station
//{
//    //Checnk barcode is valid or not
//    CScriptEngine * pEngine = (CScriptEngine *)[m_pTestEngine GetScripEngine:0];
//    lua_State * lua = pEngine->m_pLuaState;
//    
//    //Get global function
//    lua_getglobal(lua, "QueryStationResult");
//    lua_pushstring(lua, [sn UTF8String]);   //sn
//    lua_pushstring(lua, [station UTF8String]);     //format
//    
//    //call lua callback function to check serial number is ok or not
//    int err = lua_pcall(lua, 2, 2, 0);
//    if (err)
//    {
//        NSString * strError = [NSString stringWithUTF8String:lua_tostring(lua, -1)];
//        NSRunAlertPanel(@"Script Error", @"%@", @"OK", nil, nil, strError);
//    }
//    lua_Integer ret = lua_tointeger(lua, -2);
//    if (ret > 0)
//    {
//        return int(ret);     //board test pass
//    }
//    
//    return 0;   //test fail or no test;
//}
//
//-(int)CheckSkipTest
//{
//    if ([checkSkipPassedBoard state]==NO) return 1; //no need check
//    if (![[CTestContext::m_dicConfiguration valueForKey:kConfigPuddingPDCA] boolValue]) return 1;       //no pudding,no need check
//    
//    
//    NSString * strStation = [CTestContext::m_dicGlobal valueForKey:kContextStationName];
//    
//    strStation = [strStation uppercaseString];
//    if ([strStation rangeOfString:@"FCT"].location!=NSNotFound)
//    {
//        strStation = @"FCT";
//    }
//    else if ([strStation rangeOfString:@"DFU"].location!=NSNotFound)
//    {
//        strStation = @"DFU";
//    }
//    
//    NSLog(@"Check Test Result of station :%@",strStation);
//    
//    
//    //Check Result;
//    NSButton * btUUT[]={btUUT1,btUUT2,btUUT3,btUUT4,btUUT5,btUUT6};
//    NSString * strKey[]={@kEngineUUT0Enable,@kEngineUUT1Enable,@kEngineUUT2Enable,@kEngineUUT3Enable,@kEngineUUT4Enable,@kEngineUUT5Enable};
//    CTestContext * pContext[]={pTestContext0,pTestContext1,pTestContext2,pTestContext3,pTestContext4,pTestContext5};
//    /*
//     -----------------------------------------------------------------------
//     author:ZL Meng
//     Date:Jul.17 2015
//     Description:
//     修改测试线程数从6个改成1个
//     -----------------------------------------------------------------------
//     */
//    for (int i=0; i<UI_MODULE; i++) {
//        if ([[CTestContext::m_dicConfiguration valueForKey:strKey[i]] intValue])
//        {
//            NSString * sn = [pContext[i]->m_dicContext valueForKey:kContextMLBSN];
//            int state =[self QueryStationResult:sn withStation:strStation];
//            [btUUT[i] setState:!state];
//            [self btUUT:btUUT[i]];
//        }
//    }
//    return 0;
//}
//
//-(IBAction)btScanOK:(id)sender
//{
//    NSString * str = [CTestContext::m_dicConfiguration valueForKey:kConfigTriggerString];
//    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    str = [str uppercaseString];
//    if ([str length]==0)    //no need check the input string
//    {
//        [NSApp stopModalWithCode:1];
//    }
//    else    //need check
//    {
//        if ([[[textTriggerInput stringValue] uppercaseString]isEqualToString:str])
//        {
//            [NSApp stopModalWithCode:1];
//        }
//        else
//        {
//            [textTriggerInput setStringValue:@""];
//        }
//    }
//}
//-(IBAction)btScanCancel:(id)sender
//{
//    [NSApp stopModalWithCode:0];
//}
//
//-(BOOL)Query_ScanBarcode:(NSString*)barcode
//{
//    CScriptEngine *pEngine = (CScriptEngine *)[m_pTestEngine GetScripEngine:0] ;
//    lua_State *lua = pEngine->m_pLuaState ;
//    
//    //get global function
//    lua_getglobal(lua, "ParseBarcode") ;
//    lua_pushstring(lua, [barcode UTF8String]) ;
//    
//    //call lua callback function to check serial number is ok or not
//    @try {
//        int err = lua_pcall(lua, 1, 1, 0);
//        if (err)
//        {
//            NSString * strError = [NSString stringWithUTF8String:lua_tostring(lua, -1)];
//            @throw [NSException exceptionWithName:@"Lua Error" reason:strError userInfo:nil];
//        }
//        lua_Integer ret = lua_tointeger(lua, -1);
//        if (ret==0)
//        {
//            [textSNInput setStringValue:@""] ;
//            return YES ;
//        }
//    }
//    @catch (NSException *exception) {
//        NSRunAlertPanel(@"Scan Barcode", @"%@", @"OK", nil, nil, [exception description]);
//    }
//    @finally {
//    }
//    
//    
//    return NO ;
//}
//
//#pragma mark textfield control delegate
//- (BOOL)control: (NSControl *)control textView:(NSTextView *)textView doCommandBySelector: (SEL)commandSelector {
//    
//    if (control == textSNInput)
//    {
//        //enter null
//        if ([[[control stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
//        {
//            return YES;
//        }
//        
//        
//        if ([self Query_ScanBarcode:[NSString stringWithFormat:@"%@",textSNInput.stringValue]]==NO)
//        {
//            //select none
//            if ([m_pTestEngine WorkingMdoules]==0)
//            {
//                NSRunAlertPanel(@"Error", @"You should select at least one unit for test.", @"OK", nil, nil);
//                return YES;
//            }
//            
//            
//            if ([NSStringFromSelector(commandSelector) isEqualToString:@"insertNewline:"]) {
//                [self OnMenuScanBarcode:nil];
//            }
//        }
//        
//        return NO;
//    }
//    return NO;
//}
//
//
//#pragma mark Change_User
//-(int)SetUserAuthority:(NSDictionary *)dicUser
//{
//    if (!dicUser)   //Logout
//    {
//        memset(&m_CurrUser, 0, sizeof(USER_INFOR));
//        [textUserName setStringValue:@"None"];
//        [btRetest setState:0];
//        [btRetest setEnabled:NO];
//    }
//    else {
//        strcpy(m_CurrUser.szName, [[dicUser valueForKey:kLoginUserName] UTF8String]);
//        strcpy(m_CurrUser.szName, [[dicUser valueForKey:kLoginUserName] UTF8String]);
//        m_CurrUser.Authority = (USER_AUTHORITY)[[dicUser valueForKey:kLoginUserAuthority] intValue];
//        [textUserName setStringValue:[dicUser valueForKey:kLoginUserName]];
//        [btRetest setEnabled:m_CurrUser.Authority==AUTHORITY_ADMIN];
//    }
//    /*
//     -----------------------------------------------------------------------
//     author:ZL Meng
//     Date:Jul.17 2015
//     Description:
//     添加功能 如果不是“engineer”用户的时候隐藏stop按钮
//     -----------------------------------------------------------------------
//     */
//    if (strcmp(m_CurrUser.szName,"engineer")==0)
//    {
//        [btStop setHidden:NO];
//    }else
//    {
//        [btStop setHidden:YES];
//    }
//    [[self->toolsMenu itemWithTitle:@"Sheet Control"] setEnabled:(m_CurrUser.Authority < AUTHORITY_OPERATOR)];
//    if (m_CurrUser.Authority == AUTHORITY_OPERATOR) {
//        [(id)[winConfiguration delegate] enablePDCA:NSOnState];
//        [CTestContext::m_dicConfiguration setValue:[NSNumber numberWithBool:YES] forKey:kConfigPuddingPDCA];
//        [CTestContext::m_dicConfiguration setValue:[NSNumber numberWithBool:YES] forKey:kConfigScanBarcode];
//        [self SaveConfig:Config_File];
//    }
//    
//    return 0;
//}
//
#pragma mark Notification
-(void)OnUiNotification:(NSNotification *)nf
{
//    NSString * name = [nf name];
//    if ([name isEqualToString:kNotificationOnTestStart])
//    {
//        [self performSelectorOnMainThread:@selector(OnTestStart:) withObject:[nf userInfo] waitUntilDone:YES];
//    }
//    else if ([name isEqualToString:kNotificationOnTestStop]) {
//        [self performSelectorOnMainThread:@selector(OnTestStop:) withObject:[nf userInfo] waitUntilDone:YES];
//    }
//    else if ([name isEqualToString:kNotificationOnTestFinish]) {
//        [self performSelectorOnMainThread:@selector(OnTestFinish:) withObject:[nf userInfo] waitUntilDone:YES];
//    }
//    else if ([name isEqualToString:kNotificationOnTestPause]) {
//        [self performSelectorOnMainThread:@selector(OnTestPasue:) withObject:[nf userInfo] waitUntilDone:YES];
//    }
//    else if ([name isEqualToString:kNotificationOnTestResume]) {
//        [self performSelectorOnMainThread:@selector(OnTestResume:) withObject:[nf userInfo] waitUntilDone:YES];
//    }
//    else if ([name isEqualToString:kNotificationOnTestItemStart]) {
//        [self performSelectorOnMainThread:@selector(OnTestItemStart:) withObject:[nf userInfo] waitUntilDone:YES];
//    }
//    else if ([name isEqualToString:kNotificationOnTestItemFinish]) {
//        [self performSelectorOnMainThread:@selector(OnTestItemFinish:) withObject:[nf userInfo] waitUntilDone:YES];
//    }
//    else if ([name isEqualToString:kNotificationOnTestError]) {
//        [self performSelectorOnMainThread:@selector(OnTestError:) withObject:[nf userInfo] waitUntilDone:YES];
//    }
//    
//    //Do action notification
//    if ([name isEqualToString:kNotificationDoTestStart])
//    {
//        [self performSelectorOnMainThread:@selector(btStart:) withObject:nil waitUntilDone:YES];
//    }
//    else if ([name isEqualToString:kNotificationDoTestStop]) {
//        [self performSelectorOnMainThread:@selector(btStop:) withObject:nil waitUntilDone:YES];
//    }
//    else if ([name isEqualToString:kNotificationDoTestFinish]) {
//    }
//    else if ([name isEqualToString:kNotificationDoTestPause]) {
//    }
//    else if ([name isEqualToString:kNotificationDoTestResume]) {
//    }
//    else if ([name isEqualToString:kNotificationDoTestItemStart]) {
//    }
//    else if ([name isEqualToString:kNotificationDoTestItemFinish]) {
//    }
//    else if ([name isEqualToString:kNotificationDoTestError]) {
//        //[textUUT1 setBackgroundColor:[NSColor yellowColor]];
//    }
//    else if ([name isEqualToString:kNotificationDoUiCtrl])
//    {
//        [self UiCtrl:[nf userInfo]];
//    }
//    
//    //Do Change User
//    if ([name isEqualToString:kNotificationDoChangeUser])
//    {
//        [self SetUserAuthority:[nf userInfo]];
//    }
//    
//    if ([name isEqualToString:kNotificationEnableUUTCtrl])
//    {
//        NSDictionary *userInfo = nf.userInfo ;
//        /////---------uut1------------////
//        if ([[userInfo objectForKey:@kEngineUUT0Enable] boolValue])
//            [btUUT1 setState:1] ;
//        else
//            [btUUT1 setState:0] ;
//        [btUUT1 displayIfNeeded] ;
//        [self btUUT:btUUT1] ;
//        
//        /////---------uut2------------////
//        if ([[userInfo objectForKey:@kEngineUUT1Enable] boolValue])
//            [btUUT2 setState:1] ;
//        else
//            [btUUT2 setState:0] ;
//        [btUUT2 displayIfNeeded] ;
//        [self btUUT:btUUT2] ;
//        
//        /////---------uut3------------////
//        if ([[userInfo objectForKey:@kEngineUUT2Enable] boolValue])
//            [btUUT3 setState:1] ;
//        else
//            [btUUT3 setState:0] ;
//        
//        [btUUT3 displayIfNeeded] ;
//        [self btUUT:btUUT3] ;
//        
//        /////---------uut4------------////
//        if ([[userInfo objectForKey:@kEngineUUT3Enable] boolValue])
//            [btUUT4 setState:1] ;
//        else
//            [btUUT4 setState:0] ;
//        
//        [btUUT4 displayIfNeeded] ;
//        [self btUUT:btUUT4] ;
//        
//        /////---------uut5------------////
//        if ([[userInfo objectForKey:@kEngineUUT4Enable] boolValue])
//            [btUUT5 setState:1] ;
//        else
//            [btUUT5 setState:0] ;
//        
//        [btUUT5 displayIfNeeded] ;
//        [self btUUT:btUUT5] ;
//        
//        /////---------uut6------------////
//        if ([[userInfo objectForKey:@kEngineUUT5Enable] boolValue])
//            [btUUT6 setState:1] ;
//        else
//            [btUUT6 setState:0] ;
//        
//        [btUUT6 displayIfNeeded] ;
//        [self btUUT:btUUT6] ;
//    }
}
//
//#pragma mark Engine_Finish
//-(int)PromptLog:(NSString * )msg
//{
//    NSUInteger length = 0;
//    NSAttributedString *theString;
//    NSRange theRange;
//    
//    theString = [[NSAttributedString alloc] initWithString:msg];
//    [[textPromptLog textStorage] appendAttributedString: theString];
//    length = [[textPromptLog textStorage] length];
//    theRange = NSMakeRange(length, 0);
//    [textPromptLog scrollRangeToVisible:theRange];
//    [theString release];
//    return 0;
//}
//-(int)ClearPromptLog
//{
//    [textPromptLog setString:@""];
//    return 0;
//}
-(void)OnEngineNotification:(NSNotification *)nf
{
    if ([[nf name] isEqualToString:kNotificationOnEngineStart])
    {
//        //global ui update
//        [btSelectAll setEnabled:NO];
//        [textSNInput setEnabled:NO];
//        
//        [btUUT1 setEnabled:NO];
//        [btUUT2 setEnabled:NO];
//        [btUUT3 setEnabled:NO];
//        [btUUT4 setEnabled:NO];
//        [btUUT5 setEnabled:NO];
//        [btUUT6 setEnabled:NO];
    }
    else if ([[nf name]isEqualToString:kNotificationOnEngineFinish]) {
//        /*
//         NSString * key[] = {@kEngineUUT0Enable,@kEngineUUT1Enable,@kEngineUUT2Enable,@kEngineUUT3Enable};
//         NSMutableString * str = [NSMutableString string];
//         for (int i=0; i<UI_MODULE; i++) {
//         id enable = [CTestContext::m_dicConfiguration valueForKey:key[i]];
//         if ([enable boolValue])
//         {
//         NSString * strResult = [m_dicTestResult valueForKey:[NSString stringWithFormat:@"fail_item_%d",i]];
//         if ([strResult length]==0)
//         {
//         strResult=@"PASS";
//         }
//         [str appendFormat:@"UUT%d : %@\n",i+1,strResult];
//         }
         }
//         [self performSelectorOnMainThread:@selector(PromptLog:) withObject:str waitUntilDone:YES];
//         */
//        //global ui update
//        //Automation mode
//        if ([[CTestContext::m_dicConfiguration valueForKey:kConfigAutomationMode] intValue])
//        {
//            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:m_TestResult[0]],kAutomationUUT1_State,[NSNumber numberWithInt:m_TestResult[1]],kAutomationUUT2_State,[NSNumber numberWithInt:m_TestResult[2]],kAutomationUUT3_State,[NSNumber numberWithInt:m_TestResult[3]],kAutomationUUT4_State,[NSNumber numberWithInt:m_TestResult[4]],kAutomationUUT5_State,
//                                  [NSNumber numberWithInt:m_TestResult[5]],kAutomationUUT6_State,nil];
//            [m_TestAutomation WriteTestResult:dic];
//        }
//        
//        
//        item_start_time=0;
//        [btSelectAll setEnabled:YES];
//        [textSNInput setEnabled:[[CTestContext::m_dicConfiguration valueForKey:kConfigScanBarcode]boolValue]];
//        [textSNInput becomeFirstResponder];
//        
//        
//        [progressUUT1 stopAnimation:nil];
//        [progressUUT2 stopAnimation:nil];
//        [progressUUT3 stopAnimation:nil];
//        [progressUUT4 stopAnimation:nil];
//        [progressUUT5 stopAnimation:nil];
//        [progressUUT6 stopAnimation:nil];
//        uut_startTime[0] =0;
//        uut_startTime[1] =0;
//        uut_startTime[2] =0;
//        uut_startTime[3] =0;
//        uut_startTime[4] =0;
//        uut_startTime[5] =0;
//        
//        [btUUT1 setEnabled:YES];
//        [btUUT2 setEnabled:YES];
//        [btUUT3 setEnabled:YES];
//        [btUUT4 setEnabled:YES];
//        [btUUT5 setEnabled:YES];
//        [btUUT6 setEnabled:YES];
//        
//        [btnShowFailOnly setEnabled:YES];
//        
//        //abort or normal?
//        if (IsRetest)    //no use now
//        {
//            return;
//        }
//        
//        //clear the sn buffer for next test loop
//        if (!bLoopTestMode)  //in loop test mode,no need rescan the sn.
//        {
//            /*
//             -----------------------------------------------------------------------
//             author:ZL Meng
//             Date:Jul.17 2015
//             Description:
//             修改测试线程数从6个改成1个
//             -----------------------------------------------------------------------
//             */
//            for (int i=0; i<UI_MODULE; i++) {
//                [((CTestContext *)[m_pTestEngine GetTestContext:i])->m_dicContext setValue:@"" forKey:kContextMLBSN];
//                [((CTestContext *)[m_pTestEngine GetTestContext:i])->m_dicContext setValue:@"" forKey:kContextCFG];
//            }
//        }
//    }
}
//
//#pragma mark Menu Auto Enable
//- (BOOL)validateUserInterfaceItem:(id < NSValidatedUserInterfaceItem >)anItem
//{
//    NSInteger tag = [anItem tag];
//    if (tag>=8)   //these item should disable while testing.
//    {
//        if ([m_pTestEngine IsTesting:-1])
//        {
//            return NO;
//        }
//        tag-=8;
//    }
//    
//    //Check Authority
//    int usrAuthority = 0;  //Curr
//    if (!m_CurrUser.szName) //no login
//    {
//        usrAuthority = 2;      //operator authority
//    }
//    else {
//        usrAuthority = m_CurrUser.Authority;
//    }
//    
//    NSInteger menuAuthority = AUTHORITY_OPERATOR-tag;
//    
//    return usrAuthority<=menuAuthority;
//    
//    return YES;
//}
//
//#pragma mark main window delegate
//- (void)windowWillClose:(NSNotification *)notification
//{
//    [NSApp terminate:nil];
//}
//
//-(BOOL)windowShouldClose:(NSNotification *)notification
//{
//    if ([m_pTestEngine IsTesting:-1])
//    {
//        NSRunAlertPanel(@"Quit App", @"Engine is running,stop it first!", @"OK", nil, nil);
//        return NO;
//    }
//    return YES;
//}
//
//
//#pragma mark UICtrl
//-(void)UiCtrl:(NSDictionary *)dic
//{
//    NSString * cmd = [dic valueForKey:@"cmd"];
//    int index=[[dic valueForKey:@"id"] intValue];
//    NSString * buffer = [dic valueForKey:@"buf"];
//    
//    
//    CTestContext * pContext[]={pTestContext0,pTestContext1,pTestContext2,pTestContext3,pTestContext4,pTestContext5};
//    NSTextField * textUUT[] = {textUUT1,textUUT2,textUUT3,textUUT4,textUUT5,textUUT6};
//    if ([cmd isEqualToString:@"set_panel_sn"])
//    {
//        [pContext[index]->m_dicContext setValue:[NSString stringWithFormat:@"%@",buffer] forKey:kContextPanelSN];
//    }
//    else if ([cmd isEqualToString:@"set_mlb_sn"])
//    {
//        [pContext[index]->m_dicContext setValue:buffer forKey:kContextMLBSN];
//        
//        if ([buffer isEqualToString:@""])
//        {
//            [textUUT[index] setStringValue:[NSString stringWithFormat:@"%@\r\n%@",[NSString stringWithFormat:@"UUT%d",index],[pContext[index]->m_dicContext valueForKey:kContextCFG]]];
//        }
//        else
//        {
//            [textUUT[index] setStringValue:[NSString stringWithFormat:@"%@\r\n%@",[pContext[index]->m_dicContext valueForKey:kContextMLBSN],[pContext[index]->m_dicContext valueForKey:kContextCFG]]];
//        }
//        
//        
//        [textUUT[index] setBackgroundColor:crIDLE];
//    }
//    else if ([cmd isEqualToString:@"set_cfg_sn"])
//    {
//        [pContext[index]->m_dicContext setValue:buffer forKey:kContextCFG];
//        
//        [textUUT[index] setStringValue:[NSString stringWithFormat:@"%@\r\n%@",[pContext[index]->m_dicContext valueForKey:kContextMLBSN],[pContext[index]->m_dicContext valueForKey:kContextCFG]]];
//        [textUUT[index] setBackgroundColor:crIDLE];
//    }
//    else if ([cmd isEqualToString:@"set_build_event"])
//    {
//        [pContext[index]->m_dicContext setValue:[NSString stringWithFormat:@"%@",buffer] forKey:kContextBuildEvent];
//    }
//    else if ([cmd isEqualToString:@"set_sbuild"])
//    {
//        [pContext[index]->m_dicContext setValue:[NSString stringWithFormat:@"%@",buffer] forKey:kContextSBuild];
//    }
//    else if ([cmd isEqualToString:@"set_uut_state"])
//    {
//        int state = [buffer intValue];
//        NSString * dicKey[]={@kEngineUUT0Enable,@kEngineUUT1Enable,@kEngineUUT2Enable,@kEngineUUT3Enable,@kEngineUUT4Enable,@kEngineUUT5Enable};
//        NSButton  * btUUT[]={btUUT1,btUUT2,btUUT3,btUUT4,btUUT5,btUUT6};
//        [btUUT[index] setState:state];
//        [textUUT[index] setBackgroundColor:state?crIDLE:crNA];
//        [CTestContext::m_dicConfiguration setValue:[NSNumber numberWithLong:[buffer intValue]] forKey:dicKey[index]];
//    }
//    else if ([cmd isEqualToString:@"reload_profile"])
//    {
//        //reload profle ,need update UserInterface, use this entry to change profiel by script.
//    }
//    else
//    {
//        NSRunAlertPanel(@"UI Ctrl", @"Unkown Ctrl code : %@", @"OK", nil, nil, cmd);
//    }
//}
//
//- (IBAction) btnShowTestsClicked:(id)sender
//{
//    NSSplitViewDividerStyle style = NSSplitViewDividerStyleThick;
//    
//    //    if ([btnShowTests state] == NSOnState)
//    //    {
//    //        
//    //        // 150 is approx height of DFU panel view's height
//    //        CGFloat position = [splitOutlineView frame].size.height - 150;
//    //        [splitOutlineView setPosition:position ofDividerAtIndex:0];
//    //        
//    //    }
//    //    else
//    //    {
//    //        [splitOutlineView setPosition:0 ofDividerAtIndex:0];
//    //        style = NSSplitViewDividerStyleThin;
//    //    }
//    //
//    //    [splitOutlineView setDividerStyle:style];
//    
//    [splitOutlineView setDividerStyle:NSSplitViewDividerStyleThin];
//    if ([btnShowTests state] == NSOnState)
//    {
//        [detailTestView setHidden:NO];
//        [[testProgressController view] setHidden:YES];
//    }
//    else
//    {
//        [detailTestView setHidden:YES];
//        [[testProgressController view] setHidden:NO];
//        if (![[testDisplayView subviews] containsObject:[testProgressController view]])
//        {
//            [testDisplayView addSubview:[testProgressController view]];
//        }
//        NSRect frame = [detailTestView frame];
//        [[testProgressController view] setFrame:frame];
//        //        [[testProgressController view] setNeedsDisplay:YES];
//    }
//    
//}
//#pragma mark SplitView delegate
////- (CGFloat)splitView:(NSSplitView *)splitView constrainSplitPosition:(CGFloat)proposedPosition ofSubviewAt:(NSInteger)dividerIndex
////{
////    CGFloat position = proposedPosition;
////    if (splitView == splitOutlineView)
////    {
////        // hide outline view
////        if ([btnShowTests state] != NSOnState)
////        {
////            position = 0;
////        }
////    }
////    
////    return position;
////}
//
    @end


