--配置搜索路径
--package.path = package.path..";".."/Users/ryan/Project/XCode/iTMP/iTMP/script/?.lua"
local modname=...;
local M={};
_G[modname]=M;
package.loaded[modname]=M;
--local SHOW_ALL_ITEM=1		--show the visible item in the UI?
DEFAULT="-"
local t={};

--Now just for debug
local tree={};
local sep="\t"		--字符串分隔符，每一个测试项目用\n份分隔，每一项里面各个内容用该字符分隔。
local steps=0;





local function BuildItemTree(its)
for index,value in ipairs(its) do
local line=nil;
if (value.sub) then		--含有子Item,则处理成keyitme
line = "key"..sep;
else				--否则当成testitem处理
line = "item"..sep;
local strsteps = string.format("%03d",steps);
value.index=strsteps;
line = line..strsteps..sep;		--添加下项目索引号
--			if ((value.visible~=false) and (value.visible ~=0)) then	--显示指定隐藏该项目的显示，则不显示该项目，缺省显示该项目
if ((SHOW_ALL_ITEM==1) or ((value.visible~=false) and (value.visible ~=0))) then	--显示指定隐藏该项目的显示，则不显示该项目，缺省显示该项目
steps=steps+1;
end
end

--		if ((value.visible~=false) and (value.visible ~=0)) then	--显示指定隐藏该项目的显示，则不显示该项目，缺省显示该项目
if ((SHOW_ALL_ITEM==1) or (value.visible ~=0)) then	--显示指定隐藏该项目的显示，则不显示该项目，缺省显示该项目
if (value.entry)  then DEFAULT="N/A"
else DEFAULT="" end
--[[
-----------------------------------------------------------------------
author:ZL Meng
Date:Jul.17 2015
Description:
添加函数limit和表格limit
-----------------------------------------------------------------------
--]]
line = line..tostring(value.name)..sep;
if (value.lower) then
if (type(value.lower)=="table") then
local x = ""
for i,v in ipairs(value.lower) do
if #x==0 then
x=tostring(v)
else
x=x..","..tostring(v)
end
end
line=line.."{"..x.."}"..sep;
elseif (type(value.lower)=="function") then
if functionNameMap==nil then
line=line..tostring(value.lower)..sep
elseif functionNameMap[value.name]~=nil then
line=line..tostring(functionNameMap[value.name][1])..sep
else
line=line..tostring(value.lower)..sep
end
else
line=line..tostring(value.lower)..sep
end
else
line=line..DEFAULT..sep
end
--[[
-----------------------------------------------------------------------
author:ZL Meng
Date:Jul.17 2015
Description:
添加函数limit和表格limit
-----------------------------------------------------------------------
--]]
if (value.upper) then
if (type(value.upper)=="table") then
local x = ""
for i,v in ipairs(value.upper) do
if #x==0 then
x=tostring(v)
else
x=x..","..tostring(v)
end
end
line=line.."{"..x.."}"..sep;
elseif (type(value.upper)=="function") then
if functionNameMap==nil then
line=line..tostring(value.upper)..sep
elseif functionNameMap[value.name]~=nil then
line=line..tostring(functionNameMap[value.name][2])..sep
else
line=line..tostring(value.upper)..sep
end
else
line=line..tostring(value.upper)..sep
end
else
line=line..DEFAULT..sep
end

if (value.unit) then
line=line..tostring(value.unit)..sep
else
--[[
if (value.lower==nil) then
line=line.."p/f"
else
line=line..DEFAULT
end
]]
line=line..DEFAULT..sep;
end

if (value.remark) then
line=line..tostring(value.remark)..sep
else
line=line..""..sep;
end

if (value.testkey) then
line=line..value.testkey..sep;
else
line=line..""..sep;
end

