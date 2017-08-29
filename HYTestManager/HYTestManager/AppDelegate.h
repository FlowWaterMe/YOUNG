//
//  AppDelegate.h
//  HYTestManager
//
//  Created by Hogan on 17/8/2.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "TestEngine.h"
#import "TestManager.h"
@interface AppDelegate : NSObject <NSApplicationDelegate>
{
IBOutlet NSWindow * wndSplash;
IBOutlet NSPanel * panelAbout;
IBOutlet NSTextView * txtLogView;

IBOutlet NSTextField * txtAboutTitle;
IBOutlet NSTextView * txtAboutInformation;
IBOutlet NSMenu * m_menu;
IBOutlet NSProgressIndicator * progress;
IBOutlet NSWindow * m_window;
NSTimer * timerSplash;

NSThread * threadLoading;

NSDictionary * m_dicConfiguration;

TestManager * tm;

IBOutlet NSWindow * winLogin;
IBOutlet NSWindow * panelUserManagement;

IBOutlet NSMenuItem * menuLogin;
IBOutlet NSMenuItem * menuUserManagement;

IBOutlet NSButton * checkSelfTest;


IBOutlet NSWindow * winTmFile;

IBOutlet NSTableView * tvTMList;


@private
NSArray *_listOfTmFiles;
}
-(IBAction)OnMenuAbout:(id)sender;
//@property (assign) IBOutlet NSWindow *window;

@property (copy) NSArray *listOfTmFiles;
@end

