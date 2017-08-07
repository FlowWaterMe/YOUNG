//
//  GT_Engine.m
//  Engine
//
//  Created by Hogan on 17/8/3.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import "GT_Engine.h"

@implementation GT_Engine

-(id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code here.
        m_ModuleFinish=0;
        m_ModuleTesting = UUT_MODULE;
        
        dicModuleConfig = [NSMutableDictionary new];
        engineLock = [[NSLock alloc]init];
        for (int i=0; i<=UUT_MODULE-1; i++) {
            m_ScriptEngine[i] = new CScriptEngine();
            m_ScriptEngine[i]->Init();
            [self RegisterUUT_Variant:i];
            
            //Test Context
//            m_pTestContext[i] = new CTestContext();
        }
        
        //intial global
        [self InitConfig];
        
        //
        //Register Script
        NSBundle * bundle = [NSBundle bundleForClass:[self class]];
        NSString * str = [NSString stringWithFormat:@"package.path = package.path..';'..'%@'..'/?.lua'",[bundle resourcePath]];
        [self RegisterString:[str UTF8String]];
        NSString * pathScript = [bundle resourcePath];
        //[self RegisterScript:[pathScript stringByAppendingPathComponent:@"global.lua"]];
        [self RegisterScript:[pathScript stringByAppendingPathComponent:@"execute.lua"]];
        [self RegisterScript:[pathScript stringByAppendingPathComponent:@"TestSupport.lua"]];
    }
    return self;
}

-(void)dealloc
{
    [dicModuleConfig release];
    for (int i=0; i<=UUT_MODULE-1; i++) {
        delete m_ScriptEngine[i];
//        delete m_pTestContext[i];
//        m_pTestContext[i]=NULL;
    }
    [engineLock release];
    [super dealloc];
}


-(void)InitConfig
{
    //Initial Global Variant
//    [CTestContext::m_dicConfiguration setObject:[NSNumber numberWithInt:1] forKey:@kEngineUUT0Enable];
//    [CTestContext::m_dicConfiguration setObject:[NSNumber numberWithInt:1] forKey:@kEngineUUT1Enable];
//    [CTestContext::m_dicConfiguration setObject:[NSNumber numberWithInt:1] forKey:@kEngineUUT2Enable];
//    [CTestContext::m_dicConfiguration setObject:[NSNumber numberWithInt:1] forKey:@kEngineUUT3Enable];
//    [CTestContext::m_dicConfiguration setObject:[NSNumber numberWithInt:1] forKey:@kEngineUUT4Enable];
//    [CTestContext::m_dicConfiguration setObject:[NSNumber numberWithInt:1] forKey:@kEngineUUT5Enable];
//    [CTestContext::m_dicConfiguration setObject:[NSNumber numberWithInt:1] forKey:@kEngineUUT6Enable];
//    [CTestContext::m_dicConfiguration setObject:[NSNumber numberWithInt:1] forKey:@kEngineUUT7Enable];
}

//Control function
//Register Global Variant
-(int)RegisterUUT_Variant:(int)index
{
    //export ID into each unit
    NSString * str = [NSString stringWithFormat:@"ID=%d;",index];
    int err;
    err = m_ScriptEngine[index]->DoString([str UTF8String]);
    char * sz=NULL;
    if (err)
    {
        sz = (char *)lua_tostring(m_ScriptEngine[index]->m_pLuaState, -1);
    }
    return 0;
    
    //export usb location;
    str = [NSString stringWithFormat:@"USB_LOCATION=0xFA131000;"];
//    err = m_ScriptEngine[index]->DoString([str UTF8String]);
//    if (err)
//    {
//        sz = (char *)lua_tostring(m_ScriptEngine[index]->m_pLuaState, -1);
//    }
    return 0;
}

