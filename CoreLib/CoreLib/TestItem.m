//
//  TestItem.m
//  CoreLib
//
//  Created by Hogan on 17/8/9.
//  Copyright © 2017年 com.Young. All rights reserved.
//

//
//  TestItem.m
//  iTMP
//
//  Created by Ryan on 12-5-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "TestItem.h"

@implementation TestItem
@synthesize index,description,group,lower,upper,uut1_value,uut2_value,uut3_value,uut4_value,unit,remark,time;
@synthesize state1,state2,state3,state4,state5,state6,state7,state8,image;
@synthesize uut5_value,uut6_value,uut7_value,uut8_value ;
@synthesize waiver;
@synthesize testkey;

- (id)init
{
    self = [super init];
    if (self) {
        self.state1 = 1;
        self.state2 = 1;
        self.state3 = 1;
        self.state4 = 1;
        self.state5 = 1;
        self.state6 = 1;
        self.state7 = 1;
        self.state8 = 1;
        self.time = @"";
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


- (id)initWithName:(NSString *)aName
{
    return [self initWithName:aName withSeparator:@"\t"];
}

-(id)initWithName:(NSString *)name withSeparator:(NSString *)sep
{
    self = [self init];
    
    if (!self) return nil;
    
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray * arr = [name componentsSeparatedByString:sep];
    
    if ([arr count] <2) {
        [self dealloc];
        return nil;
    }
    
    self.index = [arr objectAtIndex:0];
    self.description = [arr objectAtIndex:1];
    if ([arr count]>2) {
        self.lower = [arr objectAtIndex:2];     //lower limited
    }
    if ([arr count]>3)
    {
        self.upper = [arr objectAtIndex:3];     //upper limited
    }
    if([arr count]>4)
    {
        self.unit = [arr objectAtIndex:4];      //unit
    }
    if ([arr count]>5)
    {
        self.remark = [arr objectAtIndex:5];    //remark
    }
    self.state1 = 1;
    self.state2 = 1;
    self.state3 = 1;
    self.state4 = 1;
    self.state5 = 1;
    self.state6 = 1;
    self.state7 = 1;
    self.state8 = 1;
    self.time = @"";
    
    self.testkey = @"";
    self.waiver = NO;
    
    return self;
}


+ (TestItem *)nodeDataWithName:(NSString *)name {
    return [[[TestItem alloc] initWithName:name] autorelease];
}

@end


