//
//  DriverModule.h
//  HYTestManager
//
//  Created by Hogan on 17/8/3.
//  Copyright © 2017年 com.Young. All rights reserved.
//
#import <Foundation/Foundation.h>
#include "Common.h"

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