-(int)StartTest
{
    if ([self IsTesting:-1]) return -1;
//    //v1.2
    [m_threadManager release];
    m_threadManager = [[NSThread alloc] initWithTarget:self selector:@selector(threadManager:) object:self];
    [m_threadManager start];
    return 0;
//
//    //-------
//    m_ModuleFinish=0;
//    m_ModuleTesting=0;
//    
//    NSString * dicKey[] = {@kEngineUUT0Enable,@kEngineUUT1Enable,@kEngineUUT2Enable,@kEngineUUT3Enable,@kEngineUUT4Enable,@kEngineUUT5Enable,@kEngineUUT6Enable,@kEngineUUT7Enable};
//    
//    for (int i=0;i<=UUT_MODULE-1;i++)
//    {
//        m_ScriptEngine[i]->Reslease();
//        m_ScriptEngine[i]->Init();
//        id en = [CTestContext::m_dicConfiguration valueForKey:dicKey[i]];
//        if (en)
//        {
//            if (![en intValue])         //Skip Test
//                continue;
//        }
//        
//        m_ModuleTesting++;
//        
//        NSNumber * numEngine = [NSNumber numberWithLong:(long)m_ScriptEngine[i]];
//        NSNumber * numID = [NSNumber numberWithLong:i];
//        
//        NSDictionary * dicPar = [NSDictionary dictionaryWithObjectsAndKeys:numEngine,@"engine",numID,@"id", nil];
//        [threadUintTest[i] release];
//        threadUintTest[i]= [[NSThread alloc]initWithTarget:self selector:@selector(TestEntry:) object:dicPar];
//        
//        [self RegisterUUT_Variant:i];
//        
//        //post notification start test
//        NSDictionary * dicProcess = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:i],KEY_FIXTURE_ID,[NSNumber numberWithInt:TEST_PROCESS_START],KEY_TEST_PROCESS,nil];
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationOnEngineStart object:nil userInfo:dicProcess];
//        
//        [[threadUintTest[i] threadDictionary] removeAllObjects];
//        [threadUintTest[i] start];
//    }
//    return 0;
}

-(void)threadManager:(id)sender
{
    
    //initial
    for (int i=0; i<UUT_MODULE; i++) {
//        [m_pTestContext[i]->m_dicContext setValue:[NSNumber numberWithBool:NO] forKey:@"IsTestBreak?"];
//
        m_ScriptEngine[i]->Reslease();
        m_ScriptEngine[i]->Init();
        m_ScriptEngine[i]->DoString("__TestInitial()");
    }
//
//    //go test
    m_ModuleFinish=0;
    m_ModuleTesting=0;
//
//    //hack... clear DUT lock giveup signal
    [[NSFileManager defaultManager] removeItemAtPath:@"/tmp/TestManagerStop.tmp" error:nil];
//
    NSString * dicKey[] = {@kEngineUUT0Enable,@kEngineUUT1Enable,@kEngineUUT2Enable,@kEngineUUT3Enable,@kEngineUUT4Enable,@kEngineUUT5Enable,@kEngineUUT6Enable,@kEngineUUT7Enable};
//
//    for (int i=0;i<=UUT_MODULE-1;i++)
//    {
//        id en = [CTestContext::m_dicConfiguration valueForKey:dicKey[i]];
//        if (en)
//        {
//            if (![en intValue])         //Skip Test
//                continue;
//        }
//        
//        m_ModuleTesting++;
//        
//        NSNumber * numEngine = [NSNumber numberWithLong:(long)m_ScriptEngine[i]];
//        NSNumber * numID = [NSNumber numberWithLong:i];
//        
//        NSDictionary * dicPar = [NSDictionary dictionaryWithObjectsAndKeys:numEngine,@"engine",numID,@"id", nil];
//        [threadUintTest[i] release];
//        threadUintTest[i]= [[NSThread alloc]initWithTarget:self selector:@selector(TestEntry:) object:dicPar];
//        
//        [self RegisterUUT_Variant:i];
//        
//        //post notification start test
//        NSDictionary * dicProcess = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:i],KEY_FIXTURE_ID,[NSNumber numberWithInt:TEST_PROCESS_START],KEY_TEST_PROCESS,nil];
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationOnEngineStart object:nil userInfo:dicProcess];
//        
//        [[threadUintTest[i] threadDictionary] removeAllObjects];
//        [threadUintTest[i] start];
//    }
//    
//    //wait all thread done
//    BOOL bAllDone=TRUE;
//    while (1) {
//        [NSThread sleepForTimeInterval:0.1];
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
//        
//        bAllDone = YES;
//        for (int i=0;i<=UUT_MODULE-1;i++)
//        {
//            if ([threadUintTest[i] isExecuting])
//            {
//                bAllDone = NO;
//                break;
//            }
//        }
//        
//        if (!bAllDone)
//        {
//            continue;
//        }
//        
//        //all uut has finish test...
//        //place clear code in here
//        //NSRunAlertPanel(@"All UUT Done", @"All uut has test done.", @"OK", nil, nil);
//        
//        BOOL bAbort = NO;
//        for (int i=0;i<=UUT_MODULE-1;i++)
//        {
//            id en = [CTestContext::m_dicConfiguration valueForKey:dicKey[i]];
//            if (en)
//            {
//                if (![en intValue])         //Skip Test
//                    continue;
//            }
//            if ([threadUintTest[i] isCancelled])
//            {
//                bAbort = YES;
//            }
//        }
//        
//        if (bAbort) //test sequence has been aborted.
//        {
//            //do nothing...
//            NSLog(@"Test sequence has been stop,all UUT test data will not save.");
//        }
//        else
//        {
//            for (int i=0;i<=UUT_MODULE-1;i++)
//            {
//                id en = [CTestContext::m_dicConfiguration valueForKey:dicKey[i]];
//                if (en)
//                {
//                    if (![en intValue])         //Skip Test
//                        continue;
//                }
//                
//                NSMutableDictionary * dic = m_pTestContext[i]->m_dicContext;
//                id isbreak = [dic valueForKey:@"IsTestBreak?"];
//                if ([isbreak boolValue])   //test has been break with exception
//                {
//                    //NSRunAlertPanel(@"OK", [NSString stringWithFormat:@"UUT%d test abort!",i], @"OK", nil, nil);
//                    NSLog(@"UUT%d test has been aborted! will don't save any data.",i);
//                }
//                else
//                {
//                    //NSRunAlertPanel(@"OK", [NSString stringWithFormat:@"UUT%d test done!",i], @"OK", nil, nil);
//                    int err = m_ScriptEngine[i]->DoString("__TestFinish()");  //call back
//                    if (err!=0)
//                    {
//                        NSString * strError = [NSString stringWithUTF8String:lua_tostring(m_ScriptEngine[i]->m_pLuaState, -1)];
//                        NSString * strLog = [NSString stringWithFormat:@"Error : %@ Reason:%@",@"Script Error",strError];
//                        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationOnTestError object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:strLog,@"msg",[NSNumber numberWithInt:i],@"id", nil]];
//                    }
//                    NSLog(@"UUT%d test finished! test data will save normally.",i);
//                }
//            }
//        }
//        break;//while(1)
//    }
//    
//    //All done;
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOnEngineFinish object:nil userInfo:nil];
}

