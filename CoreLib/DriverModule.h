//
//  DriverModule.h
//  UI
//
//  Created by Hogan on 17/8/4.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#ifndef DriverModule_h
#define DriverModule_h
#import <Foundation/Foundation.h>
#include "Common.h"
#define CMD_SAVE_LOG     0x00        //Save log


@protocol DriverModule <NSObject>
@required
-(NSString *)ModuleName;           //模块名称说明
-(int)RegisterModule:(id)sender;     //登记模块
-(int)SelfTest:(id)sender;          //模块自我测试
-(int)Load:(id)sender;
-(int)Unload:(id)sender;
@optional
-(int)DoConfig:(id)sender;
-(int)DoAction:(id)sender;
-(int)DoCmd:(int)cmd arg:(id)arg;
@end

#endif /* DriverModule_h */
