//
//  AppDelegate.m
//  HYTestManager
//
//  Created by Hogan on 17/8/2.
//  Copyright © 2017年 com.Young. All rights reserved.
//

//
//  AppDelegate.m
//  TestManager
//

#import "AppDelegate.h"

#include "Common.h"
#include "UserInformation.h"
#include "PathManager.h"
//#include <CoreLib/tag.h>

#define kProjectName    "Name"
#define kEnginePath     "Engine"
#define kUIPath         "UI"
#define kInstruments    "Instruments"
#define kStartUp        "StartUp"
#define kConfiguration  "Configuration"
#define kScript         "Script"
#define kSelfTest       "SelfTest"

#define kLogin          "Login"
#define kAutoLogin      "AutoLogin"
#define kAutoUserName       "User"
#define kAutoPassword       "pwd"



static USER_INFOR       *pCurrUser = NULL;
extern CUserInformation *m_pUserInformation;


@implementation AppDelegate

//@synthesize window = _window;
-(id)init
{
    self =[super init];
    if (self)
    {
        m_dicConfiguration=nil;
        NSString * str = [[NSBundle bundleForClass:[self class]] resourcePath];
//        str = [str stringByAppendingPathComponent:@tag_file];
//        [[NSFileManager defaultManager] removeItemAtPath:str error:nil];
//        [[NSFileManager defaultManager] createFileAtPath:str contents:nil attributes:nil];
    }
    return self;
}
-(void)awakeFromNib
{
    [tvTMList setTarget:self];
    [tvTMList setDoubleAction:@selector(DblClickOnTableView:)];
}
- (void)dealloc
{
    [m_dicConfiguration release];
//    [tm release];
    [super dealloc];
}

-(void)applicationWillFinishLaunching:(NSNotification *)notification
{
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.listOfTmFiles = [self ListTmFile];
    [tvTMList noteNumberOfRowsChanged];
    
    if (![self.listOfTmFiles count])
    {
        NSRunAlertPanel(@"Launch Failed", @"Couldn't found tm config file,should special at least one", @"OK", nil, nil);
    }
    else
    {
        NSString * autoLoadTm = [self autoLoadTm];
        if ([self.listOfTmFiles count] > 1)  //more tm file,select it.
        {
            if (autoLoadTm && [self.listOfTmFiles containsObject:autoLoadTm])
            {
                [self StartUpWithTmFile:[[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:autoLoadTm]];
            }
            else
            {
                [winTmFile center];
                [winTmFile makeKeyAndOrderFront:nil];
            }
        }
        else    //only one,just lanuch it.
        {

            [self StartUpWithTmFile:[[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[self.listOfTmFiles objectAtIndex:0]]];
        }
    }
    
    
    //Create Directory
    NSBundle *bundle    = [NSBundle mainBundle];
    NSString *strScript = [[[bundle bundlePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Script"];
    NSString *strLog    = [[PathManager sharedManager] logPath];
    
    NSError  *err       = nil;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:strScript withIntermediateDirectories:YES attributes:nil error:&err])
    {
        NSRunAlertPanel(@"Create Driectory failed", @"%@", @"OK", nil, nil, [err description]);
    }
    if (![[NSFileManager defaultManager] createDirectoryAtPath:strLog withIntermediateDirectories:YES attributes:nil error:&err])
    {
        NSRunAlertPanel(@"Create Driectory failed", @"%@", @"OK", nil, nil, [err description]);
    }
    
    return;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    return NSTerminateNow;
}


-(NSArray *)ListTmFile
{
    NSString       *str    = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    NSFileManager  *fm     = [NSFileManager defaultManager];
    NSMutableArray *retval = [NSMutableArray array];
    
    for (NSString *f in [fm contentsOfDirectoryAtPath:str error:nil])
    {
        if ([[f pathExtension] isEqualToString:@"tm"])
        {
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[str stringByAppendingPathComponent:f]];
            
            id obj_1 = [dic valueForKey:@kEnginePath];
            id obj_2 = [dic valueForKey:@kUIPath];
            
            if (!obj_1 || !obj_2) continue;
            
            [retval addObject:f];
        }
    }
    
    return retval;
}


-(BOOL)StartUpWithTmFile:(NSString *)filename
{
    tm = [TestManager new];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnLogMessage:) name:kNotificationStartupLog object:nil];  //add observer
    [progress startAnimation:nil];

    bool bLoad = [self LoadTM:filename];
    [wndSplash orderOut:nil];

    NSDictionary * dicUser = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:pCurrUser->szName],kLoginUserName,[NSString stringWithUTF8String:pCurrUser->szPassword],kLoginUserPassword,[NSNumber numberWithInt:pCurrUser->Authority],kLoginUserAuthority, nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDoChangeUser object:nil userInfo:dicUser];
