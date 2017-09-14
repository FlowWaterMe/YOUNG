//
//  CBAuth.h
//  Global
//
//  Created by Herry on 9/14/17.
//  Copyright © 2017 com.Young. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CBAuth_API.h"
@interface CBAuth : NSObject
{
    NSMutableArray * m_arrCBName;
    NSMutableArray * m_arrCBNumber;
    NSMutableDictionary * m_dicCBToCheck;
    
}

-(NSDictionary*)getControlBitsToCheck;
-(int)getControlBitsMaxFailForStation;
-(NSArray*)getControlBitsToClearOnPass;
-(NSArray*)getControlBitsToClearOnFail;
-(bool)getStationSetControlBit;

@end
