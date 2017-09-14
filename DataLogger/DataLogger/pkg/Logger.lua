--DUT操作函数模块

local modname=...;
local M={};
_G[modname]=M;
package.loaded[modname]=M;
--[[
Version History:
V1.2:
	1.去掉pudding_item里not value.value,试图修复出现BATT_RESET_CURRENT重复上传报错的情况
V1.1:
	1.修复在上传pdca时，判断是否为skipped项目的bug,value.state==2表示该项目被skipped.
	2.当一个项目被设置上传为attribute(pdca=1),且返回一个fail的结果(state==0)时,强制将该项目转为一个无值型的item
	  以修复pdca不处理attribute的pass or fail,但本地又需要判断attribute的pass or fail，当出现attribute测试fail时，将造成本地与pdca不一致的情况。
--]]



--Global Variant
local __Title=nil;
local __WaivePudding = false;

--Marco define
local DL_LOG = 1;	--记录调试信息

local function DL_log(fmt,...)
	if (DL_LOG ~=0) then
		Log("	:)"..string.format(fmt,...),ID);
	end
end

function M.SetFileHeader(fileheader)
	return DataLogger:SetFileHeader(fileheader);
end

ICT_OS_items="";
ICT_MDA_items="";
local items_names={};
local items_upper={};
local items_lower={};
local items_units={};
local items_value={};

local ItemErrMsg="";

