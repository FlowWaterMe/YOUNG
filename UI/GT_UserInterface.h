//
//  GT_UserInterface.h
//  UI
//
//  Created by Hogan on 17/8/4.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#include "/Users/mac/Documents/程序/YOUNG/CoreLib//DriverModule.h"
#include "/Users/mac/Documents/程序/YOUNG/CoreLib/TestEngine.h"

extern TestEngine * m_pTestEngine;
extern NSTreeNode * items;

@interface GT_UserInterface : NSObject<DriverModule>
{
    NSMutableDictionary * m_dicConfiguration;
    IBOutlet NSMenu * instrMenu;
    IBOutlet NSWindow * winLogin;
}
@end
