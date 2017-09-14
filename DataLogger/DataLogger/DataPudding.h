//
//  DataPudding.h
//  TestDataPudding
//
//  Created by Liu Liang on 13-3-17.
//  Copyright (c) 2013年 Liu Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPSFCPost_API.h"
#import "InstantPudding_API.h"

#define PUDDING_ERROR		@"fatal error"
#define PUDDING_OK			@"ok"
#define PUDDING_FAIL		@"fail"

enum TestResutStatus
{
	RESULT_FOR_FAIL =0,
	RESULT_FOR_PASS =1,
	RESULT_FOR_COF =2 ,
	RESULT_FOR_BYPASS =3 ,
	RESULT_FOR_OTHER =4,
	RESULT_FOR_NOTEST =5,
	RESULT_FOR_TESTING =6,
	RESULT_FOR_DEFINE =RESULT_FOR_PASS ,
} ;


@interface DataPudding : NSObject
{
    IP_UUTHandle ipHandle;
    NSString* ipMlbSn;
    NSString* ipSoftwareVersion;
    NSString* ipSoftwareName;
    NSString* ipLimitVersion;
    NSString* ipFetalError;
}
//PDCA methods...
- (id)puddingInit:(NSString*)strMlbSn sw_ver:(NSString*)strSoftwareVer sw_name:(NSString*)strSoftwareName limit_ver:(NSString*)strLimitVer unit_position:(int)pos;

- (void)dealloc;

- (BOOL)puddingCheckAmIOk:(NSString*)strMLBSN :(NSMutableString*)strErrMsg;

- (BOOL)puddingAddAttribute:(NSString*)strKey andKeyValue:(NSString*)strValue;

- (BOOL)puddingDoneAndCommit:(BOOL)bIsPriorAllTestItemPass;

- (BOOL)puddingParametricDataForTestItem :(NSString*)testName
                              SubTestItem:(NSString*)SubTestItem
                           SubSubTestItem:(NSString*)SubSubTestItem
                                 LowLimit:(NSString*)LowLimit
                                  UpLimit:(NSString*)UpLimit
                                TestValue:(NSString*)TestValue
                                 TestUnit:(NSString*)TestUnit
                               TestResult:(enum IP_PASSFAILRESULT)TestResult
                                  FailMsg:(NSString*)FailMsg
                                 Priority:(enum IP_PDCA_PRIORITY)Priority;

- (BOOL)puddingBlobWithNameInPDCA:(NSString *)nameInPDCA FilePath:(NSString *)FilePath;

-(BOOL)SetDutPosition:(int)fixtureID withHeadID:(int)HeadID;

//SFC methods...
- (void)addRecordToSFC:(NSDictionary*)dictInfoToAdd;
- (void)queryRecordFromSFC:(NSString*)strStationName :(NSArray*)arrKeyToQuery :(NSMutableArray*)maValueForKey;

+(void)querySFC:(NSString *)mlbSN StationName:(NSString *)strStation Keys:(NSArray *)arrKey Result:(NSMutableArray *)arrResult;

+(BOOL)CheckProcessControl:(NSString *)mlbSN withErrorMsg:(NSMutableString *)msg;
@end