-(int)IsTesting:(int)index      //may be call in multi thread
{
    //    return [self IsTesting1:index];
    [engineLock lock];
    BOOL bRunning = NO;
    switch (index) {
        case -1:
#if 0
            for (int i=0; i<UUT_MODULE; i++) {
                if ([threadUintTest[i] isExecuting])
                {
                    bRunning = YES;
                    break;
                }
            }
#else
            bRunning = [m_threadManager isExecuting];
#endif
            break;
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            bRunning = [threadUintTest[index] isExecuting];
            break;
        default:
            break;
    }
    [engineLock unlock];
    return bRunning;
}

-(int)IsTesting1:(int)index      //no use now
{
    [engineLock lock];
    BOOL bRunning = NO;
    switch (index) {
        case -1:
            for (int i=0; i<UUT_MODULE; i++) {
                NSMutableDictionary * dic =[threadUintTest[i] threadDictionary];
                int value = [[dic valueForKey:@kEngineTestStatus] intValue];
                if (value<0)    //this thread no need to be waited.
                {
                    continue;
                }
                if ([threadUintTest[i] isExecuting])
                {
                    bRunning = YES;
                    break;
                }
            }
            break;
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        {
            NSMutableDictionary * dic =[threadUintTest[index] threadDictionary];
            int value = [[dic valueForKey:@kEngineTestStatus] intValue];
            if (value<0)    //this thread no need to be waited.
            {
                bRunning = NO;
                //bRunning = [threadUintTest[index] isExecuting];
            }
            else
            {
                bRunning = [threadUintTest[index] isExecuting];
            }
        }
            break;
        default:
            break;
    }
    [engineLock unlock];
    return bRunning;
}


-(int)PauseTest
{
    return 0;
}

-(int)ResumeTest
{
    return 0;
}

-(int)StopTest
{
    for (int i=0; i<UUT_MODULE; i++) {
        if ([threadUintTest[i] isExecuting])
        {
            [threadUintTest[i] cancel];
        }
    }
    
    //hack... signal DUT lock to stop acquisition attempt.
    [[NSFileManager defaultManager] createFileAtPath:@"/tmp/TestManagerStop.tmp" contents:nil attributes:nil];
    
    return 0;
}

-(int)RegisterModule:(id)module
{
    for (int i=0; i<=UUT_MODULE-1; i++) {
        [dicModuleConfig setValue:[NSNumber numberWithLong:(long)m_ScriptEngine[i]->m_pLuaState] forKey:@"lua"];
        [dicModuleConfig setValue:[NSNumber numberWithInt:i] forKey:@"id"];
        [dicModuleConfig setValue:self forKey:@"TestEngine"];
        [module RegisterModule:dicModuleConfig];
    }
    return 0;
}
-(int)RegisterScript:(NSString *)pathscript
{
    int err=0;
    for (int i=0; i<UUT_MODULE; i++) {
        err = m_ScriptEngine[i]->DoFile([pathscript UTF8String]);
        if (err!=0) {
            NSString * strError = [NSString stringWithUTF8String:lua_tostring(m_ScriptEngine[i]->m_pLuaState, -1)];
            @throw [NSException exceptionWithName:@"Lua Error" reason:strError userInfo:nil];
            return -1;
        }
    }
    return 0;
}