//
    [progress stopAnimation:nil];
//
    self.listOfTmFiles = nil;
//
    return bLoad;
//    return 0;
}

-(BOOL)LoadTM:(NSString *)filename
{
    @try {
        m_dicConfiguration = [[NSDictionary dictionaryWithContentsOfFile:filename] retain];
        
        [self CheckLogin:nil];
        
        if (!m_dicConfiguration)
        {
            @throw [NSException exceptionWithName:@"Load Failed!" reason:@"Invalid tm file." userInfo:nil];
        }
        id object = [m_dicConfiguration valueForKey:@kEnginePath];
        if (!object)
        {
            @throw [NSException exceptionWithName:@"Load Failed!" reason:@"Invalid tm file,not special engine file." userInfo:nil];
        }
        object = [m_dicConfiguration valueForKey:@kUIPath];
        if (!object)
        {
            @throw [NSException exceptionWithName:@"Load Failed!" reason:@"Invalid tm file,not special engine file." userInfo:nil];
        }
        
        id selfTest =[m_dicConfiguration valueForKey:@kSelfTest];
        BOOL bSelfTest = NO;
        if (selfTest)
        {
            bSelfTest = [selfTest boolValue];
        }
        [checkSelfTest setState:bSelfTest];
        
        NSString * strName = [m_dicConfiguration valueForKey:@kProjectName];
        [self LogMessage:[NSString stringWithFormat:@"Start Up %@",strName] Level:MSG_LEVEL_NORMAL];
        int ret = [self LoadModules:m_dicConfiguration];
        if (ret)
        {
            [self LogMessage:[NSString stringWithFormat:@"Start Up %@ failed,please check the config file.",strName] Level:MSG_LEVEL_ERROR];
        }
        else {
            [self LogMessage:[NSString stringWithFormat:@"Start Up %@ Finish!",strName] Level:MSG_LEVEL_NORMAL];
        }
        //Change Menu title;
        NSMenu * mainMenu = [NSApp mainMenu];
        NSMenu * appMenu = [[mainMenu itemAtIndex:0]submenu];
        [appMenu setTitle:strName];
        [[appMenu itemAtIndex:0] setTitle:[NSString stringWithFormat:@"About %@",strName]];
        [[appMenu itemAtIndex:0] setTarget:self];
        [[appMenu itemAtIndex:0] setAction:@selector(OnMenuAbout:)];
        
        //add user menu
        NSInteger count = [appMenu numberOfItems];
        [appMenu insertItem:menuUserManagement atIndex:count-2];
        //[appMenu insertItem:menuLogin atIndex:count-2];
        [appMenu insertItem:[NSMenuItem separatorItem] atIndex:count-2];
        [appMenu insertItem:[NSMenuItem separatorItem] atIndex:count-4];
        
    } @catch (NSException * e) {
        NSRunAlertPanel([e name], @"%@", @"OK", nil, nil, [e description]);
        return NO;
    }
    
    return YES;
}

//Menu action
-(IBAction)openDocument:(id)sender
{
    return;//no use now;
    NSOpenPanel * panel = [NSOpenPanel openPanel];
#if 1
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"tm", nil]];
    [panel runModal];
    NSString * str = [[panel URL] path];
    if (str)
    {
        [self LoadTM:str];
    }
#else
    [panel setAllowedFileTypes:[FILE_EXTERN componentsSeparatedByString:@","]];
    // This method displays the panel and returns immediately.
    // The completion handler is called when the user selects an
    // item or cancels the panel.
    [panel beginSheetModalForWindow:winICT completionHandler:^(NSInteger result)
     //    [panel beginWithCompletionHandler:^(NSInteger result)
     {
         if (result == NSFileHandlingPanelOKButton) {
             @try {
                 NSURL*  theDoc = [[panel URLs] objectAtIndex:0];
                 
                 NSString * filename = [theDoc path];
                 NSString * pathExtension = [filename pathExtension];
                 if ([pathExtension isEqualToString:@"ict"])
                 {
                     [self LoadICTfile:filename];
                 }
                 else if ([pathExtension isEqualToString:@"int"]||[[filename pathExtension] isEqualToString:@"csv"]) {
                     [self LoadTeboFile:filename];
                 }
                 else if ([pathExtension isEqualToString:@"tri"]) {
                     
                 }
                 [textProfile setStringValue:[theDoc path]];
             }
             @catch (NSException *exception) {
                 NSRunAlertPanel(@"Load file", @"Load file failed,please check the data file formate", @"OK", nil, nil);
             }
             @finally {
             }
         }
         
         ictwindowDelegate * pwindow = (ictwindowDelegate *)[winICT delegate];
         pwindow.m_bNeedCreateDataFile = YES;
     }];
