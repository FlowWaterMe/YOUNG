#!/bin/sh

#  UI.sh
#  UI
#
#  Created by Ryan on 12-11-7.
#  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.


INPUT=
OUTPUT=

#tolua=tolua++
tolua=/usr/local/bin/tolua++

#global variant for all unit with the same value
tolua++ -o UI_Global-lua.mm UI_Global.pkg

#UI
$tolua -o UserInterface-lua.mm UserInterface.pkg


#Global variant for each unit
