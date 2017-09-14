//
//  CsvReporter.h
//  DataLogger
//
//  Created by Ryan on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#include "Reporter.h"

@interface CsvReporter : NSObject<Reporter>{
@private
    NSString    *m_strFileHeader;
    
    NSMutableArray * m_arrCsvKey;
    NSMutableArray * m_arrCsvValue;
    NSMutableArray * m_arrCsvUpper;
    NSMutableArray * m_arrCsvLower;
    NSMutableArray * m_arrCsvUnit;

    NSMutableDictionary * m_dictCsvData;
    
	NSLock *m_lock;
}
-(void)setCSVtitle:(NSString *)Title;
//-(void) push_CSV:(NSString *)value;

-(void) push_keys:(NSString *)value;
-(void) push_values:(NSString *)value;
-(void) push_uppers:(NSString *)value;
-(void) push_lowers:(NSString *)value;
-(void) push_units:(NSString *)value;

@end
