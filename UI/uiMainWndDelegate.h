//
//  uiMainWndDelegate.h
//  UI
//
//  Created by Hogan on 17/8/4.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
//#include "CoreLib/Common.h"

//#include "Automation.h"

//#import "uiTestProgressController.h"

#pragma once
@interface uiMainWndDelegate : NSObject{
@private
    //Control
    IBOutlet NSWindow * winMain;
    IBOutlet NSWindow * winConfiguration;
    IBOutlet NSWindow * winProfile;
    
    
    //panel
    IBOutlet NSPanel * panelDebug;
    IBOutlet NSPanel * panelLog;
    IBOutlet NSPanel * panelBarcode;
    IBOutlet NSPanel * panelLoopTester;
    IBOutlet NSPanel * panelDebugLog;
    IBOutlet NSWindow * panelLogin;
    IBOutlet NSPanel * panelScanStart;
    IBOutlet NSPanel * panelFailList;
    
    IBOutlet NSTextField * textUUT1;
    IBOutlet NSTextField * textUUT2;
    IBOutlet NSTextField * textUUT3;
    IBOutlet NSTextField * textUUT4;
    IBOutlet NSTextField * textUUT5;
    IBOutlet NSTextField * textUUT6;
    
    IBOutlet NSButton * btUUT1;
    IBOutlet NSButton * btUUT2;
    IBOutlet NSButton * btUUT3;
    IBOutlet NSButton * btUUT4;
    IBOutlet NSButton * btUUT5;
    IBOutlet NSButton * btUUT6;
    
    IBOutlet NSButton * btStart;
    IBOutlet NSButton * btStop;
    IBOutlet NSButton * btSelectAll;
    IBOutlet NSTextField * textStopButtonPassword;
    
    IBOutlet NSTextField * textFail;
    IBOutlet NSTextField * textFailRate;
    IBOutlet NSTextField * textPass;
    IBOutlet NSTextField * textPassRate;
    
    IBOutlet NSTextField * textModule;
    IBOutlet NSTextField * textVersion;
    
    IBOutlet NSTextField * textStation;
    IBOutlet NSTextField * textLine;
    IBOutlet NSTextField * textUserName;
    IBOutlet NSTextField * textStationID;
    IBOutlet NSTextView * textPromptLog;
    
    IBOutlet NSSplitView * splitOutlineView;
    IBOutlet NSOutlineView * outlineView;
    
    IBOutlet NSTextField * textElapsedTimeUUT1;
    IBOutlet NSTextField * textElapsedTimeUUT2;
    IBOutlet NSTextField * textElapsedTimeUUT3;
    IBOutlet NSTextField * textElapsedTimeUUT4;
    IBOutlet NSTextField * textElapsedTimeUUT5;
    IBOutlet NSTextField * textElapsedTimeUUT6;
    IBOutlet NSProgressIndicator * progressUUT1;
    IBOutlet NSProgressIndicator * progressUUT2;
    IBOutlet NSProgressIndicator * progressUUT3;
    IBOutlet NSProgressIndicator * progressUUT4;
    IBOutlet NSProgressIndicator * progressUUT5;
    IBOutlet NSProgressIndicator * progressUUT6;
    
    IBOutlet NSView * testDisplayView;
    IBOutlet NSView * detailTestView;
//    uiTestProgressController * testProgressController;
    
    IBOutlet NSTextField * textSNInput;
    
    IBOutlet NSMenu * instrMenu;
    IBOutlet NSMenu * toolsMenu;
    
    IBOutlet NSMenuItem * loginMenu;
    
    IBOutlet NSTextField * textTriggerInput;
    
    IBOutlet NSButton * btRetest;
    
    IBOutlet NSTextField * textSWVersion;
    
    IBOutlet NSTextField * textFixtureID;
    
    IBOutlet NSButton * btnShowTests;
    
    IBOutlet NSButton * btnShowFailOnly;
    
    IBOutlet NSButton * checkSkipPassedBoard;
    
//    Automation * m_TestAutomation;
    int m_TestResult[6];
    
    NSString * m_strFirstFailItem[6];
    
@private
    //Timer..
    NSTimeInterval uut_startTime[6];
    //timer
    NSTimer * testTimer;
    
    NSTimer * itemTimer;
    
    NSTimer * outlineViewUpdateTimer;
    
    NSThread * timerThread;
    NSThread * testThread;
    
    NSMutableArray * arrBreakPoints;
    NSCondition * m_DebugCondition;
    
    NSMutableDictionary * m_dicTestResult;
    
//    USER_INFOR  m_CurrUser;
    
    id last_loaded_index;
    NSString * last_loaded_index_path;
    NSString * loadedIndexPath;
    
    NSTimer * scrollOutlineViewTaskTimer;
    int scrollIndex;
}



//UI Update function
typedef enum
{
    TS_READY,
    TS_IDLE,
    TS_TESTING,
    TS_PASS,
    TS_FAIL,
    TS_PAUSE,
    TS_ABORT,
    TS_ERROR,
}TEST_STATE;

-(int) OnTestStart:(id)sender;
-(int) OnTestStop:(id)sender;
-(int) OnTestPasue:(id)sender;
-(int) OnTestResume:(id)sender;
-(int) OnTestItemStart:(id)sender;
-(int) OnTestItemFinish:(id)sender;
-(int) OnTestFinish:(id)sender;
-(int) OnTestError:(id)sender;

-(int)SetUserAuthority:(NSDictionary *)dicUser;

-(IBAction)btStart:(id)sender;
-(IBAction)btStop:(id)sender;
-(IBAction)btPause:(id)sender;
-(IBAction)btResume:(id)sender;
-(IBAction)btUUT:(id)sender;
-(IBAction)btReset:(id)sender;

-(IBAction) redisplayOutlineView:(id)sender;

-(IBAction)OnPerformance:(id)sender;
-(IBAction)OnMenuDebugTools:(id)sender;
-(IBAction)OnMenuViewLog:(id)sender;
-(IBAction)OnMenuProfile:(id)sender;
-(IBAction)OnDblClickOutlineView:(id)sender;
-(IBAction)OnMenuScanBarcode:(id)sender;
-(IBAction)OnMenuProfileEditor:(id)sender;
-(IBAction)OnMenuLoopTester:(id)sender;


@property (readonly) NSMutableArray * arrBreakPoints;

@property (readwrite) NSString * loadedIndexPath;

@end
