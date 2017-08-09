//
//  TestItem.h
//  CoreLib
//
//  Created by Hogan on 17/8/9.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestItem : NSObject
{
@private
    NSString * index;
    NSString * description;
    NSString * group;
    NSString * lower;
    NSString * upper;
    NSString * uut1_value;
    NSString * uut2_value;
    NSString * uut3_value;
    NSString * uut4_value;
    NSString * uut5_value;
    NSString * uut6_value;
    NSString * uut7_value;
    NSString * uut8_value;
    
    NSString * unit;
    NSString * remark;
    NSString * time;
    int state1;
    int state2;
    int state3;
    int state4;
    int state5;
    int state6;
    int state7;
    int state8;
    
    NSImage *image;
    NSString * testkey;
    BOOL waiver;
    
}

- (id)initWithName:(NSString *)name;
-(id)initWithName:(NSString *)name withSeparator:(NSString *)sep;


@property(readwrite, copy) NSString *index;
@property(readwrite, copy) NSString *description;
@property(readwrite, copy) NSString *group;
@property(readwrite, copy) NSString *lower;
@property(readwrite, copy) NSString *upper;
@property(readwrite, copy) NSString *uut1_value;
@property(readwrite, copy) NSString *uut2_value;
@property(readwrite, copy) NSString *uut3_value;
@property(readwrite, copy) NSString *uut4_value;

@property(readwrite, copy) NSString *uut5_value;
@property(readwrite, copy) NSString *uut6_value;
@property(readwrite, copy) NSString *uut7_value;
@property(readwrite, copy) NSString *uut8_value;

@property(readwrite, copy) NSString *unit;
@property(readwrite, copy) NSString *remark;
@property(readwrite, copy) NSString *time;
@property(readwrite,assign)int state1,state2,state3,state4,state5,state6,state7,state8;
@property(readwrite,retain)NSImage * image;

@property(readwrite, copy)  NSString *testkey;
@property(readwrite)        BOOL waiver;


//@property(readwrite, retain) NSString * description;
@end


