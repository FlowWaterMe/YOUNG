//
//  CsvReporter.m
//  DataLogger
//
//  Created by Ryan on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CsvReporter.h"
#include <CoreLib/common.h>
#include <CoreLib/TestContext.h>
#define CSVMAXREC 20
#define MAXSYNCHS  4

NSMutableArray * gCsvGlobalHeader = nil;

//static bool      m_wrote_header=false;
static int  m_num_records=-1;
static NSString    *m_strCsvFilePath;


static NSLock * write_lock=nil;
@implementation CsvReporter
-(id)init
{
    self = [super init];
    if (self)
    {
        if (!write_lock)
        {
            write_lock = [NSLock new];
        }
        m_strCsvFilePath = nil;
        m_strFileHeader =nil;
        
        m_arrCsvKey = [NSMutableArray new];
        m_arrCsvValue = [NSMutableArray new];
        m_arrCsvUpper = [NSMutableArray new];
        m_arrCsvLower = [NSMutableArray new];
        m_arrCsvUnit = [NSMutableArray new];
        
        m_dictCsvData = [NSMutableDictionary new];
    }
    return self;
}

-(void)dealloc
{
    [m_arrCsvKey removeAllObjects];
    [m_arrCsvKey release];
    
    [m_arrCsvValue removeAllObjects];
    [m_arrCsvValue release];
    
    [m_arrCsvUpper removeAllObjects];
    [m_arrCsvUpper release];
    
    [m_arrCsvLower removeAllObjects];
    [m_arrCsvLower release];
    
    [m_arrCsvUnit removeAllObjects];
    [m_arrCsvUnit release];
    
    [m_dictCsvData removeAllObjects];
    [m_dictCsvData release];
    
    [write_lock release];
    [super dealloc];
}
-(id)initWithStationInfo:(id)station_info andTestDefinition:(id)test_definition
{
    [self init];
    return self;
}

// convert key, value, upper, lower, unit array into a dictionary for easy access.
- (void) setupData
{
    if ([m_dictCsvData count])
    {
        [m_dictCsvData removeAllObjects];
    }
    
    for (NSUInteger idx = 0; idx < [m_arrCsvKey count]; idx++)
    {
        // unlikely, but potential out-of-range exception
        @try {
            NSDictionary * d = [NSDictionary dictionaryWithObjectsAndKeys:
                                [m_arrCsvLower objectAtIndex:idx], @"lower",
                                [m_arrCsvUpper objectAtIndex:idx], @"upper",
                                [m_arrCsvValue objectAtIndex:idx], @"value",
                                [m_arrCsvUnit objectAtIndex:idx], @"unit",
                                nil];

            [m_dictCsvData setObject:d forKey:[m_arrCsvKey objectAtIndex:idx]];
        }
        @catch (NSException *exception) {
            NSLog(@"DataLogger [CsvReporter setupData] exception:  %@", [exception description]);
            NSLog(@"DataLogger [CsvReporter setupData] m_arrCsvKey=%@", [m_arrCsvKey description]);
            NSLog(@"DataLogger [CsvReporter setupData] m_arrCsvLower=%@", [m_arrCsvLower description]);
            NSLog(@"DataLogger [CsvReporter setupData] m_arrCsvUpper=%@", [m_arrCsvUpper description]);
            NSLog(@"DataLogger [CsvReporter setupData] m_arrCsvValue=%@", [m_arrCsvValue description]);
            NSLog(@"DataLogger [CsvReporter setupData] m_arrCsvUnit=%@", [m_arrCsvUnit description]);
        }

    }
}

