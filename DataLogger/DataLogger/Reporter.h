//
//  Reporter.h
//  DataLogger
//
//  Created by Ryan on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef DataLogger_Reporter_h
#define DataLogger_Reporter_h

#pragma once
#include "testReport.h"

@protocol Reporter <NSObject>
/*
-(id)   initWithStationInfo:(id)station_info andTestDefinition:(id)test_definition;
-(void) generateReport:(id)test_results withfilepath:(NSString *)filepath;
-(void) push_value:(NSString *)value withparameter:(id)parameter;
 */
-(void)generateReport:(id)sender;
-(void)flush;
@end


#endif
