//
//  GT_DataLogger.h
//  DataLogger
//
//  Created by Ryan on 12-9-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreLib/DriverModule.h>
@interface GT_DataLogger : NSObject<DriverModule>{
}
-(NSString *)ModuleName;           //模块名称说明
-(int)RegisterModule:(id)sender;     //登记模块
@end
