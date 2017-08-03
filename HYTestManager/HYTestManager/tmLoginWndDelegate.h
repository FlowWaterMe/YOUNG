//
//  tmLoginWndDelegate.h
//  HYTestManager
//
//  Created by Hogan on 17/8/3.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "UserInformation.h"
#define  SECRITY_FILE       @"login.pwd"
@interface tmLoginWndDelegate : NSObject<NSApplicationDelegate>
{
    NSMutableArray * m_arrRegisterUser;
    IBOutlet NSTextField * textUserName;
    IBOutlet NSTextField * textPassword;
    IBOutlet NSWindow * panelLogin;
    IBOutlet NSWindow * winMain;
    IBOutlet NSWindow * winLogin;
    USER_INFOR * m_pCurrUser;
}
-(IBAction)btOK:(id)sender;
-(IBAction)btCancel:(id)sender;


@end
