//
//  TestManager.m
//  HYTestManager
//
//  Created by Hogan on 17/8/3.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import "TestManager.h"

#define INFOR_FORMAT @"Endine : \r\n"
#define kBundleVersion            @"CFBundleShortVersionString"
#define kBundleNumberVersion      @"CFBundleVersion"

static __attribute__((used)) NSString *kIntelligentLibrary = @"/Library/IntelligentAutomation";
static __attribute__((used)) NSString *kIntelligentBundles = @"/Library/IntelligentAutomation/Bundles";//_attribute__((used)) has no effect when linking static library into shared object (android gcc 4.8)

@implementation TestManager
-(id)init
{
    self = [super init];
    if (self)
    {
        NSString * bundlepath = [[NSBundle bundleForClass:[self class]] bundlePath];
        m_CurrentPath = [bundlepath stringByDeletingLastPathComponent];//m_CurrentPath	NSPathStore2 *	"/Users/mac/Documents/程序/YOUNG/Build/Products/Debug"	0x00006000000e7c00
        m_strInformation = [[NSMutableString alloc] initWithString:@""];
        
        m_arrModules = [NSMutableArray new];
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    [m_strInformation release];
    [m_arrModules release];
}

-(NSString *)GetInformation
{
    return [NSString stringWithString:m_strInformation];
}


-(NSBundle *)findBundleNamed:(NSString *)bundleName
{
    NSString *bundlePath;
    
    //Current bundle path
    if ([bundleName isAbsolutePath]) {
        bundlePath = [NSString stringWithString:bundleName];
    } else {
        bundlePath = [m_CurrentPath stringByAppendingPathComponent:bundleName];
    }//m_CurrentPath	NSPathStore2 *	"/Users/mac/Documents/程序/YOUNG/Build/Products/Debug/Engine.bundle"
    
    NSBundle *bundle;
    
    bundle = [NSBundle bundleWithPath:bundlePath];
    if (!bundle)
    {
        bundlePath = [kIntelligentBundles stringByAppendingPathComponent:bundleName];
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    return bundle;
}


-(int)GetBundleInformation:(NSBundle *)bundle
{
    //Get Engine Information
    NSString *path = [bundle bundlePath];
    
    [m_strInformation appendString:@"\tpath:\t\t"];
    [m_strInformation appendFormat:@"%@", [path lastPathComponent]] ;
    
    [m_strInformation appendString:@"\r\n\tVersion:\t"];
    [m_strInformation appendFormat:@"%@", [bundle objectForInfoDictionaryKey:kBundleVersion]];
    
    [m_strInformation appendString:@"\r\n\tBuild:\t"];
    [m_strInformation appendFormat:@"%@", [bundle objectForInfoDictionaryKey:kBundleNumberVersion]];
    
    [m_strInformation appendString:@"\r\n"];
    
    return 0;
}


-(int)LoadEngine:(NSString *)engineName
{
    //Load Engine
    NSBundle * bundle;
    
    bundle = [self findBundleNamed:engineName];
    if (!bundle)
        
        if (![bundle load])
        {
//            NSRunAlertPanel(m_CurrentPath, @"Load Engine failed!", @"OK", nil, nil);
            return -1;
        }
    
    Class c = [bundle principalClass];
//    if (![c isSubclassOfClass:[TestEngine class]])
//    {
//        return -2;
//    }
    
    m_pTestEngine = [[c alloc] init];//c = GT_Engine
    
    [m_strInformation appendString:@"Engine:\r\n"];
    [self GetBundleInformation:bundle];
    [m_strInformation appendString:@"\r\n"];
    
    return 0;
}

-(int)LoadUI:(NSString *)UIName
{
    if (!m_pTestEngine) return -1;  //you should load engine first.
    
    NSBundle * bundle = [self findBundleNamed:UIName];
    
    if (![bundle load])
    {
        return -2;
    }
    
    id UI  = [[[bundle principalClass] alloc]init];
    if (![UI conformsToProtocol:@protocol(DriverModule)])
    {
        return -3;
    }
    
    [m_pTestEngine RegisterModule:UI];
    
    [UI Load:nil];
    
    [m_strInformation appendString:@"User Interface:\r\n"];
    [self GetBundleInformation:bundle];
    
    return 0;

}

-(int)LoadInStruments:(NSArray *)arrInstruments
{
    [m_strInformation appendString:@"Instruments:\r\n"];
    for (NSString * pathInstrument  in arrInstruments)
    {
        [self LoadInStrument:pathInstrument];
    }
    return 0;
}

-(int)LoadInStrument:(NSString *)pathModule
{
    return [self LoadInStrument:pathModule withSelfTest:YES];
//    return 0;
}

-(int)LoadInStrument:(NSString *)bundleName withSelfTest:(BOOL)bSelfTest
{
    static int count=0;
    
    NSBundle * bundle = [self findBundleNamed:bundleName];
    if (![bundle load])
    {
        return -1;
    }
    id module = [[[bundle principalClass] alloc] init];
    
    [m_arrModules addObject:module];
    [m_pTestEngine RegisterModule:module];
    
    if ([module respondsToSelector:@selector(Load:)])
    {
        [module Load:nil];
    }
    
    if (bSelfTest)
    {
        if ([module respondsToSelector:@selector(SelfTest:)])
        {
            [module SelfTest:nil];
        }
    }
    
    [m_strInformation appendFormat:@"Module%d\r\n",count++];
    [self GetBundleInformation:bundle];
    [m_strInformation appendString:@"\r\n"];
    return 0;

}

-(int)LoadString:(const char *)string
{
  return [m_pTestEngine RegisterString:string];
}

-(int)LoadScript:(NSString *)pathScript
{
    [m_pTestEngine RegisterScript:pathScript];
    return 0;
}
@end
