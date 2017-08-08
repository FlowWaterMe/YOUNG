--配置搜索路径
--Global function
--This script file will be loaded into system automatically,you can place some golbal function in here

--[[
--序列号合法性检测函数，该函数总是只被程序调用，合法则返回1，不合法则返回0
local function CheckICT(sn)
	local result = getSFC(sn,"result","ICT");
	print("ict result  :");
	print(tostring(result));
	if (not result) then
		return -1,"no test on ICT station"
	end
	if (string.upper(tostring(result))=="PASS") then
		return 1;
	else
		return -2,"Test failed on ICT station.";	--ict test failed
	end
end

local function CheckFCT(sn)
	local result = getSFC(sn,"result","FCT");
	print("ict result  :");
	print(tostring(result));
	if (string.upper(tostring(result))=="PASS") then
		return 1;
	else
		return 0;
	end
end

function CheckSN1(sn,ismlb,...)
    print(sn);
	--Demo,仅仅只确认SN长度
    if (ismlb==1) then
        if (#sn == 17 ) then
            local ict = TestContext:getContext("Query_ICT",2);  --check ict or not
            if (tonumber(ict)>0) then
            	local ret,msg = CheckICT(sn);
                if (ret>0) then	--pass
                	return 1;
                else
                	return ret,msg;
                end
            end
            return 1;
        else 
            return 0,"Invalid barcode length";
        end	
    else
        return 1,"adfadfsaf";
    end
end
--]]

local __require=require;
function require(name,forceload)
    if (forceload== nil) then
        forceload = true;
    end

    if(forceload) then
        package.loaded[name]=nil;
    end
	return __require(name);
end