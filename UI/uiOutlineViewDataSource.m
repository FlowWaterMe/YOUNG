//
//  uiOutlineViewDataSource.m
//  UI
//
//  Created by Hogan on 17/8/9.
//  Copyright © 2017年 com.Young. All rights reserved.
//

//
//  uiOutlineViewDataSource.m
//  UI
//


#import "uiOutlineViewDataSource.h"

#include "CoreLib/TestItem.h"
#include "CoreLib/KeyItem.h"
#include "CoreLib/TestEngine.h"
#include "ImageAndTextCell.h"

#define ITEM_IDENTIFIER   @"index,testkey,description,time,lower,upper,uut1,uut2,uut3,uut4,uut5,uut6,unit,remark"
//#define ITEM_IDENTIFIER   @"index,description,time,lower,upper,uut1_value,uut2_value,uut3_value,uut4_value,unit,remark"

#define crPASS  [NSColor greenColor]
#define crFAIL  [NSColor redColor]
#define crRUN   [NSColor blueColor]
#define crNA    [NSColor grayColor]
#define crERROR [NSColor yellowColor]
//#define crIDLE  [NSColor cyanColor]
#define crIDLE  [NSColor selectedTextBackgroundColor]
#define crSKIP  [NSColor selectedTextBackgroundColor]
#define crCOF   [NSColor orangeColor]
#define crFAILButWaived [NSColor blackColor]

@implementation uiOutlineViewDataSource
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(OnLoadProfile:) name:@kNotificationReloadProfile object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [items release];
    [super dealloc];
}

-(void)OnLoadProfile:(NSNotification *)nf
{
    [items release];
    items = [[[nf userInfo] objectForKey:@"items"] retain];
    [outlineView reloadData];
    NSArray * arr = [items childNodes]; //所有的测试项
    for (id item in arr)
    {
        [outlineView expandItem:item];
    }
    [outlineView reloadData];
}

-(void)awakeFromNib
{
    int index=0;
    NSArray * keys = [ITEM_IDENTIFIER componentsSeparatedByString:@","];
    int width = [outlineView frame].size.width;
    int percentage[] = {6,8,25,5,0,0,10,10,10,10,10,10,0,0};
    for (NSTableColumn * col in [outlineView tableColumns ])
    {
        if (percentage[index]==0)
        {
            [col setHidden:YES];
        }
        else {
            [col setWidth:width*percentage[index]/100.0];
        }
        [col setIdentifier:[keys objectAtIndex:index++]];
    }
}

