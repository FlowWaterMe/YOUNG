//
//  Global_Variant.h
//  Global
//
//  Created by Hogan on 17/8/7.
//  Copyright © 2017年 com.Young. All rights reserved.
//
#import <Foundation/Foundation.h>
#include <CoreLib/TestEngine.h>
#include <CoreLib/DriverModule.h>
extern TestEngine *pTestEngine;
#define UUT_MODULE 1
@interface GT_Global : NSObject<DriverModule>
@end
