--//
--//  Excute.lua
--//  iTMP
--//
--//  Created by Ryan on 12-2-3.
--//  Copyright 2012年 __MyCompanyName__. All rights reserved.
--//
--require "Modules"

--Step function list
--测试步骤函数list
--require "RLdb"

--[[
Version History:
V1.2:
1.修复一个项目如果被skipped,没有相应更新value.state，潜在可能会在某些情况下引起pudding会上传该logger的错误。
V1.1:
1.没有显示的项目，被强制为测试pass.(避免后台导致fail的问题)
2.当spec为string时，如果返回一个非string类型，将报错
V1.0:
Fisrt Version
]]
local version = 1.2

PDCA_ATTR="Attribute"
PDCA_VALUE="value"

DEBUG = 1;

PASS=1;
FAIL=0;
ERROR=-1;
WAIVED=4;

uutsku={};
function Log( par1,par2 )
if par1 == nil then
print(12345)
return 0
end
print(par1)
end
function skip(  )
-- body
Log("skip fuck u");
end
function DbgLog( par1,par2 )
-- body
Log(par1);
end
function CheckBreakPoints( par )
-- body
print("CheckBreakPoints *****************")
return -1
end
function pause( ... )
-- body
print("stop *****************")
end
function Now( ... )
-- body
return os.date()
end
function DbgOut(fmt,...)
if (DEBUG ~=0) then
local tf = {...};
if (tf[1]~=nil) then
DbgLog(string.format(tostring(fmt),...),ID);
else
DbgLog(tostring(fmt),ID);
end
end
end

function TestFlowOut(fmt,...)
if (DEBUG ~=0) then
Log(string.format(tostring(fmt),...),ID);
end
end

function __STOP_TEST()
stoptest=true;
end

local EN_DEBUG = 0;
function Entry(fun,...)		--Log Function
print("Entry")
if (EN_DEBUG == 0) then return; end
str = tostring(fun);
if(...) then
for i,v in ipairs{...}do
str=str.." "..tostring(v);
end
end
DbgOut(str);
end

function CheckResult(lower,upper,value)				--根据spec检验测试结果，PASS:在spec之内 FAIL:在spec范围之外
TestFlowOut("lower:%s upper:%s value:%s",tostring(lower),tostring(upper),tostring(value));
--	if (not value) then do return PASS end end;		--value 为nil
local res=PASS;		--all pass

if (lower) or (upper) then
if (type(lower)=="number") or (type(upper)=="number") then			--spec为数字类型
--assert(type(value)=="number","Returen value with incorrect format,expect number ,reutrn format is "..type(value));
--根据spec强制转换结果，避免产生错误
value=tonumber(value);
if (not value) then return FAIL end;
if (lower) then
if (value<lower) then
res = FAIL;
end
end
if (upper) then
if (value>upper) then
res = FAIL;
end
end
elseif (type(lower)=="string") or (type(upper)=="string")  then		--spec为字符串类型
--assert(type(value)=="string","Returen value with incorrect format,expect string ,reutrn format is "..type(value));
if (not value) then
return FAIL;
end	--返回为nil
if (string.upper(value)=="NIL") then
return FAIL;
end
if (type(value)=="number") then
if (value==0) then
return PASS;
else
return FAIL;
end
end
--assert(type(value)=="string","Error,The return value is "..tostring(value)..",with type : "..type(value).."but the spec is string.");

value=tostring(value);

