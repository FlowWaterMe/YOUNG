#!/bin/sh

#  DataLogger.sh
#  DataLogger
#
#  Created by Ryan on 12-9-21.
#  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.

INPUT=DataLogger.pkg
OUTPUT=DataLogger-lua.mm

tolua=tolua++
#tolua=/Users/ryan/Project/LUA/tolua++-1.0.93/bin/tolua++

#tolua++ -o $OUTPUT $INPUT


#DataLogger Class:
$tolua -o DataLogger-lua.mm DataLogger.pkg

#DataLogger1 :
$tolua -o DataLogger1.mm DataLogger1.pkg

#DataLogger2 :
$tolua -o DataLogger2.mm DataLogger2.pkg

#DataLogger3 :
$tolua -o DataLogger3.mm DataLogger3.pkg

#DataLogger4 :
$tolua -o DataLogger4.mm DataLogger4.pkg

#DataLogger5 :
$tolua -o DataLogger5.mm DataLogger5.pkg

#DataLogger6 :
$tolua -o DataLogger6.mm DataLogger6.pkg