#endif
}

//User interface should switch to main thread
-(int)LoadModules:(NSDictionary *)dicConfig
{
    //Load Engine First...
    NSString * pathEngine = [dicConfig valueForKey:@kEnginePath];
    [self LogMessage:[NSString stringWithFormat:@"Loading Engine : %@",pathEngine] Level:MSG_LEVEL_NORMAL];
    if ([tm LoadEngine:pathEngine])
    {
        [self LogMessage:[NSString stringWithFormat:@"Loading Engine : %@ failed!",pathEngine] Level:MSG_LEVEL_ERROR];
    }
    else {
        [self LogMessage:[NSString stringWithFormat:@"Loading Engine : %@ successful!",pathEngine] Level:MSG_LEVEL_NORMAL];
    }
    
    //Load instruments module
    [self LogMessage:@"Loading instruments..." Level:MSG_LEVEL_NORMAL];
    BOOL bSelfTest = [checkSelfTest state];
    for (NSString * pathInstrument in [dicConfig objectForKey:@kInstruments])
    {
        [self LogMessage:[NSString stringWithFormat:@"Loading Instrument : %@",pathInstrument] Level:MSG_LEVEL_NORMAL];
        if ([tm LoadInStrument:pathInstrument withSelfTest:bSelfTest])
        {
            [self LogMessage:[NSString stringWithFormat:@"Loading Instrument : %@ failed!",pathInstrument] Level:MSG_LEVEL_ERROR];
            continue;
        }
        else {
            [self LogMessage:@"Self test..." Level:MSG_LEVEL_NORMAL];
            [self LogMessage:[NSString stringWithFormat:@"Loading Instrument : %@ successful!",pathInstrument] Level:MSG_LEVEL_NORMAL];
        }
    }
    
    
    //Load Script
    //Config lua script search path
    NSBundle * bundle = [NSBundle bundleForClass:[self class]];
    NSString * str = [NSString stringWithFormat:@"package.path = package.path..';'..'%@'..'/?.lua'",[[[bundle resourcePath] stringByAppendingPathComponent:@"../Script"] stringByResolvingSymlinksInPath]];
    
    //add script folder in current directory
    NSString * strScript = [[[bundle bundlePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Script"];
    //str = [NSString stringWithFormat:@"%@..';%@/?.lua'",str,strScript];
    str = [NSString stringWithFormat:@"%@..';%@/?.lua'..';'..'%@/?.imp'",str,strScript,strScript];
    
    [tm LoadString:[str UTF8String]];
    
    
    //add script folder in current directory
    strScript = [[[bundle bundlePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Profile"];
    //str = [NSString stringWithFormat:@"%@..';%@/?.lua'",str,strScript];
//    str = [NSString stringWithFormat:@"%@..';%@/?.lua'..';'..'%@/?.imp'",str,strScript,strScript];
    
    [tm LoadString:[str UTF8String]];
    
    [tm LoadScript:[[bundle resourcePath] stringByAppendingPathComponent:@"/Global.lua"]];
    
    [self LogMessage:@"Loading script..." Level:MSG_LEVEL_NORMAL];
    for (NSString * pathScript in [dicConfig objectForKey:@kScript])
    {
        if (![pathScript isAbsolutePath])
        {
            pathScript = [[bundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"../Script/%@",pathScript]];
        }
        
        [self LogMessage:[NSString stringWithFormat:@"Register Script : %@",pathScript] Level:MSG_LEVEL_NORMAL];
        if ([tm LoadScript:pathScript])
        {
            [self LogMessage:[NSString stringWithFormat:@"Register Script : %@ failed!",pathScript] Level:MSG_LEVEL_ERROR];
            continue;
        }
        else {
            [self LogMessage:[NSString stringWithFormat:@"Register Script : %@ successful!",pathScript] Level:MSG_LEVEL_NORMAL];
        }
    }
    
    
    [NSThread sleepForTimeInterval:1.0];
    
    NSString * pathUI = [dicConfig objectForKey:@kUIPath];
    [self LogMessage:[NSString stringWithFormat:@"Loading UI : %@",pathUI] Level:MSG_LEVEL_NORMAL];
    if ([tm LoadUI:pathUI])
    {
        [self LogMessage:[NSString stringWithFormat:@"Loading UI : %@ failed!",pathUI] Level:MSG_LEVEL_ERROR];
    }
    else {
        [self LogMessage:[NSString stringWithFormat:@"Loading UI : %@ successful!",pathUI] Level:MSG_LEVEL_NORMAL];
    }
    
    return 0;
}
//
//
-(int)Log:(NSDictionary *)dic
{
    @try {
        NSString * msg = [dic objectForKey:@"msg"];
        msg = [msg stringByAppendingString:@"\r\n"];
        MSG_LEVEL level = (MSG_LEVEL)[[dic objectForKey:@"level"]intValue];
        
        NSInteger length = 0;
        NSAttributedString *theString;
        NSRange theRange;
        
        NSColor * color;
        switch (level) {
            case MSG_LEVEL_NORMAL:
                color = [NSColor blueColor];
                break;
            case MSG_LEVEL_ERROR:
                color = [NSColor redColor];
                NSRunAlertPanel(@"Load Modules", @"%@", @"OK", nil, nil, msg);
                break;
            case MSG_LEVEL_WARNNING:
                color = [NSColor orangeColor];
                break;
            default:
                break;
        }
        
        theString = [[NSAttributedString alloc] initWithString:msg attributes:[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName]];
        [[txtLogView textStorage] appendAttributedString: theString];
        length = [[txtLogView textStorage] length];
        theRange = NSMakeRange(length, 0);
        [txtLogView scrollRangeToVisible:theRange];
        [theString release];
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }
    return 0;
}


-(int)LogMessage:(NSString*)msg Level:(MSG_LEVEL)level
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:msg,@"msg",[NSNumber numberWithInt:level],@"level", nil];
    [self performSelectorOnMainThread:@selector(Log:) withObject:dic waitUntilDone:YES];
//    [self Log:dic];
    [[NSRunLoop currentRunLoop]runUntilDate:[NSDate date]];
    return 0;
}


#pragma mark Action
-(IBAction)OnMenuAbout:(id)sender
{
    NSString * str = [tm GetInformation];
    [txtAboutInformation setString:str];
    [panelAbout center];
    [panelAbout makeKeyAndOrderFront:nil];
    
}
-(IBAction)btOk:(id)sender
{
    [panelAbout orderOut:nil];
}

-(IBAction)OnMenuLogin:(id)sender
{
    if (pCurrUser)
    {
        if (NSRunAlertPanel(@"Login", @"Are your sure to logout?", @"NO", @"YES", nil)==0)
        {
            [menuLogin setTitle:@"Login"];
            pCurrUser = NULL;
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDoChangeUser object:nil userInfo:nil];
        }
    }
    else {
        if ([NSApp runModalForWindow:winLogin]==YES)
        {
            pCurrUser = m_pUserInformation->GetCurrentUser();
            [menuLogin setTitle:@"Logout"];
            USER_INFOR * pUser = m_pUserInformation->GetCurrentUser();
            NSDictionary * dicUser = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:pUser->szName],kLoginUserName,[NSString stringWithUTF8String:pUser->szPassword],kLoginUserPassword,[NSNumber numberWithInt:pUser->Authority],kLoginUserAuthority, nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDoChangeUser object:nil userInfo:dicUser];
        }
    }
}

-(IBAction)OnMenuUserManagement:(id)sender
{
    [panelUserManagement center];
    [panelUserManagement makeKeyAndOrderFront:nil];
}
- (BOOL)validateUserInterfaceItem:(id < NSValidatedUserInterfaceItem >)anItem
{
    if ([anItem action]==@selector(OnMenuUserManagement:))
    {
        if (pCurrUser)
        {
            return pCurrUser->Authority==AUTHORITY_ADMIN;
        }
        else {
            return NO;
        }
    }
    return YES;
}

#pragma mark Log Notification Obbserver
-(void)OnLogMessage:(NSNotification * )nf
{
    NSDictionary * dicUser = [nf userInfo];
    [self Log:dicUser];
    [[NSRunLoop currentRunLoop]runUntilDate:[NSDate date]];
}

#pragma mark tm list data source
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [self.listOfTmFiles count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    if ([[aTableColumn identifier] isEqualToString:@"index"])
    {
        return [[NSNumber numberWithInteger:rowIndex] stringValue];
    }
    else if([[aTableColumn identifier] isEqualToString:@"path"])
    {
        return [self.listOfTmFiles objectAtIndex:rowIndex];
    }
    else if([[aTableColumn identifier] isEqualToString:@"title"])
    {
        NSBundle *mb   = [NSBundle mainBundle];
        NSString *mbp  = [[mb bundlePath] stringByDeletingLastPathComponent];
        NSString *path = [mbp stringByAppendingPathComponent:[self.listOfTmFiles objectAtIndex:rowIndex]];
        
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
        
        return [dic valueForKey:@kProjectName];
    }
    
    return nil;
}

-(IBAction)DblClickOnTableView:(id)sender
{
    NSInteger row = [tvTMList selectedRow];
    if (row<0) return;
    [winTmFile orderOut:nil];
    [self StartUpWithTmFile:[[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:[self.listOfTmFiles objectAtIndex:row]]];
}


-(void)CheckLogin:(id)sender
{
    id login = [m_dicConfiguration valueForKey:@kLogin];
    BOOL bAutoLogin = NO;
    NSString * strUser=@"";
    NSString * strPwd =@"";
    if (login)
    {
        id t = [login valueForKey:@kAutoLogin];
        if (t)
        {
            bAutoLogin = [t boolValue];
        }
        t = [login valueForKey:@kAutoUserName];
        if (t)
        {
            strUser = t;
        }
        t = [login valueForKey:@kAutoPassword];
        if (t)
        {
            strPwd = t;
        }
    }
    if (bAutoLogin)
    {
        USER_INFOR u;
        memset(&u, 0, sizeof(u));
        strcpy(u.szName, [strUser UTF8String]);
        strcpy(u.szPassword, [strPwd UTF8String]);
        if (m_pUserInformation->CheckUser(u))
        {
            pCurrUser =  m_pUserInformation->GetCurrentUser();
            return; //login successful
        }
    }
    
    //show login diags
    if ([NSApp runModalForWindow:winLogin]==YES)
    {
        [menuLogin setTitle:@"Logout"];
        pCurrUser = m_pUserInformation->GetCurrentUser();
    }
    else {
        [NSApp terminate:nil];
    }
}

- (NSString *) autoLoadTm
{
    NSString * stationType = [self ghStationType];
    
    NSString * applicationPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    NSDictionary * autoLoadPlist = [NSDictionary dictionaryWithContentsOfFile:[applicationPath stringByAppendingPathComponent:@"AutoLoad.plist"]];
    NSDictionary * tmLookUp = [autoLoadPlist objectForKey:@"TM"];
    
    if (stationType && tmLookUp)
    {
        return [tmLookUp objectForKey:stationType];
    }
    
    return  nil;
}
// We do this here because we haven't loaded InstantPudding library yet.
- (NSString *) ghStationType
{
    NSString * stationType = nil;
    NSString * ghStationInfoContent = [NSString stringWithContentsOfFile:@"/vault/data_collection/test_station_config/gh_station_info.json"
                                                                encoding:NSUTF8StringEncoding error:nil];
    NSData * ghStationInfoData = [ghStationInfoContent dataUsingEncoding:NSUTF8StringEncoding];
    if (ghStationInfoData)
    {
        NSDictionary * ghStationInfo = [NSJSONSerialization JSONObjectWithData:ghStationInfoData
                                                                       options:0
                                                                         error:nil];
        NSDictionary * ghInfo = [ghStationInfo objectForKey:@"ghinfo"];
        if (ghInfo)
        {
            stationType = [ghInfo objectForKey:@"STATION_TYPE"];
        }
    }
    return stationType;
}


#pragma mark - Manuel's Document Bundle

- (BOOL) application:(NSApplication *)sender openFile:(NSString *)filename
{
    /*
     * XXX : mpetit : connect this to the UI, and load only if no test is running
     */
    return NO;
}


#pragma mark - Properties
@synthesize listOfTmFiles = _listOfTmFiles;


@end

