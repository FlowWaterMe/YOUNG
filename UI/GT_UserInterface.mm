//
//  GT_UserInterface.m
//  UI
//
//  Created by Hogan on 17/8/4.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import "GT_UserInterface.h"
//#include <lua.hpp>
//#include <tolua++.h>
//
//#include "UI_Global.h"
//#include "Corelib/TestItem.h"
@implementation GT_UserInterface
#define Config_File @"config.plist"
TestEngine * m_pTestEngine = nil;
NSTreeNode * items = nil;
-(id)init
{
    self = [super init];
    if(self)
    {
        m_dicConfiguration = [NSMutableDictionary new];
    }
    return self;
}

-(void)dealloc
{
    [m_dicConfiguration release];
    [super dealloc];
}

-(NSString *)ModuleName
{
    return @"Tester User Interface.";
}

-(int)RegisterModule:(id)sender     //登记模块
{
    return 0;
}
-(int)SelfTest:(id)sender          //模块自我测试
{
    return 0;
}
-(int)Load:(id)sender
{
    [NSBundle loadNibNamed:@"UIV1" owner:self];
//    NSMenu * mainMenu = [NSApp mainMenu];
//    NSMenu * appMenu = [[mainMenu itemAtIndex:0]submenu];
//    [appMenu setTitle:@"HY V1.0"];
    return 0;
}
-(int)Unload:(id)sender
{
    return 0;
}


@end