- (void) updateCsvExistingColumns
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    // Add new keys to columns, at the end.
    for (NSString * currentKey in m_arrCsvKey)
    {
        if (![gCsvGlobalHeader containsObject:currentKey])
        {
            [gCsvGlobalHeader addObject:currentKey];
        }
    }
    
    // Pad CSV file
    NSMutableArray * newContentArray = [[[NSMutableArray alloc] init] autorelease];
    NSString * currentCsvContent= [NSString stringWithContentsOfFile:m_strCsvFilePath encoding:NSUTF8StringEncoding error:nil];
    if (currentCsvContent)
    {
        NSArray * contentArray = [currentCsvContent componentsSeparatedByString:@"\r\n"];
        
        int lineIndex = 0;
        for (NSString * line in contentArray)
        {
            if ([line length])
            {
                NSMutableArray * lineToken = [[[line componentsSeparatedByString:@","] mutableCopy] autorelease];
                for (NSUInteger i = [lineToken count]; i < [gCsvGlobalHeader count]; i++)
                {
                    NSString * key = [gCsvGlobalHeader objectAtIndex:i];
                    NSDictionary * data = [m_dictCsvData objectForKey:key];
                    
                    // Pad columns
                    if (lineIndex == 0)
                    {
                        // nop
                    }
                    if (lineIndex == 1)
                    {
                        if (key) {
                            [lineToken addObject:key];
                        }
                        else
                        {
                            [lineToken addObject:@""];
                        }
                    }
                    else if (lineIndex == 2)
                    {
                        if ([data objectForKey:@"upper"]) {
                            [lineToken addObject:[data objectForKey:@"upper"]];
                        }
                        else
                        {
                            [lineToken addObject:@""];
                        }
                        
                    }
                    else if (lineIndex == 3)
                    {
                        if ([data objectForKey:@"lower"]) {
                            [lineToken addObject:[data objectForKey:@"lower"]];
                        }
                        else
                        {
                            [lineToken addObject:@""];
                        }
                    }
                    else if (lineIndex == 4)
                    {
                        if ([data objectForKey:@"unit"]) {
                            [lineToken addObject:[data objectForKey:@"unit"]];
                        }
                        else
                        {
                            [lineToken addObject:@""];
                        }
                    }
                    else
                    {
                        [lineToken addObject:@""];
                    }
                }
                if ([lineToken componentsJoinedByString:@","]) {
                    [newContentArray addObject:[lineToken componentsJoinedByString:@","]];
                }
                else
                {
                    break;
                }
            }
            lineIndex++;
        }
        
        NSString * newCsvContent = [[newContentArray componentsJoinedByString:@"\r\n"] stringByAppendingString:@"\r\n"];
        [newCsvContent writeToFile:m_strCsvFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    [pool release];
}


#define LOG_DIR @"/vault/Intelli_Log"
-(void)generateReport:(NSString*)filepath
{
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    [write_lock lock];
    
    [self setupData];
    
    // This is a critical section.  Protected by 'write_lock' conveniently
    if (!gCsvGlobalHeader)
    {
        gCsvGlobalHeader = [[NSMutableArray alloc] init];
        [gCsvGlobalHeader addObjectsFromArray:m_arrCsvKey];
    }
    
    
    if (!filepath)
    {
        [self generate_csv_path];
    }
    else
    {
        [m_strCsvFilePath release];
        m_strCsvFilePath = [filepath copy];
    }

    // check if our header matches global header
    NSString * globalHeaderString = [gCsvGlobalHeader componentsJoinedByString:@","];
    NSString * currentHeaderString = [m_arrCsvKey componentsJoinedByString:@","];
    if (![currentHeaderString isEqualToString:globalHeaderString])
    {
        [self updateCsvExistingColumns];
    }
    

    [self WriteCSVTitle];
    
    NSFileHandle * file = [NSFileHandle fileHandleForWritingAtPath:m_strCsvFilePath];
    [file seekToEndOfFile];
    
    NSMutableArray * lineArray = [[[NSMutableArray alloc] init] autorelease];
    for (NSString * key in gCsvGlobalHeader)
    {
        NSString * value = nil;
        NSDictionary * item = [m_dictCsvData objectForKey:key];
        if (item)
        {
            value = [item objectForKey:@"value"];
        }
        if (value)
        {
            [lineArray addObject:value];
        }
        else
        {
            [lineArray addObject:@""];
        }
    }
    [file writeData:[[lineArray componentsJoinedByString:@","] dataUsingEncoding:NSUTF8StringEncoding]];
    [file writeData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [file closeFile];
    
	m_num_records++;
    
	[write_lock unlock];
	[pool drain];
}

-(void)flush
{
    [m_arrCsvValue removeAllObjects];
}

-(void) generate_csv_path
{
    if (m_strCsvFilePath) [m_strCsvFilePath release];
    
    NSFileManager * fm = [NSFileManager defaultManager];

    NSString * strDir = [CTestContext::m_dicConfiguration valueForKey:kConfigLogDir];

    NSString * strStationID = [CTestContext::m_dicGlobal valueForKey:kContextStationID];
    
    [fm createDirectoryAtPath:strDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMdd_HHmm"];
    
    NSString * csvBaseName = [NSString stringWithFormat:@"/%@_%@",
                              [dateFormatter stringFromDate:[NSDate date]],
                              strStationID];

    NSString * csvFileName = [csvBaseName stringByAppendingPathExtension:@"csv"];
    
    
    m_strCsvFilePath = [[strDir stringByAppendingString:csvFileName] copy];

    [dateFormatter release];
}

-(void)setCSVtitle:(NSString *)Title
{
    if (m_strFileHeader)
    {
        [m_strFileHeader release];
    }
    if (!Title) return;
    m_strFileHeader = [Title copy];
}

-(void)push_keys:(NSString*)items
{
    [m_arrCsvKey setArray:[items componentsSeparatedByString:@","]];
}
-(void)push_values:(NSString*)items
{
    [m_arrCsvValue setArray:[items componentsSeparatedByString:@","]];
}
-(void)push_uppers:(NSString*)items
{
    [m_arrCsvUpper setArray:[items componentsSeparatedByString:@","]];
}
-(void)push_lowers:(NSString*)items
{
    [m_arrCsvLower setArray:[items componentsSeparatedByString:@","]];
}
-(void)push_units:(NSString*)items
{
    [m_arrCsvUnit setArray:[items componentsSeparatedByString:@","]];
}


-(int) WriteCSVTitle
{
    //write csv title
    if (m_strFileHeader)
    {
        NSFileManager * fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:m_strCsvFilePath])     //Need Creat New file.
        {
            [[NSFileManager defaultManager]createDirectoryAtPath:[m_strCsvFilePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
            [[NSFileManager defaultManager]createFileAtPath:m_strCsvFilePath contents:nil attributes:nil];
            [m_strFileHeader writeToFile:m_strCsvFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
    return 0;
}


-(void) writetxt:(NSString *)new_line toPath:(NSString *)path
{
	NSMutableString *csv_contents = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
	[csv_contents appendString:new_line];
    
	[csv_contents writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:NULL];
}
@end
