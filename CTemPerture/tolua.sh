#  Created by Louis on 13-8-14.
#  Copyright (c) 2013年 Louis. All rights reserved.

#tolua=/Users/ryan/Project/LUA/tolua++-1.0.93/bin/tolua++
tolua=/usr/local/bin/tolua++

#tolua=/usr/bin/code/lua/tolua++

$tolua -o CTem_lua.mm CTem.pkg

$tolua -o CTemGlobal_lua.mm CTemGlobal.pkg