if (value.waiver and (value.waiver == true)) then
line=line.."waiver"..sep;
else
line=line..""..sep;
end
tree[#tree+1]=line;
end

if (value.sub) then		--含有子Item
BuildItemTree(value.sub);
end

end

return table.concat(tree,"\n");
end

local function __FlatItems(it,__itout)
for index,value in ipairs(it) do
print(value.name)
if (value.sub) then	--key item
p=value.name;
__FlatItems(value.sub,__itout);
else
local t={};
t.name=value.name;
t.testkey=value.testkey;
t.parent=p;
t.visible = value.visible;
__itout[#__itout+1]=t;
end
end
end

local function __pdcaname(it)
pdca_name = it.name;
if (it.testkey and it.name) then
--print("__pdcaname - testkey="..it.testkey.." name="..it.name);
pdca_name = it.testkey.." "..it.name;
end
if (it.activesku) then
pdca_name = pdca_name.."-"..it.activesku;
end
return pdca_name;
end

local function __CheckItems(it)
local __items={};
__FlatItems(it,__items);
for i=1,#__items do
local name = __pdcaname(__items[i]);

local visible = __items[i].visible;
if (visible ~= 0)  then	--this item has been show
local _t_duplicat={};
for j=i+1,#__items do
assert(#__pdcaname(__items[j])<=48,string.format("\r\nitem name is too long,length should be less than 48. @\r\n%s", tostring(__pdcaname(__items[j]))));
if (__pdcaname(__items[j]) == __pdcaname(__items[i]) ) then
if (__items[j].visible ~= 0 ) then
_t_duplicat[#_t_duplicat+1]=__items[j];
end
end
--assert(__items[j].name~=__items[i].name,string.format("\r\nduplicat item name : %s,\r\nparent1 : %s \r\nparent2 : %s",__items[i].name,__items[i].parent,__items[j].parent));
end
if (#_t_duplicat>0) then
table.insert(_t_duplicat,1,__items[i]);
local __msg=string.format("\r\nduplicat item name @%d times : %s",#_t_duplicat, tostring(name));
for i,v in ipairs(_t_duplicat) do
__msg=__msg.."\r\n@parent : "..tostring(v.parent);
end
assert(#_t_duplicat==0,__msg);
end
end
end
end

function verifyTestKeyDuplication()

local keys = {};

for k,item in pairs(items) do

if (type(item) == "table") then
sub = item["sub"];
if (sub and (type(sub) == "table")) then
for j,subitem in pairs(sub) do
testkey = subitem["testkey"];
if (testkey) then
if (keys[testkey]) then
keys[testkey] = keys[testkey] + 1;
else
keys[testkey] = 1;
end
end
end

end
end
end

local errstring = "";
for k, c in pairs(keys) do
if (c > 1) then
errstring = errstring .. "testkey: "..k.." --> ".. tostring(c).. "\r\n";
end
--    	print("testkey: "..k.." --> ".. tostring(c));
end
if (string.len(errstring) > 0) then
errstring = "Duplicate testkey:\r\n"..errstring;
print("---> dbg");
print(errstring);
assert(false, errstring);
end

end

function LoadProfile(its)
verifyTestKeyDuplication();
__CheckItems(items);
print("Load Profile");
tree={};
steps=0;
return BuildItemTree(items);
end

function Support__MergeTables(p,t1,t2)
local retval = {};
local count = 1;
if (t1 == nil) then t1 = {} end
if (t2 == nil) then t2 = {} end

for k,v in pairs(t1) do
retval[count] = v
count = count+1
end

for k,v in pairs(t2) do
v["seqfile"] = p
retval[count] = v
count = count+1
end

return retval;
end

--UI接口函数封装
--Marco define
PASS=1;
FAIL=0;
ERROR=-1;

--Global Variant,Do not directly modify these variant.
item_index=0;	--当前测试项目全局索引号

item_value = "";	--保存测试项目的测试结果，以逗号分隔
item_state = 0xFF;	--保存测试项目的测试状态
item_remark = "";	--保存测试项目remark的显示内容

value1 = "N/A";		--临时保存各个产品当前项目的测试值

state1 = PASS;
state2 = PASS;
state3 = PASS;
state4 = PASS;

--每块板子的测试结果	0:FAIL 1:PASS
UUT1_RESULT = 1;
UUT2_RESULT = 1;
UUT3_RESULT = 1;
UUT4_RESULT = 1;


--SN Callback Function
--序列号合法性检测函数，该函数总是只被程序调用，合法则返回1，不合法则返回0
function QueryStationResult(sn,station)
local result = getSFC(sn,"result",station);
print(station.." result  :");
print(tostring(result));
if (not result) then
return -1,"no test on "..station.." station"
end
if (string.upper(tostring(result))=="PASS") then
return 1;
else
return -2,"Test failed on "..station.." station.";
end
end

-----------------UI Callback function-------------------------------
local file_vlookup = "IntLookUpTable.txt"
local function Read_Vlookup(section,key)	--调用时必须有三个参数，1，文件路径 2，大关键字 3，小关键字
local result_chr = nil;
local file_path = tc.AppDir().."/"..file_vlookup;

if (file_path == nil) or (section == nil) then	--检查形参的个数是否齐全，若参数不齐全则直接返回nil
return nil;
end

section = string.upper(section);	--将参数变为大写，防止笔误引起的大小写错误
if (key) then
key = string.upper(key);
end

local f = io.open(file_path, "r");					--打开文件
if f == nil then return nil, "failed to open the file:"..file_path; end
result_chr = tostring(f:read("*all"));				--读取所有数值
f:close();											--关闭文件
result_chr = string.upper(result_chr);		--将读出来的数值全部转为大写
local section_str = string.match(result_chr,"%["..section.."%](.-)%[");	--匹配出大的关键字
--print("result_chr : ",section_str);
if (not section_str) then
section_str = tostring(string.match(result_chr,"%["..section.."%](.*)"));	--匹配出大的关键字
end
--print("result_chr : ",section_str);
if (not key) then
return section_str;		--not specail key, read all the section
end

if (not section_str) then
return nil,section.." section not exist.";
end

result_chr = string.match(section_str,"([^\r^\n]-"..key.."[^\r^\n]*)");		--匹配小关键字的内容
print("Read Out Info is:",result_chr);
if (not result_chr) then
return nil,key.." not exist in "..section;
end
return result_chr;
end

local function CheckEECode(code)
local eeee_code,msg = Read_Vlookup("EEEE_CODE",code);
if (not eeee_code) then
return -1,"Check EEEE_Code failed! with "..msg;
else
local code,t=string.match(eeee_code,"(.-),(.*)");
return 0,t;
end
return nil;
end

function UI_CheckSN(sn,fmt,stations,eecode)
if RouteChecker~=nil then
local isRoutechecker=RouteChecker:getRouteCheckerState();
if isRoutechecker then
local ret=Routechecker(sn);
if ret==1 then
ret=RoutecheckerAAB(sn);
end
if ret==1 then
return 1,"ok"
else
return 0,"Route checker fail";
end
end
end

if ((fmt) and (#fmt>0)) then	--need check the sn format
fmt="^"..fmt.."$";	--match all string
local match = string.match(sn,fmt);
if (not match) then
return 0,"The barcode format is incorrectly.";
end
end

if (eecode) then	--need check eecode
local ret,msg = CheckEECode(string.sub(sn,-6,-3));
if (ret<0) then	--check eecode failed
print(ret,msg);
return ret,msg;
end
end

if (stations) then	--need check station test result.
for station in string.gmatch(stations,"[^,]+") do
local ret,msg = QueryStationResult(sn,string.upper(station));
if (ret<0) then	--previous station test result failed!
print(ret,msg);
return ret,msg;
end
end
end

return 1,"OK"

end

------------------------------------------------------

--local ID=1;
--测试程序wapper函数
function M.TEST_START()		--测试开始更新UI
print(99999999)
item_index=0;		--重置index
--UI:ShowTestStart(ID);
end

function M.ITEM_START()		--使一个测试项显示开始测试
item_remark="";
print("M.ITEM_START")
--UI:ShowItemStart(item_index,ID);
--	item_index=item_index+1;
end

function M.ITEM_FINISH(value,state,display)	--显示一项测试结果，请确保在该函数与ItemStart函数的调用相对应
--[[	if (EN_DUT1 == 0) then value1="" end;
if (EN_DUT2 == 0) then value2="" end;
if (EN_DUT3 == 0) then value3="" end;
if (EN_DUT4 == 0) then value4="" end;
--]]

--	local value = string.format("%s,%s,%s,%s",tostring(item_value),tostring(value2),tostring(value3),tostring(value4));
--	local state = (state4<<3) | (state3<<2) | (state2<<1) | (state1<<0);
--	UI:ShowItemFinish(item_index,value,item_state,item_remark,ID);
UI:ShowItemFinish(item_index,tostring(display or value),tostring(state),item_remark,ID);
item_index=item_index+1;	--自动累加index
end

function M.TEST_FINISH(result)		--测试完成显示PASS or FAIL	-1:ERROR 0:FAIL 1:PASS
UI:ShowTestFinish(result,ID);		--PASS
do return end;
end

function M.DONE(result)
TEST_FINISH(result);
end



--panel SN

--------Global Variant
__S_BUILD=nil;
__BUILD_EVENT=nil;


--[[2014/02/24 10:31:42.178 :  sfc result : 0 SFC_OK  <u+000A>build_config=2R1<u+000A>project_version=PROTO-N<u+000A>project_code=X240<u+000A>build_type=DOEs<u+000A>]]
local function __getSN(panSN,location)
local mlb,cfg,project_code,build_ver,build_type,s_build;
local sfc = tostring(tc.SFC_URL()).."?sn="..tostring(panSN).."-"..tostring(location).."&c=QUERY_RECORD&tsid="..tostring(tc.StationID()).."&p=new_sn";
print(sfc);
--"http://10.5.1.40/bobcat/default.aspx?sn=K1402140007-6&c=QUERY_RECORD&tsid=USSH-JQ01-2FAAP-01_1_DFU&p=build_config&p=project_version&p=project_code&p=build_type";
local mlbSNInfo1=putSFC(sfc);
print(mlbSNInfo1);
if (string.match(tostring(mlbSNInfo1),"SFC_OK")) then
local mlbsn1 = string.match(tostring(mlbSNInfo1),"new_sn=([^\r\n]*)") ;
if (mlbsn1==nil or tostring(mlbsn1)=="No Available SN") then
msgbox("get SN Fail for \r\n:"..tostring(sfc),"Error",nil,nil,nil);
elseif (string.upper(tostring(mlbsn1))=="SCRAP") then	--skip this unit
return "SCRAP";
else
DbgOut("len :"..tostring(#mlbsn1).."\r\n");
if (#mlbsn1==20) then
mlb = string.match(mlbsn1,"(.................)...");
cfg = string.match(mlbsn1,".................(...)");
--UI:ShowScanBarcode(0,0,tostring(mlbsn1));
return mlb,cfg
elseif (#mlbsn1==17) then
mlb = string.match(mlbsn1,"(.................)");
--local sfc_cfg = "http://10.5.1.40/bobcat/default.aspx?sn="..tostring(panSN).."&c=QUERY_RECORD&p=build_config";
local sfc_cfg = tostring(tc.SFC_URL()).."?sn="..tostring(panSN).."&c=QUERY_RECORD&p=build_config&p=project_version&p=project_code&p=build_type&p=s_build";
print(sfc_cfg);
mlbSNInfo1=putSFC(sfc_cfg);
print(mlbSNInfo1);
DbgOut("cfg resonse : "..tostring(mlbSNInfo1));
cfg=string.match(mlbSNInfo1,"build_config=([^\r\n<>]*)")
build_ver=string.match(mlbSNInfo1,"project_version=([^\r\n<>]*)");
project_code=string.match(mlbSNInfo1,"project_code=([^\r\n<>]*)");
build_type=string.match(mlbSNInfo1,"build_type=([^\r\n<>]*)");
s_build=string.match(mlbSNInfo1,"s_build=([^\r\n<>]*)");
return mlb,cfg,project_code,build_ver,build_type,s_build;
end
end
else
msgbox("get SN Fail at \r\n:"..tostring(mlbSNInfo1),"Error",nil,nil,nil);
end
end

local function CheckProcessControl(sn)

end

function Routechecker(sn)
local stepname=RouteChecker:getRouteCheckerStepName();
local Stationname=RouteChecker:getRouteCheckerStationName();
local url=RouteChecker:getSFCIP();
--local sfc = tostring(url).."?SN="..tostring(sn).."&StepName="..tostring(stepname);

local ss="http://%s/MesChecker/RouteChecker.aspx?SN=%s&StepName=%s"
local sfc=string.format(ss,url,sn,stepname);
local ssss=putSFC(sfc,5);
local ssss1=ssss;
if ssss==nil then
msgbox("Routechecker error","Can not connect to SFC Server","OK",nil,nil);
return 0;
end
if #ssss>=1 then
ssss1=string.sub(ssss,1,1);
end
print(ssss);
local ret=tonumber(ssss1);
if ret==nil then
msgbox("Routechecker error","Can not connect to SFC Server","OK",nil,nil);
return 0;
elseif ret==0 then
return 1;
else
msgbox("Routechecker error",ssss,"OK",nil,nil);
return 0;
end
end

function RoutecheckerAAB(sn)
local stepname=RouteChecker:getRouteCheckerStepName();
local Stationname=RouteChecker:getRouteCheckerStationName();
local url=RouteChecker:getSFCIP();
local ss="http://%s/MesChecker/StepAndStationAABPolicyCheck.aspx?SN=%s&StepName=%s&StationName=%s"

local sfc=string.format(ss,url,sn,stepname,Stationname);
local ssss=putSFC(sfc,5);
local ssss1=ssss;
if ssss==nil then
msgbox("AAB error","Can not connect to SFC Server","OK",nil,nil);
return 0;
end
if #ssss>=1 then
ssss1=string.sub(ssss,1,1);
end
print(ssss);
local ret=tonumber(ssss1);
if ret==nil then
msgbox("AAB error","Can not connect to SFC Server","OK",nil,nil);
return 0;
elseif ret==0 then
return 1;
else
msgbox("AAB error",ssss,"OK",nil,nil);
return 0;
end
end

local function Debug(par)
for i=0,5 do
UI:UiCtrl("set_mlb_sn","aklfjkladjlfjkl",i);
UI:UiCtrl("set_cfg_sn","123131231231321",i);
UI:UiCtrl("set_uut_state",i%2,i);
end
end

function ParseBarcode(barcode)
if RouteChecker~=nil then
local isRoutechecker=RouteChecker:getRouteCheckerState();
if isRoutechecker then
local ret=Routechecker(barcode);
if ret==1 then
ret=RoutecheckerAAB(barcode);
end
return ret;
end
end
if (#barcode == 17 or #barcode == 12 or #barcode == 6) then
return 1;	--Call input diagbox;
end

if (#barcode > 17) then
return 1;
end

local l={6,8,12,15,17,21};
for i,v in ipairs(l) do
--		UI:ShowScanBarcode(tonumber(i)-1,-1,tostring(barcode));	--panel sn
UI:UiCtrl("set_panel_sn",barcode,tonumber(i)-1);
local mlb,cfg,project_code,build_ver,build_type,s_build=__getSN(barcode,v);
DbgOut("mlb"..tostring(v).." : "..tostring(mlb).."\r\n".."cfg"..tostring(v).." : "..tostring(cfg).."\r\n");
print("mlb"..tostring(v).." : "..tostring(mlb).."\r\n".."cfg"..tostring(v).." : "..tostring(cfg).."\r\n");

if (not mlb) then
break;
end

if (mlb=="SCRAP") then		--skip this unit;
msgbox(string.format("UUT%d : \r\n%s",tonumber(i)-1,mlb),"Info",nil,nil,nil);
UI:UiCtrl("set_uut_state",0,tonumber(i)-1);
else
--Check Process Control
--			if (not CheckProcessControl(mlb)) then	--Skip this one
if (nil) then	--Skip this one
UI:UiCtrl("set_mlb_sn","",tonumber(i)-1);
UI:UiCtrl("set_cfg_sn","",tonumber(i)-1);
UI:UiCtrl("set_uut_state",0,i-1);
else
UI:UiCtrl("set_uut_state",1,i-1);
if (mlb) then
DbgOut("mlb"..tostring(v).." : "..mlb.."\r\n");
UI:UiCtrl("set_mlb_sn",mlb,tonumber(i)-1);
end

if (cfg) then
if (project_code) then
cfg=tostring(project_code).."/"..tostring(build_ver).."/"..tostring(cfg);
--UI:ShowScanBarcode(tonumber(i)-1,2,tostring(build_ver));	--build event
--UI:ShowScanBarcode(tonumber(i)-1,3,tostring(build_type));	--sbuild

UI:UiCtrl("set_build_event",tostring(build_ver),tonumber(i)-1);
UI:UiCtrl("set_sbuild",tostring(s_build),tonumber(i)-1);

print("S_BUILD : "..tostring(s_build));
print("build event : "..tostring(build_ver));
else
cfg="X240/PROTON/"..cfg;
end
UI:UiCtrl("set_cfg_sn",cfg,tonumber(i)-1);
end
end
end
end

--[[
local panSN,cfg = string.match(barcode,"(%w+)-(%w+)") ;
if (cfg) then
UI:ShowScanBarcode(0,1,tostring(cfg));
UI:ShowScanBarcode(1,1,tostring(cfg));
UI:ShowScanBarcode(2,1,tostring(cfg));
UI:ShowScanBarcode(3,1,tostring(cfg));
UI:ShowScanBarcode(4,1,tostring(cfg));
UI:ShowScanBarcode(5,1,tostring(cfg));
else
msgbox("Error Barcode format for :"..tostring(barcode),"Error",nil,nil,nil);
return 0 ;
end

---"http://10.5.1.40/bobcat/default.aspx?sn=K1401260027-6&c=QUERY_RECORD&tsid=USSH-JQ01-2FAAP-01_1_DFU&p=new_sn";
local sfc = tostring(tc.SFC_URL()).."?sn="..tostring(panSN).."-6&c=QUERY_RECORD&tsid="..tostring(tc.StationID()).."&p=new_sn";
local mlbSNInfo1=putSFC(sfc);
if (string.match(tostring(mlbSNInfo1),"SFC_OK")) then
local mlbsn1 = string.match(tostring(mlbSNInfo1),"new_sn=([^\r\n]*)") ;
if (mlbsn1==nil or tostring(mlbsn1)=="No Available SN") then
msgbox("get SN Fail for \r\n:"..sfc,"Error",nil,nil,nil);
else
UI:ShowScanBarcode(0,0,tostring(mlbsn1));
end
else
msgbox("get SN Fail at \r\n:"..tostring(mlbSNInfo1),"Error",nil,nil,nil);
end

sfc = tostring(tc.SFC_URL()).."?sn="..tostring(panSN).."-8&c=QUERY_RECORD&tsid="..tostring(tc.StationID()).."&p=new_sn";
local mlbSNInfo2=putSFC(sfc);
if (string.match(tostring(mlbSNInfo2),"SFC_OK")) then
local mlbsn2 = string.match(tostring(mlbSNInfo2),"new_sn=([^\r\n]*)") ;
if (mlbsn2==nil or tostring(mlbsn2)=="No Available SN") then
msgbox("get SN Fail for \r\n:"..sfc,"Error",nil,nil,nil);
else
UI:ShowScanBarcode(1,0,tostring(mlbsn2));
end
else
msgbox("get SN Fail at \r\n:"..tostring(mlbSNInfo2),"Error",nil,nil,nil);
end

sfc = tostring(tc.SFC_URL()).."?sn="..tostring(panSN).."-12&c=QUERY_RECORD&tsid="..tostring(tc.StationID()).."&p=new_sn";
local mlbSNInfo3=putSFC(sfc);
if (string.match(tostring(mlbSNInfo3),"SFC_OK")) then
local mlbsn3 = string.match(tostring(mlbSNInfo3),"new_sn=([^\r\n]*)") ;
if (mlbsn3==nil or tostring(mlbsn3)=="No Available SN") then
msgbox("get SN Fail for \r\n:"..sfc,"Error",nil,nil,nil);
else
UI:ShowScanBarcode(2,0,tostring(mlbsn3));
end
else
msgbox("get SN Fail at \r\n:"..tostring(mlbSNInfo3),"Error",nil,nil,nil);
end

sfc = tostring(tc.SFC_URL()).."?sn="..tostring(panSN).."-15&c=QUERY_RECORD&tsid="..tostring(tc.StationID()).."&p=new_sn";
local mlbSNInfo4=putSFC(sfc);
if (string.match(tostring(mlbSNInfo4),"SFC_OK")) then
local mlbsn4 = string.match(tostring(mlbSNInfo4),"new_sn=([^\r\n]*)") ;
if (mlbsn4==nil or tostring(mlbsn4)=="No Available SN") then
msgbox("get SN Fail for \r\n:"..sfc,"Error",nil,nil,nil);
else
UI:ShowScanBarcode(3,0,tostring(mlbsn4));
end
else
msgbox("get SN Fail at \r\n:"..tostring(mlbSNInfo4),"Error",nil,nil,nil);
end

sfc = tostring(tc.SFC_URL()).."?sn="..tostring(panSN).."-17&c=QUERY_RECORD&tsid="..tostring(tc.StationID()).."&p=new_sn";
local mlbSNInfo5=putSFC(sfc);
if (string.match(tostring(mlbSNInfo5),"SFC_OK")) then
local mlbsn5 = string.match(tostring(mlbSNInfo5),"new_sn=([^\r\n]*)") ;
if (mlbsn5==nil or tostring(mlbsn5)=="No Available SN") then
msgbox("get SN Fail for \r\n:"..sfc,"Error",nil,nil,nil);
else
UI:ShowScanBarcode(4,0,tostring(mlbsn5));
end
else
msgbox("get SN Fail at \r\n:"..tostring(mlbSNInfo5),"Error",nil,nil,nil);
end

sfc = tostring(tc.SFC_URL()).."?sn="..tostring(panSN).."-21&c=QUERY_RECORD&tsid="..tostring(tc.StationID()).."&p=new_sn";
local mlbSNInfo6=putSFC(sfc);
if (string.match(tostring(mlbSNInfo6),"SFC_OK")) then
local mlbsn6 = string.match(tostring(mlbSNInfo6),"new_sn=([^\r\n]*)") ;
if (mlbsn6==nil or tostring(mlbsn6)=="No Available SN") then
msgbox("get SN Fail for \r\n:"..sfc,"Error",nil,nil,nil);
else
UI:ShowScanBarcode(5,0,tostring(mlbsn6));
end
else
msgbox("get SN Fail at \r\n:"..tostring(mlbSNInfo6),"Error",nil,nil,nil);
end
--]]
return 0;
end


function __GetFixtureID()
return fixture.FixtureID();
end
