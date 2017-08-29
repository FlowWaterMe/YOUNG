//
//  CTemDelegate.h
//  CTemPerture
//
//  Created by Hogan on 17/8/24.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "CTem.h"
#import "CTemGlobal.h"
@interface CTemDelegate : NSObject
{
    @private
    IBOutlet NSTextField * m_text1;
    IBOutlet NSTextField * m_text2;
    IBOutlet NSTextField * m_text3;
    IBOutlet NSWindow * m_temwin;
    IBOutlet NSMenuItem * menuItem;
    
}
-(IBAction)btcount:(id)sender;
-(IBAction)btshow:(id)sender;

@end
