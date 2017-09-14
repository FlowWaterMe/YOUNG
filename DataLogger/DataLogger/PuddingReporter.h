//
//  PuddingReporter.h
//  DataLogger
//
//  Created by IvanGan on 12-5-2.
//
//

#import <Foundation/Foundation.h>
#include "Reporter.h"
#include "DataPudding.h"


//key
#define kPuddingItemName            @"Item_Name"
#define kPuddingItemSubName         @"Item_SubName"
#define kPuddingItemSubSubName      @"Item_SubSubName"
#define kPuddingItemLowLimit        @"Item_LowLimit"
#define kPuddingItemUpLimit         @"Item_UpLimit"
#define kPuddingItemValue           @"Item_Value"
#define kPuddingItemUnit            @"Item_Unit"
#define kPuddingItemResult          @"Item_Result"
#define kPuddingItemFailMsg         @"Item_FailMsg"
#define kPuddingPriority            @"Item_Priority"

@interface PuddingReporter : NSObject<Reporter>{
@private
    NSMutableDictionary * m_dicAttribute;
    NSMutableArray * m_arrItem;
    int m_TestResult;
    
    DataPudding * m_DataPudding;
}

- (DataPudding *)puddingInit:(NSString*)strMlbSn sw_ver:(NSString*)strSoftwareVer sw_name:(NSString*)strSoftwareName limit_ver:(NSString*)strLimitVer unit_position:(int)pos;

-(int)AddAttribute:(NSString *)key withValue:(NSString *)value;
-(int)AddItem:(NSDictionary *)dicItem;
-(int)SetResult:(int)result;

- (BOOL)PuddingBlob:(NSString*)name file:(NSString*)path;

-(BOOL)SetDutPosition:(int)fixtureID withHeadID:(int)HeadID;

-(BOOL)CheckAmIOk:(NSString * )mlbsn withErrrMsg:(NSMutableString *)msg;

@property (assign) DataPudding * m_DataPudding;
@end