if (#(tostring(lower))==0) and (#(tostring(upper))==0) then
return PASS;
end	--spec为空字符串，匹配任意字符

if (tostring(value)==lower) then
return PASS;
else
return FAIL;
end
--[[
-----------------------------------------------------------------------
author:ZL Meng
Date:Jul.17 2015
Description:
添加函数limit和表格limit
-----------------------------------------------------------------------
--]]
elseif (type(lower)=="function") and (type(upper)=="function")  then
local lower_value = lower();
local upper_value = upper();
return CheckResult(lower_value,upper_value,value);
elseif (type(lower)=="table") and (type(upper)=="table") and (type(value)=="table") then
if #lower==0 and #upper==0 and #value==0 then
return CheckResult(nil,nil,nil);
elseif #lower==#upper and #upper==#value then
res = PASS;
for i=1,#value do
if CheckResult(lower[i],upper[i],value[i]) == FAIL then
res = FAIL;
break;
end
end
else
msgbox("SFC error","Limit lenght unequal #lower＝"..tostring(#lower).." #upper="..tostring(#upper).." #value="..tostring(#value),"OK",nil,nil);
end
end
else							--没有设定spec,处理成P/F值
if (tonumber(value)==0) or (value == nil) then	--返回0或没有返回值，当作PASS处理
res = PASS;
else
res = FAIL;
end
end
return res;
end

local result=PASS;

this={};				--当前测试项目

--执行一个测试Item

function pivotInit()
local pivot_log_path = tc.LogDir().."/pivot_log_site_"..tc.ID()..".csv"
local test_file = io.open(pivot_log_path, 'r')
if test_file==nil then
test_file = io.open(pivot_log_path, 'w')
test_file:write("station number, line_number, site, SN, test_name, value, lower_limit, upper_limit\n")
tc["_PTFM_Pivot_file"] = test_file
else
local pivot_file = io.open(pivot_log_path, 'a')
tc["_PTFM_Pivot_file"] = pivot_file
end
end
function pivotFinalize()
local pivot_file =tc["_PTFM_Pivot_file"]
pivot_file:close()
end

function logPivotItem(item, context, value)
local pivot_file = context["_PTFM_Pivot_file"];
if (pivot_file) then
--"line_number, station_number, site, sn, test name, value, low_limit, high_limit
pivot_file:write(string.format("%s,%s,%s,%s,%s,%s, %s, %s\n", context.LineNumber(), context.StationNumber(), context.ID(), tostring(context.mlbSN()), tostring(item.name), tostring(value), tostring(item.lower), tostring(item.upper)))
end
end

local steps=-1;
local function Excute_Item(item)
print("Excute_Item")
Entry("Entry \""..item.name.."\" Item");		--Log message
this=item;
local value=0;
local state=0;

-- use SKU specific limit if defined.

if (uutsku and #uutsku) then
ConfigureLimitForItemBySKU(item);
ConfigureWaiverForItemBySKU(item);
end

if (type(item.entry)=="function") then		--Do test function
Entry("Call "..tostring(item.entry));
if (item.parameter==nil) then item.parameter = {} end;
value,display =item.entry(item.parameter);
--			value=0;	--just for debug

--判定测试结果
--			DbgOut("value1 : %s value2 : %s value3 : %s value4 : %s",tostring(value1),tostring(value2),tostring(value3),tostring(value4));

print("--> "..tostring(item.testkey).." using lower=".. tostring(item.lower) .. "  using upper="..tostring(item.upper));

state = CheckResult(item.lower,item.upper,value);
--[[
-----------------------------------------------------------------------
author:ZL Meng
Date:Jul.17 2015
Description:
添加函数limit和表格limit
-----------------------------------------------------------------------
--]]
if (type(value)=="table") then
local x = ""
for i,v in ipairs(value) do
if #x==0 then
x=tostring(v)
else
x=x..","..tostring(v)
end
end
value="{"..x.."}";
end
logPivotItem(item, tc, value)
if (item.lower == nil) and (item.upper==nil) then		--无值型测试项，一般用于执行一个动作
if (tonumber(value)==0) or (value == nil) then	--返回0或没有返回值，当作PASS处理
value="PASS"
state=1;
else
value="FAIL"
state=0;
end
end

if (state>0) then
TestFlowOut("\tPASS");
else
TestFlowOut("\tFAIL");
end

elseif(type(item.entry) == "string") then		--为字符串形式，直接执行该字符串
DbgOut("value.entry : %s",tostring(item.entry));
local func,err = loadstring(item.entry);
assert(func~=nil,tostring(err));			--exception
value = func();

--判定测试结果
--			DbgOut("value1 : %s value2 : %s value3 : %s value4 : %s",tostring(value1),tostring(value2),tostring(value3),tostring(value4));
state = CheckResult(item.lower,item.upper,value);
--[[
-----------------------------------------------------------------------
author:ZL Meng
Date:Jul.17 2015
Description:
添加函数limit和表格limit
-----------------------------------------------------------------------
--]]
if (type(value)=="table") then
local x = ""
for i,v in ipairs(value) do
if #x==0 then
x=tostring(v)
else
x=x..","..tostring(v)
end
end
value="{"..x.."}";
end
if (item.lower == nil) then		--无值型测试项
if (tonumber(value)==0) then
value="PASS"
state=1;
else
value="FAIL"
state=0;
end
end

if (state>0) then
TestFlowOut("\tPASS");
else
TestFlowOut("\tFAIL");
end
else	--其他任意格式，不执行处理
display="Skipped"
value="Skipped";
--			item_state=0x0F;
state=2;
end

Entry("Leave \""..item.name.."\" Item\r\n");
TestFlowOut("");
return value, state,display;

end

--Export Function do a step
function __DoStep(item)
--	return Excute_Item(item);

local ret,state,display

local isskip = false;
if (item.skip) then		--this item has been set need to care is skipped or not
local skip = item.skip;
isskip = skip;
if (type(skip)=="function") then
isskip = skip();
DbgOut("isskip : "..tostring(isskip));
elseif (type(skip)=="string") then
local func,err = loadstring(skip);
assert(func~=nil,tostring(err));			--exception
isskip = func();
else
if (isskip==0) then
isskip = false;
end
end
end

if (isskip) then		--this item should be skipped
DbgOut(item.name.." has been skipped for this item");
ret,state,display = "Skipped",2,"Skipped";
else
---[[
ret,state,display = Excute_Item(item);	--Execute test item entry function, and check the return value.
--]]
end

if (not ret) then
ret = tostring(ret);
end

return ret,state,display;
end

---[[
ItemFail={};	--fail items conllection
ItemFailWaived={};
SHOW_ALL_ITEM=0;
local count_index=0;
local stoptest = false;
test_result = PASS;

local skip_curr_block=nil;
function DoTest(ti)	--测试主循环入口TestEntry,执行test sequence
--	sfasfsdf();
--local test_result = PASS;
for index,value in ipairs(ti) do
--TestCancel();	--test has been cancel or not
--		UUT_SYNCH(ID);
--处理Debug消息

if (value.sub==nil) then		--Sub test item
TestFlowOut("==SubTest: %s", pdcaname(value));
steps=steps+1;
else
TestFlowOut("==Test: %s",pdcaname(value));		--Key item
-- end
-- if (DEBUG_CMD == DEBUG_DISABLE) then
-- --Do Nothing...
-- elseif (DEBUG_CMD==DEBUG_STEP) then		--Step
-- if (value.sub==nil) then
-- pause();	--不是key item
-- end
-- else
-- if (CheckBreakPoints(tostring(value.name))>0) then		--Capture break point
-- pause();
-- end
end


--		if (value.visible==nil) or (value.visible~=0) then
if ((SHOW_ALL_ITEM==1) or (value.visible ~=0)) then	--显示指定隐藏该项目的显示，则不显示该项目，缺省显示该项目
ui.ITEM_START();		--Update UI of current item
end

local ret,state,display
--[[
if (tostring(tc.ID())) then
count_index=count_index+1;
if (count_index==10) then
ret,state,display = 123,0,"lkfsksadfjlk";	--just only debug
else
ret,state,display = 123,1,"lkfsksadfjlk";	--just only debug
end
--Delay(1000);
else
ret,state,display = Excute_Item(value);	--Execute test item entry function, and check the return value.
end
--]]
-- mark start
value.starttime = Now();

--this item should be skipped or not.
local isskip = false;
if (value.skip) then		--this item has been set need to care is skipped or not
local skip = value.skip;
isskip = skip;
if (type(skip)=="function") then
isskip = skip();
DbgOut("isskip : "..tostring(isskip));
elseif (type(skip)=="string") then
local func,err = loadstring(skip);
assert(func~=nil,tostring(err));			--exception
isskip = func();
else
if (isskip==0) then
isskip = false;
end
end
end
print(111111111111)
-- if (isskip or skip_curr_block) then		--this item should be skipped
-- DbgOut(value.name.." has been skipped for this item");
-- ret,state,display = nil,2,"Skipped";
-- value.value="Skipped";
-- value.state=state;		--2013-08-05,should update
-- else
---[[
ret,state,display = Excute_Item(value);	--Execute test item entry function, and check the return value.
if ((value.visible==0) or (value.visible==false)) then
state=1;	--强制设定为pass
end
--]]
if (not ret) then
ret = tostring(ret);
end
value.value=ret;
value.state=state;
-- end

--record test result and storage
if (state<=0) then
--Check CoF
print("COF : ",value.cof);
if ((value.cof) and (value.cof~=0)) then
state=3;	--CoF
else
test_result = FAIL;
ItemFail[#ItemFail+1]=pdcaname(value);

if (value.waiver == true) then
ItemFailWaived[#ItemFailWaived+1] = pdcaname(value);
end

end
end

--		UUT_SYNCH(ID);	--waiting other UUT
--		if (value.visible==nil) or (value.visible~=0) then
if ((SHOW_ALL_ITEM==1) or (value.visible ~=0)) then	--显示指定隐藏该项目的显示，则不显示该项目，缺省显示该项目
if ((state == FAIL) and (value.waiver)) then
ui.ITEM_FINISH(ret,WAIVED,display);
else
ui.ITEM_FINISH(ret,state,display);		--Update UI
end
if (state==0) then	--record fail message
if (display) then
value.error_msg = tostring(display);
end
else
value.failmsg = "";
end
if (value.sub==nil) then
--dl.AddRecord(ret);	--save to csv file log
--处理PDCA项目
if (not value.PDCA) or (not value.PDCA.ATTR) then	--没有指定PDCA,或没有指定为attribute,则当作测试项目来处理
end
end
end

-- Check waiver
if (test_result == FAIL) then
if (value.waiver) then
print("--> test "..value.testkey.." waived");
test_result = PASS;
end
end


--if need stop when test fail
if ((value.stopfail) and (value.stopfail~=0)) then	--stop if fail
if (value.waiver ~= true) then
if (value.stopfail==2) then	--skip current block
skip_curr_block = true;
else
if (state<=0) then
stoptest = true;
break;	--break current loop
end
end
end
end

--check fail count
local fc = tonumber(tc.FailCount());
ItemFailedWithoutWaiver = #ItemFail - #ItemFailWaived;
if (fc==0) then
if (ItemFailedWithoutWaiver>fc) then
stoptest = true;
print("stoptest due to A ItemFailedWithoutWaiver "..tostring(ItemFailedWithoutWaiver).." > fc "..fc);
break;
end
elseif (fc>0) then
if (ItemFailedWithoutWaiver>=fc) then
stoptest = true;
print("stoptest due to B ItemFailedWithoutWaiver "..tostring(ItemFailedWithoutWaiver).." > fc "..fc);
break;
end
end

--执行子项目
if (value.sub) then
skip_curr_block = false;
local ret = DoTest(value.sub);
if (ret<=0) then
test_result=FAIL;
end
end

--stop current test?
if (stoptest) then
--UUT_SYNCH(ID,"-1");
break;
end

value.endtime = Now();
value.elapsed = value.endtime - value.starttime;

TestFlowOut("\t%s elapsed=%.3f", value.name, value.elapsed);

end

return test_result;
end
--]]

--system callback,when a test sequence will go start
function __TestInitial()
-- pivotInit();
end


local function ClearErrorMessage(its)
if (its) then
for index,value in ipairs(its) do
if (value.sub==nil) then		--不处理key item
if ((value.visible~=false) and (value.visible ~=0)) then	--不处理被隐藏的item
--error message
if (value.error_msg) then
value.error_msg = nil;
end
end
else	--get sub items
ClearErrorMessage(value.sub);
end
end
return
end

for index,value in ipairs(items) do
if (value.sub==nil) then		--不处理key item
if ((value.visible~=false) and (value.visible ~=0)) then	--不处理被隐藏的item
--error message
if (value.error_msg) then
value.error_msg = nil;
end
end
else	--get sub items
ClearErrorMessage(value.sub);
end
end
end

--system callback when all test uint has beed finished.
function __TestFinish()
--dut.UnlockAllMyInstrument();
--	pivotFinalize();
dl.GenerateReport(items,__test_state);				--record data
ClearErrorMessage();
end


local function initialTest(its)
--初始化所有测试结果
for index,value in ipairs(its) do
value.value=nil		--clear test result;
value.state=0;
value.starttime = -1;
value.endtime = -1;
value.elapsed = -1;

if (value.sub) then
initialTest(value.sub);
end
end
end

function __getTestResult()
return test_result  ;
end

function __getFailItems()
return table.concat(ItemFail,",");
end

-- Test Support --

function AddSKU(sku)
-- first remove existing
for k,v in ipairs(uutsku) do
if (v == sku) then
table.remove(uutsku,k);
end
end

-- now add to end
uutsku[#uutsku + 1] = sku;
end

--[[
SetSKUByBoardID:
This function should be added to the sequence after booting to EFI diag for the first time.
--]]
function SetSKUByBoardID()
return 0;
--[[
dut.ReadString();
dut.SendCmd("boardid");
dut_response = dut.ReadString();

if (string.match(dut_response, "0x02")) then
AddSKU("X240");
print("X240 detected");
elseif (string.match(dut_response, "0x04")) then
AddSKU("X320");
print("X320 detected");
else
print("SetSKU don't know how to match SKU to boardid '"..dut_response.."'");
end

return 0;
--]]
end

--[[
SetSKUBySoCVoltage:
This function should be added to the sequence after booting to EFI diag for the first time.
--]]
function SetSKUBySoCVoltage()
return -1;
--[[
ret = -1;
dut.ReadString();
dut.SendCmd("soc -p list-soc-bin-data");
dut_response = dut.ReadString();

--	index,freq,volt = dut_response:match("%s+(0)%s+(%d+)%s+(%d+)");
index,freq,volt = dut_response:match("%s+(0)%s+(%w+)%s+(%w+)");

if (index and freq and volt) then
AddSKU(tostring(volt));
ret = 0;
end

DbgOut("SetSKUBySoCVoltage uutsku : "..tostring(uutsku));
DbgOut("SetSKUBySoCVoltage returning "..tostring(ret));

return ret;
--]]
end

function SetSKUByCommand(par)
return -1;
--[[
if (par.cmd) then
dut.ReadString();
dut.SendCmd(par.cmd, ":-)", 20000);
dut_response = dut.ReadString();
end

if (par.rex) then
if (dut_response) then
val = dut_response:match(par.rex);
print("val="..tostring(val));
if (val) then
AddSKU(tostring(val));
tprint(uutsku,0);
--				DbgOut("SetSKUByCommand got sku = "..val);
--				return uutsku;
end
end
else
--		DbgOut("SetSKUByCommand rex not defined in parameter!");
--		return -1;
end

return val;
--]]
end


--[[
ConfigureLimitForItemBySKU:
Switches item.lower and item.upper to sku specific value if available.
--]]
function ConfigureLimitForItemBySKU(item)
print("ConfigureLimitForItemBySKU")
if (item["skulimit"]) then

-- default to ... "default".

item.activesku = nil;

if (item["skulimit"]["default"]) then
item["lower"] = item["skulimit"]["default"]["lower"];
item["upper"] = item["skulimit"]["default"]["upper"];
end

-- assign SKU specific if available.
sku_count = #uutsku;
for sku_index = sku_count,1,-1 do
sku = uutsku[sku_index];
if (item["skulimit"][sku]) then

item["lower"] = item["skulimit"][sku]["lower"];
item["upper"] = item["skulimit"][sku]["upper"];

print("     ConfigureLimitForItemBySKU using sku("..sku..") limit lower=" .. tostring(item["lower"]) .. " upper=" .. tostring(item["upper"]));

item.activesku = sku; -- for pdca name suffixing.

break;
end
end
end
end

function ConfigureWaiverForItemBySKU(item)
print("ConfigureWaiverForItemBySKU")
if (item["skuwaiver"]) then

-- default no waiver.
item["waiver"] = nil;

-- assign SKU specific if available.
sku_count = #uutsku;
for sku_index = sku_count,1,-1 do
sku = uutsku[sku_index];

if (item["skuwaiver"][sku] and (item["skuwaiver"][sku] == true)) then
item["waiver"] = true;

print("waiver for "..item.testkey.." is set");
tprint(item,0);
break;
end

end

end
end

--Main function entry
__test_state=0;
function main(...)
--initial global variant
print("main function start")
ItemFail = {};
ItemFailWaived = {};
uutsku={};
stoptest = false;
--dut.UnlockAllMyInstrument();

test_result = PASS;
--start test
initialTest(items);
ui.TEST_START();		--Update UI to start test
Test_OnEntry();		--Call
--dl.InitialReport(tc.mlbSN())
--	dl.ClearBuffer();
--	dl.BuildCsvLogFileHeader(items);	--build csv log
local ret = "skip"--DoTest(items);		--do test
DbgOut("result : %d",tonumber(ret));
DbgOut("Fail Item : \r\n"..table.concat(ItemFail,","));
DbgOut("Fail Item But is WAIVED : \r\n"..table.concat(ItemFailWaived,","));
Test_OnDone();		--Call back function
ui.TEST_FINISH(ret);			--Show test ressult
__test_state=ret;
--dl.InitialReport(tc.mlbSN());
--dl.GenerateReport(items,ret);				--record data
end

--Chunk
--执行测试代码
--main();
