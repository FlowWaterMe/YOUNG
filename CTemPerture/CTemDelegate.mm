//
//  CTemDelegate.m
//  CTemPerture
//
//  Created by Hogan on 17/8/24.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import "CTemDelegate.h"
#import "CoreLib/Common.h"
@implementation CTemDelegate

-(id)init
{
    self = [super init];
    if(self)
    {
        temobj = new CTem();
        [[NSNotificationCenter defaultCenter] addObserver:self selector
                                                         :@selector(handleNotification:) name
                                                         :kNotificationAttachMenu object
                                                         :nil];
    }
    return self;
}

-(void)dealloc
{
    if(temobj)
    {
        delete temobj;
    }
//    temobj = NULL;
    [super dealloc];
}

-(void)awakeFromNib
{

}


-(IBAction)btcount:(id)sender
{
    int i = [m_text1 intValue];
    int j = [m_text2 intValue];
    [m_text3 setIntValue: temobj->count(i, j)];
}
-(IBAction)btshow:(id)sender
{
    [m_temwin center];
    [m_temwin makeKeyAndOrderFront:sender];
}
-(void)handleNotification:(NSNotification*)nf
{
    NSDictionary *userInfo=[nf userInfo];
    
    if ([nf.name isEqualToString:kNotificationAttachMenu])
    {
        NSMenu * instrMenu = [userInfo objectForKey:@"menus"];
        [instrMenu addItem:menuItem];
    }
    return ;
}
@end