--枚举当前测试项目的递归函数
--local index_number=0;
local function EnumItemList(its)
	for index,value in ipairs(its) do
		if (value.sub==nil) then		--不处理key item
			if ((value.visible~=false) and (value.visible ~=0)) then	--不处理被隐藏的item
				--DbgOut("Name : %s, Value : %s\r\n",tostring(value.name),tostring(value.value));
				if (value.value) then
					--items_value[#items_value+1]=string.gsub(tostring(value.value),",",";");	--test reult;
					local tmp = string.gsub(tostring(value.value),",",";");	--test reult;
					tmp = string.gsub(tostring(tmp),"[\r\n]","\t");
					items_value[#items_value+1]=tmp;	--test reult;
				else
					items_value[#items_value+1]="";	--no test,has been skipped
				end
				
				--error message
				if (value.error_msg) then
					if (#tostring(value.error_msg)~=0) then
						local tmp = string.gsub(tostring(value.error_msg),",",";");	--test reult;
						tmp = string.gsub(tostring(tmp),"[\r\n]","\t");
						ItemErrMsg=ItemErrMsg..tostring(value.error_msg)..";";
					end
				end
				
--				index_number=index_number+1;
				items_names[#items_names+1]=string.gsub(pdcaname(value),",",";");	--replace , with ; for match csv file format
				--[[
				if (value.upper) then
					items_upper[#items_upper+1]=value.upper;
					items_lower[#items_lower+1]=value.lower;
				else
					items_upper[#items_upper+1]="N/A";
					items_lower[#items_lower+1]="N/A";
				end
				--]]
				if (value.upper) then
					if (#tostring(value.upper)==0) then
						items_upper[#items_upper+1]="N/A";		--""
                        --[[
                         -----------------------------------------------------------------------
                         author:ZL Meng
                         Date:Jul.17 2015
                         Description:
                         添加函数limit和表格limit
                         -----------------------------------------------------------------------
                         --]]
					elseif (type(value.upper)=="function") then
						if functionNameMap==nil then
							items_upper[#items_upper+1]="\""..tostring(value.upper).."\""
						elseif functionNameMap[value.name]~=nil then
							items_upper[#items_upper+1]="\""..tostring(functionNameMap[value.name][2]).."\""
						else
							items_upper[#items_upper+1]=tostring(value.upper)
						end
					elseif (type(value.upper)=="table") then
						local x = ""
						for i,v in ipairs(value.upper) do
							if #x==0 then
								x=tostring(v)
							else
								x=x..","..tostring(v)
							end
						end
						items_upper[#items_upper+1]="\"{"..x.."}\"";
					else
						items_upper[#items_upper+1]="\""..tostring(value.upper).."\"";
					end
				else
					items_upper[#items_upper+1]="N/A";
				end
				
				if (value.lower) then
					if (#tostring(value.lower)==0) then			--""
						items_lower[#items_lower+1]="N/A";
                        --[[
                         -----------------------------------------------------------------------
                         author:ZL Meng
                         Date:Jul.17 2015
                         Description:
                         添加函数limit和表格limit
                         -----------------------------------------------------------------------
                         --]]
					elseif (type(value.lower)=="function") then
						if functionNameMap==nil then
							items_lower[#items_lower+1]="\""..tostring(value.lower).."\""
						elseif functionNameMap[value.name]~=nil then
							items_lower[#items_lower+1]="\""..tostring(functionNameMap[value.name][1]).."\""
						else
							items_lower[#items_lower+1]="\""..tostring(value.lower).."\""
						end
					elseif (type(value.lower)=="table") then
						local x = ""
						for i,v in ipairs(value.lower) do
							if #x==0 then
								x=tostring(v)
							else
								x=x..","..tostring(v)
							end
						end
						items_lower[#items_lower+1]="\"{"..x.."}\"";
					else
						items_lower[#items_lower+1]="\""..tostring(value.lower).."\"";
					end
				else
					items_lower[#items_lower+1]="N/A";
				end
				
				if (value.unit) then
					items_units[#items_units+1]=value.unit;
				else
					items_units[#items_units+1]="N/A";
				end
			end
		else	--get sub items
			EnumItemList(value.sub);
		end
	end
end

--创建Csv文件头
local function BuildCsvLogFileHeader(its)
	--reintial header
	items_names={};
	items_upper={};
	items_lower={};
	items_units={};
	items_value={};
--	index_number=0;
	ItemErrMsg="";
	EnumItemList(its);
	
	local csv_header=tc.LineNumber()..","..tc.StationNumber()..",".."Intelligent"..",".."SoftWare Version: "..tc.SWVersion()..","..tostring(Module)..","..tostring(Version).."\r\n";		--first Line

	local csv_header=csv_header.."PanelSN,Serial Number,Config,Station ID,Fixture ID,Site ID,Test PASS/FAIL STATUS,Error Message,List of Failing Tests,Test Start Time,Test Stop Time,Total Test Time";
	
	csv_header = csv_header..","..table.concat(items_names,",").."\r\n";
	csv_header=csv_header..ICT_OS_items;
	csv_header=csv_header..ICT_MDA_items;
	
	csv_header = csv_header.."Upper Limited-------->,,,,,,,,,,,,"..table.concat(items_upper,",").."\r\n";
	csv_header = csv_header.."Lower Limited-------->,,,,,,,,,,,,"..table.concat(items_lower,",").."\r\n";
	csv_header = csv_header.."Measurement Units---->,,,,,,,,,,,,"..table.concat(items_units,",").."\r\n";
	
	M.SetFileHeader(csv_header);
end

local function CsvFieldInsert(index, name, value, upper, lower, unit)
    table.insert(items_names, index, tostring(name));
    table.insert(items_value, index, tostring(value));
    table.insert(items_upper, index, tostring(upper));
    table.insert(items_lower, index, tostring(lower));
    table.insert(items_units, index, tostring(unit));
end
--创建CSV数据文件报表
local function CsvReport(result)
--	local filepath = tc.VaultPath().."/"..tc.CsvLogPath.."/"..os.date("%Y-%m-%d %H:%M:%S.csv")
	local lineName = tostring(tc.LineName());
	lineName = string.gsub(lineName,"/","-");
	local profile = string.match(tc.ProfilePath(),".*/(.+)$");
	if (not profile) then
		profile = tc.ProfilePath();
	end
	
	if (__Title) then	--has set Title,need add title in the head of file path
		profile = __Title.."_"..profile;
	end
	
	local filepath = tostring(tc.LogDir()).."/"..tostring(profile).."@"..lineName.."@"..os.date("%Y-%m-%d.csv");
--	local filepath = tostring(tc.LogDir()).."/"..os.date("%Y%m%d_%H%M").."_"..tc.StationID()..".csv";

    --[[ prepend context fields
        PanelSN
        Serial Number
        Config
        Station ID
        Site ID
        Test PASS/FAIL STATUS
        Error Message
        List of Failing Tests
        Test Start Time
        Test Stop Time
        Total Test Time
    --]]

    pf = "FAIL";
    if (result>0) then
        pf = "PASS";
    end

    errmsg = "";
    if (result<=0) then
        errmsg = tostring(ItemErrMsg);
        errmsg = string.gsub(errmsg,",","");
    end

    local f = table.concat(ItemFail,";");
    f = string.gsub(f,",",";");--replace , with ; for match csv file format

	--print("=============================");
	--tprint(items_names,0);
	--print("=============================");

    CsvFieldInsert(1,"PanelSN",tostring(tc.PanelSN()),"","","");
    CsvFieldInsert(2,"Serial Number",tostring(tc.mlbSN()),"","","");
    CsvFieldInsert(3,"Config",tostring(tc.cfgSN()),"","","");
    CsvFieldInsert(4,"Station ID",tostring(tc.LineName()),"","","");
    CsvFieldInsert(5,"Fixture ID",tostring(tc.FixtureID()),"","","");
    CsvFieldInsert(6,"Site ID",tostring(tonumber(tc.ID())+1),"","","");
    CsvFieldInsert(7,"Test PASS/FAIL STATUS",pf,"","","");
    CsvFieldInsert(8,"Error Message",errmsg,"","","");
    CsvFieldInsert(9,"List of Failing Tests",f,"","","");
    CsvFieldInsert(10,"Test Start Time",tostring(tc.StartTime()),"","","");
    CsvFieldInsert(11,"Test Stop Time",tostring(tc.StopTime()),"","","");
    CsvFieldInsert(12,"Total Test Time",tostring(tc.TotalTime()),"","","");

	--print("-----------------------------");
	--tprint(items_names,0);
	--print("-----------------------------");
    DataLogger:push_keys(table.concat(items_names,","));
    DataLogger:push_values(table.concat(items_value,","));
    DataLogger:push_uppers(table.concat(items_upper,","));
    DataLogger:push_lowers(table.concat(items_lower,","));
    DataLogger:push_units(table.concat(items_units,","));


	return DataLogger:csvReport(filepath);	--保存到数据文件
end

--UART Log 报表
local __Uart_Path=nil;
local function UartReport(filepath)
	--local filepath = "[LOG_DIR]/uart_log/[sn]_[station id]_[sit id]_[timestamp]_uart.txt";
	--local filepath = tostring(tc.VaultPath()).."/"..tostring(tc.UartLogPath()).."/"..tostring(tc.StationName()).."_"..tostring(tc.mlbSN()).."_"..tostring(tc.ID()).."_"..os.date("%Y-%m-%d-%H-%M-%S").."_uart.txt";
	local filepath = tostring(tc.LogDir()).."/"..tostring(tc.UartLogPath()).."/"..tostring(tc.StationName()).."_"..tostring(tc.mlbSN()).."_"..tostring(tc.ID()).."_"..os.date("%Y-%m-%d-%H-%M-%S").."_uart.txt";
	if (__Title) then	--has set Title,need add title in the head of file path
		filepath = tostring(tc.LogDir()).."/"..tostring(tc.UartLogPath()).."/"..__Title.."_"..tostring(tc.mlbSN()).."_"..tostring(tc.ID()).."_"..os.date("%Y-%m-%d-%H-%M-%S").."_uart.txt";
	else
		filepath = tostring(tc.LogDir()).."/"..tostring(tc.UartLogPath()).."/"..tostring(tc.StationName()).."_"..tostring(tc.mlbSN()).."_"..tostring(tc.ID()).."_"..os.date("%Y-%m-%d-%H-%M-%S").."_uart.txt";
	end
	__Uart_Path = filepath;
	return DataLogger:uartLog(filepath);
end

--Test Flow报表
local function TestFlowReport()
	--local filepath = tostring(tc.VaultPath()).."/"..tostring(tc.TestFlowPath()).."/"..tostring(tc.StationName()).."_"..tostring(tc.mlbSN()).."_"..tostring(tc.ID()).."_"..os.date("%Y-%m-%d-%H-%M-%S").."_flow.txt";
	local filepath = tostring(tc.LogDir()).."/"..tostring(tc.TestFlowPath()).."/"..tostring(tc.StationName()).."_"..tostring(tc.mlbSN()).."_"..tostring(tc.ID()).."_"..os.date("%Y-%m-%d-%H-%M-%S").."_flow.txt";
	if (__Title) then	--has set Title,need add title in the head of file path
		filepath = tostring(tc.LogDir()).."/"..tostring(tc.TestFlowPath()).."/"..__Title.."_"..tostring(tc.mlbSN()).."_"..tostring(tc.ID()).."_"..os.date("%Y-%m-%d-%H-%M-%S").."_flow.txt";
	else
		filepath = tostring(tc.LogDir()).."/"..tostring(tc.TestFlowPath()).."/"..tostring(tc.StationName()).."_"..tostring(tc.mlbSN()).."_"..tostring(tc.ID()).."_"..os.date("%Y-%m-%d-%H-%M-%S").."_flow.txt";	
	end
	return DataLogger:testflowLog(filepath);
end

local function _flattenItemsForTestTimes(its, tb)
	for i,v in ipairs(its) do

--[[
		print("i", tostring(i), "  v", tostring(v), "\n");
		print("=======\n");
		tprint(v);
		print("=======\n");
--]]

		name = pdcaname(v);
		s = v.state;
		
		tval = {};
		tval.name = name;
		if (s ~= 0) then
			tval.elapsed = v.elapsed;	
		else
			tval.elapsed = (v.elapsed * -1);		-- failed item, use negative test time.
		end				
		
		table.insert(tb, tval);	-- insert a key/value pair so that parent table is an ordered array.
		
		if (v.sub ~= nil) then
			_flattenItemsForTestTimes(v.sub, tb);
		end
	end
end
local function TestTimeReport(its,result)

	local lineName = tostring(tc.LineName());
	local header = {};
	
	-- create test time table
	local testtimes = {};
	_flattenItemsForTestTimes(its, testtimes);

--[[
	print("----- testtimes -----\n");
	tprint(testtimes);
	print("+++++ testtimes +++++\n");
--]]

	local pf = "FAIL";
    if (result>0) then
        pf = "PASS";
    end
    errmsg = "";
    if (result<=0) then
        errmsg = tostring(ItemErrMsg);
    end
    local itemFailedList = table.concat(ItemFail,";");
    itemFailedList = string.gsub(itemFailedList,",",";");--replace , with ; for match csv file format

		
	lineName = string.gsub(lineName,"/","-");
	local profile = string.match(tc.ProfilePath(),".*/(.+)$");
	if (not profile) then
		profile = tc.ProfilePath();
	end
	
	if (__Title) then	--has set Title,need add title in the head of file path
		profile = __Title.."_"..profile;
	end
	
	local filepath = tostring(tc.LogDir()).."/"..tostring(profile).."@"..lineName.."@"..os.date("%Y-%m-%d_TestTime.csv");

	local append = 0;
	
	-- Create Header
	local f=io.open(filepath,"r")
   	if f~=nil then
		append = 1;
		
		-- merge
		headerline = f:read();
		print("merge headerline = <", headerline, ">\n");
		header=split(headerline,",");

   		for i, v in ipairs(testtimes) do
   			header_exist = false;
   			for _, h in ipairs(header) do
   				if (h == v.name) then
   					header_exist = true;
   					break;
   				end
   			end
			if (not header_exist) then
				table.insert(header, v.name);
			end
   		end
		f:close();
		
		-- update header
		f = io.open(filepath,"r");
		local existing_content = f:read("*a");
		f:close();
		
		first_nl = string.find(existing_content,"\n");
		local new_content = table.concat(header,",");
		new_content = new_content .. string.sub(existing_content,first_nl);
		
		
		f = io.open(filepath, "w");
		f:write(new_content);
		f:close();

		
   	else
   		-- make new
   		append = 0;
   		
   		table.insert(header, "PanelSN");
   		table.insert(header, "Serial Number");
   		table.insert(header, "Config");
   		table.insert(header, "Station ID");
   		table.insert(header, "Site ID");
   		table.insert(header, "Test PASS/FAIL STATUS");
   		table.insert(header, "Error Message");
   		table.insert(header, "List of Failing Tests");
   		table.insert(header, "Test Start Time");
   		table.insert(header, "Test Stop Time");
   		table.insert(header, "Total Test Time");
   		
   		for i, v in ipairs(testtimes) do
   			table.insert(header, v.name);
   		end
   	end

--[[
   	print("----- header -----\n");
   	tprint(header);
   	print("+++++ header +++++\n");
--]]

   	-- fill in data
	local row = {};
	for i, v in ipairs(header) do
		key_added = false;
		
		-- standard fields
		if (v == "PanelSN") then
			table.insert(row, tostring("nil"));
			key_added = true;
		end
		if (v == "Serial Number") then
			table.insert(row, tostring(tc.mlbSN()));
			key_added = true;
		end
		if (v == "Config") then
			table.insert(row, tostring(tc.cfgSN()));
			key_added = true;
		end
		if (v == "Station ID") then
			table.insert(row, tostring(tc.LineName()));
			key_added = true;
		end
		if (v == "Site ID") then
			table.insert(row, tostring(tonumber(tc.ID())+1));
			key_added = true;
		end
		if (v == "Test PASS/FAIL STATUS") then
			table.insert(row, pf);
			key_added = true;
		end
		if (v == "Error Message") then
			table.insert(row, errmsg);
			key_added = true;
		end
		if (v == "List of Failing Tests") then
			table.insert(row, itemFailedList);
			key_added = true;
		end
		if (v == "Test Start Time") then
			table.insert(row, tostring(tc.StartTime()));
			key_added = true;
		end
		if (v == "Test Stop Time") then
			table.insert(row, tostring(tc.StopTime()));
			key_added = true;
		end
		if (v == "Total Test Time") then
			table.insert(row, tostring(tc.TotalTime()));
			key_added = true;
		end
	
		-- test fields
		for ti, tval in ipairs(testtimes) do
			if (tval.name == v) then
				table.insert(row, tostring(tval.elapsed));
			key_added = true;
				break;
			end
		end
		
		if (not key_added) then
			table.insert(row, "");
		end 
	end
   
	if (append == 0) then
		f=io.open(filepath,"w");
		if (f ~=nil) then
			f:write(table.concat(header,","));
		end
	else
		f=io.open(filepath,"a");
	end
	
	if (f ~=nil) then
		f:write("\n");
		f:write(table.concat(row,","));
		f:close();
	else
		print("TestTimeReport - Failed to open file !!!\n");
	end	

   
end
function SaveToFile(its,result)
	BuildCsvLogFileHeader(its);
	CsvReport(result);
	UartReport();
	TestFlowReport();
--    TestTimeReport(its,result);
--	return DataLogger:SaveToFile(filepath);
end

--*******************************************Pudding******************
--PDCA pudding entry
--const char * pdca_init(const char * mlbsn,const char * sw_name="intelli_fct",const char * sw_version="1.0",const char * limit_version="1.0");
local function Pudding_Init(sn,sw,sw_v,limit_v)
	return DataLogger:pdca_init(sn,sw,sw_v,limit_v);
end


local function Pudding_Attribute(key,value)
end

ATTRIBUTE=1;
PDCA_ITEM=0
PDCA_NOUPLOD=-1;
--
-- int push_item(char * name,int status,char * value=NULL,char * lower=NULL,char * upper=NULL,char * unit=NULL);
-- int push_attr(char * value,char * key);
-- int push_result(int result);
--
-- reworked by manuel
--
local function Pudding_Item__internal_submission(test, subtest, subsubtest, status, value, lower, upper, units)
	local str = string.format(
		"Pudding Item :\t@Test_Name=%s\t@sub_name=%s\t@sub_sub_name=%s\t@state=%s\t@value=%s",
		tostring(test),
		tostring(subtest),
		tostring(subsubtest),
		tostring(state),
		tostring(value)
	);
	DbgOut(str);

	DataLogger:push_item(test, subtest, subsubtest, status, value, lower, upper, units);
end

local function Pudding_Item__internal(value, test_name, subtest_name)
	if ((not value.state) or (value.state==2) or (not value.value)) then	--this item has been skipped,
		 --Do Nothing
		 DbgOut("item "..value.name.." skipped. ".."state : "..tostring(value.state));
		 return
	end

	DbgOut("items.pdca : "..tostring(value.pdca).."\r\n");
	local pdca = value.pdca;
	if (pdca == nil) then	--pdca没有被指定,采用默认值
		if ((value.visible~=false) and (value.visible ~=0)) then	--item没有被隐藏,需要上传数据
			pdca=0;    --默认为上传item
		else
			pdca=-1;   --否则不上传
		end
	end

	local na = "N/A"
	local l = tonumber(value.lower);
	local u = tonumber(value.upper);
	local n = value.unit;
	local v = tonumber(value.value);

	-- fixup test value
	if (not v) then v="N/A" end

	if (v ==  math.huge) then v=  999999 end
	if (v == -math.huge) then v= -999999 end

	if (string.upper(tostring(v)) == "+INF") then v=  999999 end
	if (string.upper(tostring(v)) == "-INF") then v= -999999 end
	if (string.upper(tostring(v)) == "NAN")  then v= "N/A" end

	-- fixup limits
	if ((l==math.huge) or (l==-math.huge)) then l="N/A" end
	if ((u==math.huge) or (u==-math.huge)) then u="N/A" end

	if ((not l) or (#tostring(l)==0)) then l="N/A" end
	if ((not u) or (#tostring(u)==0)) then u="N/A" end

	-- fixup units
	if ((not n) or (#tostring(n)==0)) then n="N/A" end

	-- compute what to submit
	local submit_attribute         = (pdca >= 1)
	local submit_attribute_failure = (pdca == 1) and (value.state == 0)
	local submit_parametric_data   = (pdca == 0) or  (pdca == 2)
	local submit_parametric_cof    = submit_parametric_data and (value.state == 3)

	print("hello 55 ", submit_attribute, submit_attribute_failure, submit_parametric_data, submit_parametric_cof)
	for k,v in pairs(value) do
		print(k,v)
	end

	if (submit_attribute)
	then
		local __attribute_value = value.value;

		if (__attribute_value==nil) or (__attribute_value=="nil") then
			__attribute_value = "NULL";
		end

		DataLogger:push_attr(tostring(__attribute_value),tostring(value.name));
	end

	if (submit_attribute_failure)
	then 
		Pudding_Item__internal_submission(test_name, subtest_name, value.name, value.state, tostring(v), na, na, n);
	end

	if (submit_parametric_data)
	then
		Pudding_Item__internal_submission(test_name, subtest_name, value.name, value.state, tostring(v), l, u, n);
	end

	if (submit_parametric_cof)
	then
		Pudding_Item__internal_submission("CoF_"..test_name, subtest_name, value.name, value.state, tostring(v), l, u, n);
	end
end

local function Pudding_Item__recur(value, test_name, subtest_name)
	local TestNodeName="Init"
	local test_module = "default";
	if (Module and #Module>0) then
		test_module = string.gsub(Module, "[^_%w]", "_");
		if (test_module == nil) then
			test_module = "default";
		end
	end

	for index,value in pairs(value) do
		if (value.sub==nil) then
			pdca_name = pdcaname(value);
			Pudding_Item__internal(value, pdca_name, subtest_name)
		else	--get sub items
			--local test_bundle = value.seqfile
			local test_bundle = test_module
			local test_node   = value.name

			if (test_bundle == nil) then test_bundle = "default" end
			if (test_node   == nil) then test_node   = "default" end

			Pudding_Item__recur(value.sub, test_bundle, test_node)
		end
	end
end

local function Pudding_Item(its)
	--return Pudding_Item__recur(its, "default", "default");
	local test_module = "default";
	if (Module and #Module>0) then
		test_module = string.gsub(Module, "[^_%w]", "_");
		if (test_module == nil) then
			test_module = "default";
		end
	end
	return Pudding_Item__recur(its, test_module, "default");
end

local function Pudding_Result(result)
	print("hello")
	DataLogger:push_result(result)
end



local SN=""
local function Pudding(its,result)
	lock();
	--Pudding_Init(SN,"intelli_FCT","1.0.0.1","1.0");
	local vs = Version;
	if (not vs) then 
		vs = "intelli_FCT_V01";
	end
	DbgOut("Software Version : "..tostring(vs).."\r\n");
	--Pudding_Init(SN,"intelli_FCT",vs,"1.0");
	Pudding_Item(its);
	Pudding_Result(result);
	local ret = DataLogger:ipReport("");	--保存到数据文件
	
	--[[
	--upload to SFC
	local address="http://172.16.240.171/mlbpx?sn=[sn]&c=ADD_RECORD&test_station_name=FCT&station_id=FXLH_G02-3FT-08A_12_FCT&start_time=2013-05-09+21:24:00&stop_time=2013-05-09+21:31:30&mac_address=a8:20:66:23:87:00&result=[result]&product=NIL";
	address = string.gsub(address,"%[sn%]",SN);
	if (result>0) then
		address = string.gsub(address,"%[result%]","PASS");
	else
		address = string.gsub(address,"%[result%]","FAIL");
	end
	DbgOut("SFC address : "..tostring(address).."\r\n");
	local sfc = putSFC(address);
	DbgOut("sfc Response : "..tostring(sfc).."\r\n");
	--]]
	unlock();
	return ret;
end

local function SendBlob(name,file_path,result)	
	local result = DataLogger:SendBlob(name,file_path,result);
	return result;
end


--export function
function M.AddBlob(file)
	return DataLogger:AddBlob(file);
end

function M.SetTitle(title)
	__Title=title;
end


function M.SetFixtureID()
	local fixtureid = string.match(tostring(tc.FixtureID()),".-(%d+)$");
	fixtureid = tonumber(fixtureid);
	DbgOut("FixtureID : "..tostring(fixtureid));
	assert(fixtureid,"Could't get fixture id, this fixture id should be number,please setup the --fixture id firstly! Now is : \r\n"..tostring(tc.FixtureID()));
	return DataLogger:SetFixtureID(fixtureid,tonumber(tc.ID()+1));
end

local function getOverlayVersion()
       local p = "/Users/gdlocal/Desktop/Restore Info.txt"
       local f = io.open(p,"r");
       assert(f,"Restroe Info.txt not exist,please check it.");
       local str = f:read("*all");
       f:close();
       str  = tostring(str):match("STATION_OVERLAY_VERSION=%s*(.-)%s*[\r\n]")
       assert(str,"Restore Info.txt file is OK,but get overlay version failed,please check it!");
       
       
       local s1 = string.match(str, "(.*) %[.*%]");
       if (s1) then
       	str = s1;
       end
       local c = string.find(string.upper(str), "DFU%-NAND%-INIT");
       if (c) then
       		str = string.sub(str, c+#"DFU-NAND-INIT"+1, #str);
       		if (str) then
       			str = string.gsub(str, "[Dd][Cc][Ss][Dd]%-%d+_", "");
       			if (str) then
       				str = string.sub(str, 1, 48);
       				str = string.gsub(str,"^[^%w]*(.-)[^%w]*$", "%1");
       				if (str) then
       					return str;
       				end
       			end
       		else
       			
       		end
       end
       
       
       str = str:gsub(" ","_");
       str = str:gsub("-","_");
	   str = str:gsub("%[","_");
	   str = str:gsub("%]","_");
	   str = str:gsub("%/","_");
       
       --[[
	   local tmp = tostring(str):match("(.+)%..+");		--Remove file extension
	   if (tmp) then
			str = tmp;
	   end
	   --]]
	   str = string.gsub(str, "(.-)%.[%w]+$", "%1");
	   
	   	
	   local str_os = string.sub(str, -49, -1);--get last 49 char
		
	   if (#str_os<=48) then	--total length <=48,just skip "_" at beginning
		   return str_os:match("_?(.+)");
	   end
		
	   local str_ret = str_os:match(".-_(.+)");	--skip the word before first "_"
	   if (str_ret) then
			return str_ret;
	   end
	   return str_os:sub(-48,-1);	--no "_" in string, get the last 48 character.
end


function M.InitialReport(mlbsn,cfg)
	__Title=nil;
	SN=mlbsn;
	--local vs = getOverlayVersion();
    local vs = nil;
    vs = Version;
	if (not vs) then
		vs = "Intelli_TM_V01";
	end
	lock();
	Pudding_Init(SN,"intelli_FCT",vs,"1.0");
	unlock();
	--Pudding_Init(mlbsn,"intelli_FCT","1.0.0.0","1.0");
	TestFlowOut("Panel SN		: "..tostring(tc.PanelSN()));
	TestFlowOut("MLB SN			: "..tostring(tc.mlbSN()));
	TestFlowOut("Config			: "..tostring(tc.cfgSN()));
	TestFlowOut("Script Version	: "..tostring(Version));
	TestFlowOut("Station Name 	: "..tostring(tc.StationName()));
	TestFlowOut("Line Number 	: "..tostring(tc.LineName()));
	TestFlowOut("Fixture ID		: "..tostring(tc.FixtureID()));
	TestFlowOut("Slot ID 		: "..tostring(tc.ID()));
	
	M.SetFixtureID();
end

function M.GenerateReport(its,result)
	SaveToFile(its,result)
	local ret = SendBlob("FCT",tc.mlbSN()..os.date("_%Y-%m-%d-%H-%M-%S")..".zip",result);
    if ret<0 then
        UI:ShowTestError(0,"Pudding Blob failed,return value is :"..tostring(ret));
    else
        Pudding(its,result);
    end
	--assert(ret>=0,"Pudding Blob failed,return value is :"..tostring(ret));
end

function M.PuddingDCSDLog(name, file_path)
	local result = DataLogger:PuddingBlob(name, file_path);
	return result;
end

function M.QuerySFC(key,station)
	return DataLogger:QuerySFC("ecid","fct");
end


--process control
function M.CheckFetalError()
	local ret = DataLogger:CheckFetalError(tc.mlbSN());
	if (ret == nil) then
		__WaivePudding = false;
	else
		__WaivePudding = true;
	end
	return ret;
end

function M.CheckProcessControl()
	return DataLogger:CheckProcessControl(tc.mlbSN());
end
