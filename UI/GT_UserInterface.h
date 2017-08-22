//
//  GT_UserInterface.h
//  UI
//
//  Created by Hogan on 17/8/4.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#include "CoreLib/DriverModule.h"
#include "CoreLib/TestEngine.h"
#include "CoreLib/ScriptEngine.h"
#include "CoreLib/TestContext.h"

extern TestEngine * m_pTestEngine;
extern NSTreeNode * items;

@interface GT_UserInterface : NSObject<DriverModule>
{
    NSMutableDictionary * m_dicConfiguration;
    IBOutlet NSMenu * instrMenu;
    IBOutlet NSWindow * winLogin;
}
@end