#pragma mark OutlineView DataSource
- (id)outlineView:(NSOutlineView *)ov child:(NSInteger)index ofItem:(id)item
{
    NSArray * childrens;
    if (item == nil) {
        childrens = [items childNodes];
    } else {
        childrens = [item childNodes];
    }
    
    if ([btnShowFailOnly state] == NSOnState)
    {
        NSInteger failedIndex = 0;
        if (item == nil)
        {
            for (id child in childrens)
            {
                if ([self outlineView:ov numberOfChildrenOfItem:child])
                {
                    if (failedIndex == index)
                    {
                        return child;
                    }
                    else
                    {
                        failedIndex++;
                    }
                }
            }
            
        }
        else
        {
            for (id child in childrens)
            {
                TestItem * testItem = [child representedObject];
                BOOL failed =
                (testItem.state1 == 0) || (testItem.state1 == 4) ||
                (testItem.state2 == 0) || (testItem.state2 == 4) ||
                (testItem.state3 == 0) || (testItem.state3 == 4) ||
                (testItem.state4 == 0) || (testItem.state4 == 4) ||
                (testItem.state5 == 0) || (testItem.state5 == 4) ||
                (testItem.state6 == 0) || (testItem.state6 == 4) ||
                (testItem.state7 == 0) || (testItem.state7 == 4) ||
                (testItem.state8 == 0) || (testItem.state8 == 4);
                if (failed)
                {
                    if (failedIndex == index)
                    {
                        return child;
                    }
                    else
                    {
                        failedIndex++;
                    }
                }
            }
        }
    }
    
    
    return [childrens objectAtIndex:index];
}
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    //TestItem *nodeData = [item representedObject];
    //    [outlineView expandItem:item];
    //    if (nodeData.keyitem)
    //    [outlineView expandItem:item];
    return [[item representedObject] isKindOfClass:[KeyItem class]];
}
- (NSInteger)outlineView:(NSOutlineView *)ov numberOfChildrenOfItem:(id)item
{
    NSArray * childrens;
    if (item == nil) {
        childrens = [items childNodes];
    } else {
        childrens = [item childNodes];
    }
    
    if ([btnShowFailOnly state] == NSOnState)
    {
        NSInteger failCount = 0;
        if (item == nil)
        {
            NSInteger KeyItemFailed = 0;
            for (id child in childrens)
            {
                if ([self outlineView:ov numberOfChildrenOfItem:child]) KeyItemFailed++;
            }
            return KeyItemFailed;
        }
        else
        {
            // number of test item failed
            for (id child in childrens)
            {
                TestItem * testItem = [child representedObject];
                BOOL failed =
                (testItem.state1 == 0) || (testItem.state1 == 4) ||
                (testItem.state2 == 0) || (testItem.state2 == 4) ||
                (testItem.state3 == 0) || (testItem.state3 == 4) ||
                (testItem.state4 == 0) || (testItem.state4 == 4) ||
                (testItem.state5 == 0) || (testItem.state5 == 4) ||
                (testItem.state6 == 0) || (testItem.state6 == 4) ||
                (testItem.state7 == 0) || (testItem.state7 == 4) ||
                (testItem.state8 == 0) || (testItem.state8 == 4);
                
                if (failed) failCount++;
            }
            return failCount;
        }
    }
    
    return [childrens count];
}
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    id objectValue = nil;
    
    if ([[item representedObject] isKindOfClass:[KeyItem class]]) {
        KeyItem *nodeData = [item representedObject];
        
        // The return value from this method is used to configure the state of the items cell via setObjectValue:
        if ((tableColumn == nil) || [[tableColumn identifier] isEqualToString:@"index"]) {
            objectValue = nodeData.name;
        }
    }
    else
    {
        TestItem *nodeData = [item representedObject];
        
        /*
         if (tableColumn==nil)   //group item
         {
         return nodeData.description;
         }
         else
         {
         return [nodeData valueForKey:[tableColumn identifier]];
         }*/
        
        // The return value from this method is used to configure the state of the items cell via setObjectValue:
        if ((tableColumn == nil) || [[tableColumn identifier] isEqualToString:@"description"]) {
            objectValue = nodeData.description;
        } else if ([[tableColumn identifier] isEqualToString:@"index"]) {
            objectValue = nodeData.index;
        }
        else if ([[tableColumn identifier] isEqualToString:@"testkey"]) {
            objectValue = nodeData.testkey;
        }
        else if ([[tableColumn identifier] isEqualToString:@"lower"]) {
            objectValue = nodeData.lower;
        }
        else if ([[tableColumn identifier] isEqualToString:@"upper"]) {
            objectValue = nodeData.upper;
        }
        else if ([[tableColumn identifier] isEqualToString:@"unit"]) {
            objectValue = nodeData.unit;
        }
        else if ([[tableColumn identifier] isEqualToString:@"remark"]) {
            objectValue = nodeData.remark;
        }
        else if ([[tableColumn identifier] isEqualToString:@"uut1"]) {
            objectValue = nodeData.uut1_value;
        }
        else if ([[tableColumn identifier] isEqualToString:@"uut2"]) {
            objectValue = nodeData.uut2_value;
        }
        else if ([[tableColumn identifier] isEqualToString:@"uut3"]) {
            objectValue = nodeData.uut3_value;
        }
        else if ([[tableColumn identifier] isEqualToString:@"uut4"]) {
            objectValue = nodeData.uut4_value;
        }
        else if ([[tableColumn identifier] isEqualToString:@"uut5"]) {
            objectValue = nodeData.uut5_value;
        }
        else if ([[tableColumn identifier] isEqualToString:@"uut6"]) {
            objectValue = nodeData.uut6_value;
        }
        else if ([[tableColumn identifier] isEqualToString:@"uut7"]) {
            objectValue = nodeData.uut7_value;
        }
        else if ([[tableColumn identifier] isEqualToString:@"uut8"]) {
            objectValue = nodeData.uut8_value;
        }
        else if ([[tableColumn identifier] isEqualToString:@"time"]) {
            objectValue = nodeData.time;
        }
        
    }
    
    return objectValue;
}
- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
}
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item
{
    return YES;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldCollapseItem:(id)item
{
    return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    //    return NO;
    TestItem *nodeData = [item representedObject];
    return [nodeData isKindOfClass:[KeyItem class]];
}


// We can return a different cell for each row, if we want
- (NSCell *)outlineView:(NSOutlineView *)ov dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    // If we return a cell for the 'nil' tableColumn, it will be used as a "full width" cell and span all the columns
    // If we return a cell for the 'nil' tableColumn, it will be used as a "full width" cell and span all the columns
    if ((tableColumn == nil)&&([[item representedObject] isKindOfClass:[KeyItem class]])) {
        return [[outlineView tableColumnWithIdentifier:@"description"]dataCell];
    }
    return [[outlineView tableColumnWithIdentifier:[tableColumn identifier]] dataCell];
}

