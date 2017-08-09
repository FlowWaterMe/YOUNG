//
//  TestItem.h
//  CoreLib
//
//  Created by Hogan on 17/8/9.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
@interface KeyItem : NSObject {
@private
    NSString * name;
}
- (id)initWithName:(NSString *)name;
+ (KeyItem *)nodeDataWithName:(NSString *)name;

@property(readwrite, copy) NSString *name;
@end

