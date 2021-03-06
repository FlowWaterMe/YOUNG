//
//  TestManager.h
//  HYTestManager
//
//  Created by Hogan on 17/8/3.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLib/CoreLib.h"
#include "CoreLib/TestEngine.h"

#include "CoreLib/DriverModule.h"
@interface TestManager : NSObject
{
    TestEngine *m_pTestEngine;
    NSString * m_CurrentPath;
    NSMutableArray * m_arrModules;
    NSMutableString * m_strInformation;
    BOOL m_bSelfTest;
}
-(int)LoadEngine:(NSString *)pathEngine;
-(int)LoadUI:(NSString *)pathUI;
-(int)LoadInStruments:(NSArray *)arrInstruments;
-(int)LoadInStrument:(NSString *)pathModule;
-(int)LoadInStrument:(NSString *)bundleName withSelfTest:(BOOL)bSelfTest;
-(int)LoadScript:(NSString *)pathScript;
-(int)LoadString:(const char *)string;
-(NSString *)GetInformation;

@end
