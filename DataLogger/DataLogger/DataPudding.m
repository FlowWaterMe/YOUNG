//
//  DataPudding.m
//  TestDataPudding
//
//  Created by Liu Liang on 13-3-17.
//  Copyright (c) 2013年 Liu Liang. All rights reserved.
//

#import "DataPudding.h"

@implementation DataPudding

- (id)puddingInit:(NSString*)strMlbSn sw_ver:(NSString*)strSoftwareVer sw_name:(NSString*)strSoftwareName limit_ver:(NSString*)strLimitVer unit_position:(int)pos
{
    
    //self = [super init];
    if (self)
    {
        if ((strMlbSn && strSoftwareVer && strSoftwareName && strLimitVer) == NO)
        {
            [self release];
            return nil;
        }
        ipMlbSn =               [NSString stringWithString:strMlbSn];
        ipSoftwareVersion =     [NSString stringWithString:strSoftwareVer];
        ipSoftwareName =        [NSString stringWithString:strSoftwareName];
        ipLimitVersion =        [NSString stringWithString:strLimitVer];
        
        //creat a globle IP_UUTHandle, every UUT has one IP_UUTHandle
        IP_API_Reply reply;
        reply = IP_UUTStart(&ipHandle);
        if ( !IP_success( reply ) )
        {
            if ( IP_reply_isOfClass( reply, IP_MSG_CLASS_PROCESS_CONTROL/*process control*/) )
            {
                // this is a fatal error
                NSLog(@"fatal error: %@", [NSString stringWithCString:IP_reply_getError(reply) encoding:NSASCIIStringEncoding]);
            }
            else
            {
                NSLog(@"ip reply error: failed to invoke IP_UUTStart");
            }
            //[self puddingDoneAndCommit:NO]; //if fatal error do then go to the IP_UTTDone and IP_UTTCommit.
            [self release];
            return nil;
        }
        
        NSLog(@"IP_UUTStart ok");
        
        IP_reply_destroy(reply);
        BOOL bResult = [self puddingAddAttribute:[NSString stringWithUTF8String:IP_ATTRIBUTE_SERIALNUMBER] andKeyValue:ipMlbSn];
        if (bResult == NO)
        {
            NSLog(@"pudding sn fail");
            [self release];
            return nil;
        }
        bResult = [self puddingAddAttribute:[NSString stringWithUTF8String:IP_ATTRIBUTE_STATIONSOFTWAREVERSION] andKeyValue:ipSoftwareVersion];
        if (bResult == NO)
        {
            NSLog(@"pudding sw ver fail");
            [self release];
            return nil;
        }
        bResult = [self puddingAddAttribute:[NSString stringWithUTF8String:IP_ATTRIBUTE_STATIONSOFTWARENAME] andKeyValue:ipSoftwareName];
        if (bResult == NO)
        {
            NSLog(@"pudding sw name fail");
            [self release];
            return nil;
        }
        //bResult= [self puddingAddAttribute:[NSString stringWithUTF8String:IP_ATTRIBUTE_STATIONIDENTIFIER] andKeyValue:strStationIdentifier];
        bResult= [self puddingAddAttribute:[NSString stringWithUTF8String:IP_ATTRIBUTE_STATIONLIMITSVERSION] andKeyValue:ipLimitVersion];
        if (bResult == NO)
        {
            NSLog(@"pudding limit ver fail");
            [self release];
            return nil;
        }
        NSLog(@"Add basic attributes ok");
        
        /*
        bResult= [self puddingAddAttribute:[NSString stringWithUTF8String:IP_ATTRIBUTE_STATIONIDENTIFIER] andKeyValue:@"FCT"];
        if (bResult == NO)
        {
            NSLog(@"pudding station identifier fail");
            [self release];
            return nil;
        }
        NSLog(@"Add basic attributes ok");
         */

		//[self SetDutPosition:1 withHeadID:(enum IP_ENUM_FIXTURE_HEAD_ID)(pos+1)];
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (BOOL)puddingCheckAmIOk:(NSString*)strMLBSN :(NSMutableString*)strErrMsg
{
	// Am I Okay
	//check fatal error from the reply object
	//
    IP_API_Reply reply = IP_amIOkay(ipHandle,[strMLBSN UTF8String]);
	if ( !IP_success( reply ) )
	{
		if ( IP_reply_isOfClass( reply, IP_MSG_CLASS_PROCESS_CONTROL/*process control*/) )
		{
			// this is a fatal error
            if (nil != strErrMsg)
                [strErrMsg setString:[NSString stringWithCString:(char*)IP_reply_getError(reply) encoding:NSUTF8StringEncoding]];
        }
        else
        {
            if (nil != strErrMsg)
                [strErrMsg setString:@"ip reply error: failed to invoke IP_amIOkay"];
        }
        //[self puddingDoneAndCommit:NO];  //if fatal error do then go to the IP_UTTDone and IP_UTTCommit.
        return  NO;
	}
    
    NSLog(@"IP_amIOkay ok");
    
    if (nil != strErrMsg)
        [strErrMsg setString:PUDDING_OK];
	IP_reply_destroy(reply);
    return YES;
}

- (BOOL)puddingAddAttribute:(NSString*)strKey andKeyValue:(NSString*)strValue
{
	bool bRetValue=YES;
	
	IP_API_Reply reply = IP_addAttribute( ipHandle,[strKey UTF8String] ,[strValue	UTF8String]);
	if ( !IP_success( reply ) )
	{
		if ( IP_reply_isOfClass( reply, IP_MSG_CLASS_PROCESS_CONTROL/*process control*/) )
		{
			// this is a fatal error
			NSLog(@"fatal error: %s", IP_reply_getError(reply));
		}
        else
        {
            NSLog(@"ip reply error: failed to invoke IP_addAttribute");
        }
        bRetValue = NO;
	}
    else
    {
        NSLog(@"Pudding Attribute,with key=%@ value=%@",strKey,strValue);
        NSLog(@"IP_addAttribute ok");
    }
    
    
	IP_reply_destroy(reply);
	return bRetValue;
}

- (BOOL)puddingDoneAndCommit:(BOOL)bIsPriorAllTestItemPass
{
    enum IP_PASSFAILRESULT emIPResult=IP_PASS;
	BOOL bRetValue = YES;
    
	IP_API_Reply doneReply = IP_UUTDone(ipHandle);
	if ( !IP_success( doneReply ) )
	{
		if ( IP_reply_isOfClass( doneReply, IP_MSG_CLASS_PROCESS_CONTROL/*process control*/) )
		{
			// this is a fatal error
			NSLog(@"fatal error: %s", IP_reply_getError(doneReply));
		}
        else
        {
            NSLog(@"ip reply error: %@", @"failed to invoke IP_UUTDone");
        }
        bRetValue = NO;
	}
    
    NSLog(@"IP_UUTDone ok");
    
	IP_reply_destroy(doneReply);
    if((bIsPriorAllTestItemPass==NO)||(bRetValue==NO))
        emIPResult=IP_FAIL;
    NSLog(@"bIsPriorAllTestItemPass=%d",(int)bIsPriorAllTestItemPass);
    NSLog(@"commit result= %d",(int)emIPResult);
	
	IP_API_Reply commitReply = IP_UUTCommit(ipHandle, emIPResult);
	if ( !IP_success( commitReply ) )
	{
		if ( IP_reply_isOfClass( commitReply, IP_MSG_CLASS_PROCESS_CONTROL/*process control*/) )
		{
			// this is a fatal error
			NSLog(@"fatal error: %s", IP_reply_getError(commitReply));
		}
        else
        {
            NSLog(@"ip reply error: %@", @"failed to invoke IP_UUTCommit");
        }
        bRetValue = NO;
	}
    
    NSLog(@"IP_UUTCommit ok");
    
	IP_reply_destroy(commitReply);
	IP_UID_destroy(ipHandle);
	
	return bRetValue;
}

- (BOOL)puddingParametricDataForTestItem:(NSString *)testName
                              SubTestItem:(NSString *)SubTestItem
                           SubSubTestItem:(NSString *)SubSubTestItem
                                 LowLimit:(NSString *)LowLimit
                                  UpLimit:(NSString *)UpLimit
                                TestValue:(NSString *)TestValue
                                 TestUnit:(NSString *)TestUnit
                               TestResult:(enum IP_PASSFAILRESULT)TestResult
                                  FailMsg:(NSString *)FailMsg
                                 Priority:(enum IP_PDCA_PRIORITY)Priority
{
    if (testName==nil || FailMsg==nil)
    {
        NSLog(@"invalid parameters for invoking Pudding_ParametricDataForTestItem");
        return NO;
    }
    
    if ([FailMsg length]>=512)
    {
        NSLog(@"FailMsgTestName=%@",testName);
        NSLog(@"FailMsgLength==%d",(int)[FailMsg length]);
        NSLog(@"too long fail message= %@",FailMsg);
        return NO;
    }
    
	bool APIcheck = true;
	IP_TestSpecHandle testSpec = IP_testSpec_create();
	if (nil	!= testSpec)
	{
		APIcheck &= IP_testSpec_setTestName(testSpec, [testName	UTF8String], [testName length]);
		APIcheck &= IP_testSpec_setSubTestName(testSpec, [SubTestItem UTF8String], [SubTestItem length]);
		APIcheck &= IP_testSpec_setSubSubTestName(testSpec, [SubSubTestItem UTF8String], [SubSubTestItem length]);
		APIcheck &= IP_testSpec_setLimits(testSpec, [LowLimit UTF8String],[LowLimit length],[UpLimit UTF8String], [UpLimit length]);
		APIcheck &= IP_testSpec_setUnits(testSpec, [TestUnit UTF8String],[TestUnit length]);
		APIcheck &= IP_testSpec_setPriority(testSpec, Priority);
    }
	
	IP_TestResultHandle testResult = IP_testResult_create();
	if (nil != testResult)
	{
		APIcheck &= IP_testResult_setResult(testResult, TestResult);
		APIcheck &= IP_testResult_setValue(testResult, [TestValue UTF8String], [TestValue length]);
		APIcheck &= IP_testResult_setMessage(testResult, [FailMsg UTF8String], [FailMsg	length]);
	}
    if (!APIcheck)
        NSLog(@"warning: failed to invoke ip api");
    
    NSLog(@"PuddingParameter testName= %@,SubTestItem=%@,SubSubTestItem=%@,TestValue=%@,FailMsg=%@,Priority=%d",
          testName,SubTestItem,SubSubTestItem,TestValue,FailMsg,Priority);
    
	IP_API_Reply  addResultreply = IP_addResult(ipHandle, testSpec, testResult);
	if (!IP_success(addResultreply))
	{
        const char * perror =IP_reply_getError(addResultreply);
        NSLog(@"ip reply error: failed to invoke IP_addResult with Error :");
        if (perror)
        {
            printf("%s\r\n",perror);
        }
        
		IP_API_Reply cancelreply = IP_UUTCancel(ipHandle);
		IP_reply_destroy(cancelreply);
		IP_reply_destroy(addResultreply);
		IP_UID_destroy(ipHandle);
        NSLog(@"ip reply error: failed to invoke IP_addResult");
		return NO;
	}
    
    NSLog(@"IP_addResult ok");
    
	IP_reply_destroy(addResultreply);
	IP_testResult_destroy(testResult);
	IP_testSpec_destroy(testSpec);
	return YES;
    
    
}

//2013.5.31
//returnvalue = [self Pudding_BlobWithNameInPDCA:dictKeyDefined NameInPDCA:@"DFU" FilePath:strFileName];
//if( returnvalue == NO)
- (BOOL)puddingBlobWithNameInPDCA:(NSString *)nameInPDCA FilePath:(NSString *)FilePath
{
    IP_API_Reply reply = IP_addBlob(ipHandle, [nameInPDCA UTF8String],[FilePath	UTF8String]);
	if (!IP_success(reply))
	{
		IP_API_Reply cancelreply = IP_UUTCancel(ipHandle);
		IP_reply_destroy(cancelreply);
		IP_reply_destroy(reply);
		IP_UID_destroy(ipHandle);
		return NO;
	}
	IP_reply_destroy(reply);
	return YES;
}
  
 //SFC query record here get the result OK or Fail
- (void)addRecordToSFC:(NSString*)strInfoToAdd
{
    //const char * SFCAddRecord(char** cppParams);
    if ([strInfoToAdd length] == 0)
        return;
    char* szInfoToAdd = (char*)malloc([strInfoToAdd length]*sizeof(char));
    const char* pszRtn = SFCAddRecord(&szInfoToAdd);
    NSLog(@"addRecordToSFC returned: %@", [NSString stringWithUTF8String:pszRtn]);
}

- (void)queryRecordFromSFC:(NSString*)strStationName :(NSArray*)arrKeyToQuery :(NSMutableArray*)maValueForKey
{ 
    //
    //get query record from SFC
    //
    if (!(arrKeyToQuery && maValueForKey))
        return;
    if ([arrKeyToQuery count] >0)
    {
        struct QRStruct **ptr2ptr2QRStruct = (struct QRStruct **) malloc(([arrKeyToQuery count]+1)*sizeof(struct QRStruct *));
        //struct QRStruct **ptr2ptr2QRStruct = (struct QRStruct **) malloc(sizeof(struct QRStruct *));
        for (int i=0; i<[arrKeyToQuery count]; i++)
        {
            ptr2ptr2QRStruct[i] = (struct QRStruct *) malloc(sizeof(struct QRStruct ));
            ptr2ptr2QRStruct[i]->Qkey = (char *)malloc(1024*sizeof(char));
            ptr2ptr2QRStruct[i]->Qval = (char *)malloc(1024*sizeof(char));
            strcpy (ptr2ptr2QRStruct[i]->Qkey,[(NSString*)[arrKeyToQuery objectAtIndex:i] cStringUsingEncoding:NSASCIIStringEncoding]);
        }
        
        //int state = SFCQueryRecordGetTestResult([ipMlbSn UTF8String],"FCT",ptr2ptr2QRStruct ,(int)[arrKeyToQuery count]);
        int state = SFCQueryRecordGetTestResult([ipMlbSn UTF8String],[strStationName UTF8String],ptr2ptr2QRStruct ,(int)[arrKeyToQuery count]);
        
        //for test
        if(state == 0)
        {
            for(int i=0; i<[arrKeyToQuery count]; i++)
            {
                [maValueForKey addObject:[NSString stringWithUTF8String:ptr2ptr2QRStruct[i]->Qval]];
                NSLog(@"Key: %@  Value: %@",[NSString stringWithUTF8String:ptr2ptr2QRStruct[i]->Qkey],
                      [NSString stringWithUTF8String:ptr2ptr2QRStruct[i]->Qval]);
            }
        }
        for(int i=0;i<[arrKeyToQuery count];i++)
        {
            free(ptr2ptr2QRStruct[i]->Qval);
            free(ptr2ptr2QRStruct[i]->Qkey);
        }
        free(ptr2ptr2QRStruct);
    }
    return ;
}

-(void)showMessageBoxWithTitle:(NSString *)title
{
	NSRunAlertPanel(@"Alert!", @"%@", @"Ok", nil, nil, title);

}

IP_API_Reply IP_setDUTPos(IP_UUTHandle handleDUTPosition,const char * cpFixId,const char * cpHeadId);

-(BOOL)SetDutPosition:(int)fixtureID withHeadID:(int)HeadID
{
    IP_API_Reply reply = IP_setDUTPos(ipHandle, [[NSString stringWithFormat:@"%d",fixtureID] UTF8String], [[NSString stringWithFormat:@"%d",HeadID] UTF8String]);
    if (!IP_success(reply))
    {
        const char * p = IP_reply_getError(reply);
        if (p)
        {
            [self performSelectorOnMainThread:@selector(showMessageBoxWithTitle:) withObject:[NSString stringWithFormat:@"Set DutPosition failed:\r\n%s",p] waitUntilDone:NO];
        }
        IP_reply_destroy(reply);
        return NO;
    }
    IP_reply_destroy(reply);
    return YES;
}

+(void)querySFC:(NSString *)mlbSN StationName:(NSString *)strStationName Keys:(NSArray *)arrKeyToQuery Result:(NSMutableArray *)maValueForKey
{
    //
    //get query record from SFC
    //
    if (!(arrKeyToQuery && maValueForKey))
        return;
    if ([arrKeyToQuery count] >0)
    {
        struct QRStruct **ptr2ptr2QRStruct = (struct QRStruct **) malloc(([arrKeyToQuery count]+1)*sizeof(struct QRStruct *));
        //struct QRStruct **ptr2ptr2QRStruct = (struct QRStruct **) malloc(sizeof(struct QRStruct *));
        for (int i=0; i<[arrKeyToQuery count]; i++)
        {
            ptr2ptr2QRStruct[i] = (struct QRStruct *) malloc(sizeof(struct QRStruct ));
            ptr2ptr2QRStruct[i]->Qkey = (char *)malloc(1024*sizeof(char));
            ptr2ptr2QRStruct[i]->Qval = (char *)malloc(1024*sizeof(char));
            strcpy (ptr2ptr2QRStruct[i]->Qkey,[(NSString*)[arrKeyToQuery objectAtIndex:i] cStringUsingEncoding:NSASCIIStringEncoding]);
        }
        
        //int state = SFCQueryRecordGetTestResult([ipMlbSn UTF8String],"FCT",ptr2ptr2QRStruct ,(int)[arrKeyToQuery count]);
        int state = SFCQueryRecordGetTestResult([mlbSN UTF8String],[strStationName UTF8String],ptr2ptr2QRStruct ,(int)[arrKeyToQuery count]);
        
        //for test
        if(state == 0)
        {
            for(int i=0; i<[arrKeyToQuery count]; i++)
            {
                [maValueForKey addObject:[NSString stringWithUTF8String:ptr2ptr2QRStruct[i]->Qval]];
                NSLog(@"Key: %@  Value: %@",[NSString stringWithUTF8String:ptr2ptr2QRStruct[i]->Qkey],
                      [NSString stringWithUTF8String:ptr2ptr2QRStruct[i]->Qval]);
            }
        }
        for(int i=0;i<[arrKeyToQuery count];i++)
        {
            free(ptr2ptr2QRStruct[i]->Qval);
            free(ptr2ptr2QRStruct[i]->Qkey);
        }
        free(ptr2ptr2QRStruct);
    }
    return ;

}

+(BOOL)CheckProcessControl:(NSString *)mlbSN withErrorMsg:(NSMutableString *)msg
{
    NSLog(@"Start check process in objec-c.");
    if (!mlbSN)
    {
        NSLog(@"Check process control fail,no mlb sn!");
        return NO;
    }
    
    //creat a globle IP_UUTHandle, every UUT has one IP_UUTHandle
    IP_API_Reply reply;
    IP_UUTHandle Handle;
    reply = IP_UUTStart(&Handle);
    if ( !IP_success( reply ) )
    {
        if ( IP_reply_isOfClass( reply, IP_MSG_CLASS_PROCESS_CONTROL/*process control*/) )
        {
            // this is a fatal error
            NSLog(@"fatal error: %@", [NSString stringWithCString:IP_reply_getError(reply) encoding:NSASCIIStringEncoding]);
            if (msg)
            {
                [msg setString:[NSString stringWithCString:IP_reply_getError(reply) encoding:NSASCIIStringEncoding]];
            }
        }
        else
        {
            NSLog(@"ip reply error: failed to invoke IP_UUTStart!");
            [msg setString:@"ip reply error: failed to invoke IP_UUTStart!"];
        }
        return NO;;
    }
    IP_reply_destroy(reply);
    
    NSLog(@"Check process control in object-c ok!");
    IP_UID_destroy(Handle);
    return YES;
    
}
@end
