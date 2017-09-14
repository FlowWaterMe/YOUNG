//
//  CBAuth.m
//  Global
//
//  Created by Herry on 9/14/17.
//  Copyright © 2017 com.Young. All rights reserved.
//
#import "CBAuth.h"
#import <CoreData/CoreData.h>
#define MAX_STATION 100
NSLock * lockCBApi = nil;

@implementation CBAuth
-(id)init{
    self = [super init];
    if(self)
    {
        lockCBApi = [[NSLock alloc] init];
        m_arrCBName = [[NSMutableArray alloc] init];
        m_arrCBNumber = [[NSMutableArray alloc] init];
        m_dicCBToCheck = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [lockCBApi release];
    [m_arrCBName release];
    [m_arrCBNumber release];
    [m_dicCBToCheck release];
    [super dealloc];
}
-(NSDictionary*)getControlBitsToCheck
{
    size_t len = 0;
    char* pArrNames[MAX_STATION];
    int pArrayCBNumber[MAX_STATION];
    memset(pArrNames, 0, sizeof(pArrNames));
    memset(pArrayCBNumber, 0, sizeof(pArrayCBNumber));
    
    [lockCBApi lock];
    [m_dicCBToCheck removeAllObjects];//remove all key-value pairs
    bool r = ControlBitsToCheck(NULL, &len, NULL);
    [lockCBApi unlock];
    if (r == true)
    {
        if (len > 0)
        {
            for (int i=0; i<len; i++) {
                void* p = malloc(256);
                if (p)
                {
                    pArrNames[i] = (char*)p;
                }
                else
                {
                    for (int i=0; i<len; i++) {
                        if (pArrNames[i]) {
                            free(pArrNames[i]);
                        }
                    }
                    return m_dicCBToCheck;
                }
            }
            [lockCBApi lock];
            r = ControlBitsToCheck(pArrayCBNumber, &len, pArrNames);
            [lockCBApi unlock];
            if (r == true)
            {
                for (int i=0; i<len; i++) {
                    [m_dicCBToCheck setObject:[NSNumber numberWithInt:pArrayCBNumber[i]] forKey:[NSString stringWithUTF8String:pArrNames[i]]];
                }
            }
        }
    }
    for (int i=0; i<len; i++) {
        if (pArrNames[i]) {
            free(pArrNames[i]);
        }
    }
    return m_dicCBToCheck;

}
-(int)getControlBitsMaxFailForStation
{
    [lockCBApi lock];
    int count = StationFailCountAllowed();
    [lockCBApi unlock];
    return count;
}
-(NSArray*)getControlBitsToClearOnPass
{
    size_t len = 0;
    int pArrayCBNumber[MAX_STATION];
    
    [lockCBApi lock];
    [m_arrCBNumber removeAllObjects];
    bool r = ControlBitsToClearOnPass(NULL,&len);
    if (r)
    {
        if (len > 0)
        {
            r = ControlBitsToClearOnPass(pArrayCBNumber, &len);
            if (r) {
                for (int i=0; i<len; i++) {
                    [m_arrCBNumber addObject:[NSNumber numberWithInt:pArrayCBNumber[i]]];
                }
            }
        }
        else
        {
            
        }
    }
    else
    {
        
    }
    [lockCBApi unlock];
    return m_arrCBNumber;
}
-(NSArray*)getControlBitsToClearOnFail
{
    size_t len = 0;
    int pArrayCBNumber[MAX_STATION];
    
    [lockCBApi lock];
    [m_arrCBNumber removeAllObjects];
    bool r = ControlBitsToClearOnFail(NULL,&len);
    if (r)
    {
        if (len > 0)
        {
            r = ControlBitsToClearOnFail(pArrayCBNumber, &len);
            if (r) {
                for (int i=0; i<len; i++) {
                    [m_arrCBNumber addObject:[NSNumber numberWithInt:pArrayCBNumber[i]]];
                }
            }
        }
        else
        {
            
        }
    }
    else
    {
        
    }
    [lockCBApi unlock];
    return m_arrCBNumber;
}
-(bool)getStationSetControlBit
{
    [lockCBApi lock];
    bool r = StationSetControlBit();
    [lockCBApi unlock];
    return r;
}

-(NSArray*)getControlBitsToCheck:(NSMutableArray*)stationNamesToCheck
{
    size_t len = 0;
    char* pArrNames[MAX_STATION];
    int pArrayCBNumber[MAX_STATION];
    memset(pArrNames, 0, sizeof(pArrNames));
    memset(pArrayCBNumber, 0, sizeof(pArrayCBNumber));
    NSMutableArray* marrCBNumber = [[[NSMutableArray alloc] init] autorelease];
    [lockCBApi lock];
    bool r = ControlBitsToCheck(NULL, &len, NULL);
    [lockCBApi unlock];
    if (r == true)
    {
        if (len > 0)
        {
            for (int i=0; i<len; i++) {
                void* p = malloc(256);
                if (p)
                {
                    pArrNames[i] = (char*)p;
                }
                else
                {
                    
                }
            }
            [lockCBApi lock];
            r = ControlBitsToCheck(pArrayCBNumber, &len, pArrNames);
            [lockCBApi unlock];
            if (r == true)
            {
                for (int i=0; i<len; i++) {
                    [stationNamesToCheck addObject:[NSString stringWithUTF8String:pArrNames[i]]];
                    [marrCBNumber addObject:[NSNumber numberWithInt:pArrayCBNumber[i]]];
                }
            }
            else
            {
                
            }
        }
    }
    else
    {
        
    }
    for (int i=0; i<len; i++) {
        if (pArrNames[i]) {
            free(pArrNames[i]);
        }
    }
    return marrCBNumber;
}


@end
