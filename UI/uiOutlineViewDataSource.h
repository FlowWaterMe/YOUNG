//
//  uiOutlineViewDataSource.h
//  UI
//
//  Created by Hogan on 17/8/9.
//  Copyright © 2017年 com.Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
extern NSTreeNode * items;
@interface uiOutlineViewDataSource : NSObject
{
    @private
    IBOutlet NSOutlineView * outlineView;
    IBOutlet NSButton * btnShowFailOnly;

}
@end