-(int)WorkingMdoules
{
//    int count=0;
//    NSString * str[] = {@kEngineUUT0Enable,@kEngineUUT1Enable,@kEngineUUT2Enable,@kEngineUUT3Enable,@kEngineUUT4Enable,@kEngineUUT5Enable,@kEngineUUT6Enable,@kEngineUUT7Enable,@kEngineUUT8Enable};
//    for (int i=0; i<8; i++) {
//        id v=[CTestContext::m_dicConfiguration valueForKey:str[i]];
//        if (v)
//        {
//            if ([v boolValue])
//            {
//                count++;
//            }
//        }
//    }
//    return count;
    return UUT_MODULE;
}

-(int)Cores
{
    return UUT_MODULE;
}


-(void *)GetScripEngine:(int)index
{
    if ((index<0)||(index>=UUT_MODULE)) return NULL;
    return m_ScriptEngine[index];
//    return nil;
}

-(void *)GetTestContext:(int)index
{
//    if ((index<0)||(index>=UUT_MODULE)) return NULL;
//    return m_pTestContext[index];
    return nil;
}

-(int)RegisterString:(const char *)string
{
    int err=0;
    for (int i=0; i<UUT_MODULE; i++) {
        err = m_ScriptEngine[i]->DoString(string);
        if (err!=0) {
            NSString * strError = [NSString stringWithUTF8String:lua_tostring(m_ScriptEngine[i]->m_pLuaState, -1)];
            @throw [NSException exceptionWithName:@"Lua Error" reason:strError userInfo:nil];
            return -1;
        }
    }
    return 0;
}

-(void)TestEntry:(id)sender
{
//    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc]init]; //自动释放池
//    NSDictionary * dicPar = (NSDictionary *)sender;
//    CScriptEngine * pEngine = (CScriptEngine *)[[dicPar valueForKey:@"engine"]longValue];
//    long idUUT = [[dicPar valueForKey:@"id"] longValue];
//    
//    @try {
//        int err = pEngine->DoString("main()");  //Goto Main Function
//        if (err!=0)
//        {
//            NSString * strError = [NSString stringWithUTF8String:lua_tostring(pEngine->m_pLuaState, -1)];
//            @throw [NSException exceptionWithName:@"Lua Error" reason:strError userInfo:nil];
//        }
//    }
//    @catch (NSException *exception) {
//        int err;
//        [m_pTestContext[idUUT]->m_dicContext setValue:[NSNumber numberWithBool:YES] forKey:@"IsTestBreak?"];
//        if ([[exception name] isEqualToString:kNotificationDoTestStop]) //test sequence has been cancelled
//        {
//            //err = pEngine->DoString("Test_OnFail()");
//            err = pEngine->DoString("if (Test_OnAbort) then Test_OnAbort(); end");
//            err = pEngine->DoString("UUT_ABORT(ID)");
//            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationOnTestStop object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:idUUT],@"id",nil]];
//        }
//        else {
//            //err = pEngine->DoString("Test_OnFail()");
//            err = pEngine->DoString("if (Test_OnAbort) then Test_OnAbort(); end");
//            NSString * strLog = [NSString stringWithFormat:@"Error : %@ Reason:%@",[exception name],[exception reason]];
//            NSLog(@"%@",strLog);
//            //        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationLog object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:strLog,@"msg",[NSNumber numberWithInt:idUUT],@"id", nil]];
//            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationOnTestError object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:strLog,@"msg",[NSNumber numberWithLong:idUUT],@"id", nil]];
//            err = pEngine->DoString("UUT_ABORT(ID)");
//        }
//    }
//    
//    OSAtomicIncrement32(&m_ModuleFinish);   //this module has finish
//    if (m_ModuleFinish>=m_ModuleTesting)    //All Module Has finished
//    {
//        //move to threadManager
//        //[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOnEngineFinish object:nil userInfo:nil];
//    }
//    
//    //
//    
//    int err = pEngine->DoString("dut.UnlockAllMyInstrument()");
//    err = pEngine->DoString("UnlockAllInstrument()");
//    err = pEngine->DoString("unlock()");
//    
//    //need?
//    //    err = pEngine->DoString("UUT_ABORT(ID)");
//    
//    [pool release];
    
}
@end

