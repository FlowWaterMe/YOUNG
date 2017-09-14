//
//  tmLoginWndDelegate.m
//  HYTestManager
//
//  Created by Hogan on 17/8/3.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import "tmLoginWndDelegate.h"
#include "Common.h"
CUserInformation * m_pUserInformation=nil;
@implementation tmLoginWndDelegate
-(id)init{
    self = [super init];
    if(self)
    {
        m_pUserInformation = new CUserInformation();
    }
    return self;
}

-(void)dealloc
{
    if(m_pUserInformation){
        delete m_pUserInformation;
        m_pUserInformation = NULL;
    }
    [super dealloc];
}
-(void)awakeFromNib
{
    
    NSBundle * bundle = [NSBundle bundleForClass:[self class]];
    NSString * str = [[bundle resourcePath] stringByAppendingPathComponent:SECRITY_FILE];
    m_pUserInformation->LoadFromFile([str UTF8String]);
    
    m_pCurrUser = NULL;
//    [panelLogin makeKeyAndOrderFront:nil];
//    [panelLogin center];
}
-(IBAction)btOK:(id)sender
{
    USER_INFOR u;
    memset(&u, 0, sizeof(u));
    strcpy(u.szName, [[textUserName stringValue]UTF8String]);
    strcpy(u.szPassword, [[textPassword stringValue]UTF8String]);
    if (m_pUserInformation->CheckUser(u))
    {
        [NSApp stopModalWithCode:YES];
        [panelLogin orderOut:nil];
        [winMain makeKeyAndOrderFront:nil];
    }
    else {
//        NSRunAlertPanel(@"Login", @"Incorrectly user name or password,try again!", @"OK", nil, nil);
    }
    [textPassword setStringValue:@""];
    [textUserName becomeFirstResponder];
}
-(IBAction)btCancel:(id)sender
{
    [NSApp stopModalWithCode:NO];
    [panelLogin orderOut:nil];
    [winMain makeKeyAndOrderFront:nil];
    USER_INFOR * pUser = m_pUserInformation->GetCurrentUser();
    NSDictionary * dicUser=nil;
    if (pUser)
    {
        dicUser = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:pUser->szName],kLoginUserName,[NSString stringWithUTF8String:pUser->szPassword],kLoginUserPassword,[NSNumber numberWithInt:pUser->Authority],kLoginUserAuthority, nil];
    }
    else {
        dicUser = [NSDictionary dictionaryWithObjectsAndKeys:@"",kLoginUserName,@"",kLoginUserPassword,[NSNumber numberWithInt:-1],kLoginUserAuthority, nil];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDoChangeUser object:nil userInfo:dicUser];
    [textPassword setStringValue:@""];
    [textUserName becomeFirstResponder];

}
@end