#pragma mark Delegate
- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    if ([[item representedObject] isKindOfClass:[KeyItem class]]) return;   //KeyItem
    TestItem * pItem = (TestItem *)[item representedObject];
    NSString * identifier = [tableColumn identifier];
    if ([identifier isEqualToString:@"uut1"])
    {
        //[cell setTextColor:pItem.state1?[NSColor blackColor]:[NSColor redColor]];
        NSColor * color;
        if (pItem.state1<0) color = [NSColor blackColor];
        else if (pItem.state1==0) color = [NSColor redColor];
        else if (pItem.state1==2) color = crSKIP;  //skip
        else if (pItem.state1==3) color = crCOF;    //COF
        else if (pItem.state1==4) color = crFAILButWaived;
        else color = [NSColor blueColor];
        
        [cell setTextColor:color];
    }
    else if ([identifier isEqualToString:@"uut2"])
    {
        // [cell setTextColor:pItem.state2?[NSColor blackColor]:[NSColor redColor]];
        NSColor * color;
        if (pItem.state2<0) color = [NSColor blackColor];
        else if (pItem.state2==0) color = [NSColor redColor];
        else if (pItem.state2==2) color = crSKIP;  //skip
        else if (pItem.state2==3) color = crCOF;    //COF
        else if (pItem.state2==4) color = crFAILButWaived;
        else color = [NSColor blueColor];
        
        [cell setTextColor:color];
    }
    else if ([identifier isEqualToString:@"uut3"])
    {
        //[cell setTextColor:pItem.state3?[NSColor blackColor]:[NSColor redColor]];
        NSColor * color;
        if (pItem.state3<0) color = [NSColor blackColor];
        else if (pItem.state3==0) color = [NSColor redColor];
        else if (pItem.state3==2) color = crSKIP;  //skip
        else if (pItem.state3==3) color = crCOF;    //COF
        else if (pItem.state3==4) color = crFAILButWaived;
        else color = [NSColor blueColor];
        
        [cell setTextColor:color];
    }
    else if ([identifier isEqualToString:@"uut4"])
    {
        //[cell setTextColor:pItem.state4?[NSColor blackColor]:[NSColor redColor]];
        NSColor * color;
        if (pItem.state4<0) color = [NSColor blackColor];
        else if (pItem.state4==0) color = [NSColor redColor];
        else if (pItem.state4==2) color = crSKIP;  //skip
        else if (pItem.state4==3) color = crCOF;    //COF
        else if (pItem.state4==4) color = crFAILButWaived;
        else color = [NSColor blueColor];
        
        [cell setTextColor:color];
    }
    else if ([identifier isEqualToString:@"uut5"])
    {
        //[cell setTextColor:pItem.state4?[NSColor blackColor]:[NSColor redColor]];
        NSColor * color;
        if (pItem.state5<0) color = [NSColor blackColor];
        else if (pItem.state5==0) color = [NSColor redColor];
        else if (pItem.state5==2) color = crSKIP;  //skip
        else if (pItem.state5==3) color = crCOF;    //COF
        else if (pItem.state5==4) color = crFAILButWaived;
        else color = [NSColor blueColor];
        
        [cell setTextColor:color];
    }
    else if ([identifier isEqualToString:@"uut6"])
    {
        //[cell setTextColor:pItem.state4?[NSColor blackColor]:[NSColor redColor]];
        NSColor * color;
        if (pItem.state6<0) color = [NSColor blackColor];
        else if (pItem.state6==0) color = [NSColor redColor];
        else if (pItem.state6==2) color = crSKIP;  //skip
        else if (pItem.state6==3) color = crCOF;    //COF
        else if (pItem.state6==4) color = crFAILButWaived;
        else color = [NSColor blueColor];
        
        [cell setTextColor:color];
    }
    else if ([identifier isEqualToString:@"uut7"])
    {
        //[cell setTextColor:pItem.state4?[NSColor blackColor]:[NSColor redColor]];
        NSColor * color;
        if (pItem.state5<0) color = [NSColor blackColor];
        else if (pItem.state7==0) color = [NSColor redColor];
        else if (pItem.state7==2) color = crSKIP;  //skip
        else if (pItem.state7==3) color = crCOF;    //COF
        else if (pItem.state7==4) color = crFAILButWaived;
        else color = [NSColor blueColor];
        
        [cell setTextColor:color];
    }
    else if ([identifier isEqualToString:@"uut8"])
    {
        //[cell setTextColor:pItem.state4?[NSColor blackColor]:[NSColor redColor]];
        NSColor * color;
        if (pItem.state8<0) color = [NSColor blackColor];
        else if (pItem.state8==0) color = [NSColor redColor];
        else if (pItem.state8==2) color = crSKIP;  //skip
        else if (pItem.state8==3) color = crCOF;    //COF
        else if (pItem.state8==4) color = crFAILButWaived;
        else color = [NSColor blueColor];
        
        [cell setTextColor:color];
    }
    else if ([identifier isEqualToString:@"index"])
    {
        TestItem * pitem = (TestItem *)[item representedObject];
        /*        ImageAndTextCell * imageAndTextCell = (ImageAndTextCell *)cell;
         [imageAndTextCell setImage:pitem.image];*/
        if (pitem.image)
        {
            [cell setDrawsBackground:YES];
            [cell setBackgroundColor:[NSColor redColor]];
        }
        else
        {
            [cell setDrawsBackground:NO];
        }
    }
    
}

-(id)ItemAtIndex:(NSInteger)index
{
    NSArray * arrChilds = [items childNodes];
    for (int i=0; i<[arrChilds count]; i++) {
        NSArray * childs = [[arrChilds objectAtIndex:i] childNodes];
        if (childs) {
            if (index>([childs count]-1)) {
                index-=[childs count];
            }
            else
            {
                return [[childs objectAtIndex:index] representedObject];
            }
        }
    }
    return nil;
}

@end
