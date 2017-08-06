--[[
ComposeTestKey:  Dynamically construct 'testkey', base on the GROUP-ID and TEST-ID and add to the subitem table.
GROUP ID is the key of the subitem group.
TEST ID is the 'tid' entry of the subitem.

Example:
local CDB={
{name="9636 Output 1.8v",tid="B0",lower=nil,upper=nil,unit="",entry=fct_SetFreqRef,parameter=1.8,sub=nil,visible=0},
{name="Audio init",tid="B1",lower="",upper="",unit="",entry=dut_SendCmd,parameter="audio --reset",sub=nil,visible=0},

GROUP ID = 'CDB'
TEST ID = 'B0' and 'B1'
--]]
function ComposeTestKey()

for k,item in pairs(items) do
-- print("k=%s\n", k);
if (type(item) == "table") then
name = item["name"];
sub = item["sub"];

if (name and sub and (type(sub) == "table")) then
for j,subitem in pairs(sub) do
subname = subitem["name"];
tid = subitem["tid"];
if (subname) then
-- print("subname=%s\n", subname);
end
if (tid) then
-- construct base on tid and parent's name
if (name) then
-- trim brackets
tmp = string.gsub(name, "^%[", "");
tmp = string.gsub(tmp, "%]$", "");

subitem["testkey"] = string.format("%s-%s", tmp, tid);

end
end
end

end
end
end
end

function pdcaname(it)
pdca_name = it.name;
if (it.testkey and it.name) then
pdca_name = it.testkey.." "..it.name;
end
if (it.activesku) then
pdca_name = pdca_name.."-"..it.activesku;
end
return pdca_name;
end


--[[
LoadSKULimit:  Add SKU specific limits into test items.
The default limits (item.lower and item.upper) is set to the sku table named 'default'.
--]]
function LoadSKULimit()

-- iterate through 'items'

for k,item in pairs(items) do

if (type(item) == "table") then
name = item["name"];
sub = item["sub"];

if (name and sub and (type(sub) == "table")) then

-- trim brackets
tmp = string.gsub(name, "^%[", "");
tmp = string.gsub(tmp, "%]$", "");
name = tmp;

for j,subitem in pairs(sub) do
testkey = subitem["testkey"];
tid = subitem["tid"];

-- add defaults

defaultlimit = {lower=subitem["lower"], upper=subitem["upper"]};
subitem["skulimit"] = {};
subitem["skulimit"]["default"] = defaultlimit;

-- check limit table for value of this 'name' - 'tid' ('testkey')

for lk,limitgroup in pairs(limits) do

limitgroupname = limitgroup["name"];

if ((limitgroupname == name) and limitgroup["sub"]) then

-- add sku specific

for lj,limitentry in pairs(limitgroup["sub"]) do
limittid = limitentry["tid"];

-- add the sku specific limit

if (limittid == tid) then
print("--> tid = "..tid);
for limitskukey,limitskuvalue in pairs(limitentry) do
print("--> limitskukey = "..limitskukey);

if (limitskukey ~= "tid") then
print("------> tid = "..tid.."  limitskukey = "..limitskukey);
subitem["skulimit"][limitskukey] = limitskuvalue;
end
end
end

end
end

end

end

end
end
end

end

function LoadSKULimitFile(limitfile)

local lim = dofile(limitfile);

if (type(lim) ~= "table") then
print("limit in file "..limitfile.." is not a table!");
return;
end

local limitsku = filenameWithoutExtension(basename(limitfile));
print("limitsku = "..limitsku.. " type = "..type(limitsku));

for k,item in pairs(items) do

if (type(item) == "table") then
name = item.name;
sub = item.sub;

if (name and sub and (type(sub) == "table")) then

-- trim brackets
tmp = string.gsub(name, "^%[", "");
tmp = string.gsub(tmp, "%]$", "");
name = tmp;

for j,subitem in pairs(sub) do
testkey = subitem.testkey;
if (testkey) then

tid = subitem.tid;

-- add defaults

if (subitem.skulimit == nil) then
defaultlimit = {lower=subitem["lower"], upper=subitem["upper"]};
subitem.skulimit = {};
subitem.skulimit.default = defaultlimit;
end

-- check limit table for value of this 'name' - 'tid' ('testkey')

for lk,limitentry in pairs(lim) do
if (type(limitentry) == "table") then

if (limitentry.testkey == testkey) then

print("found ".. testkey);

if (subitem.skulimit[limitsku] == nil) then
subitem.skulimit[limitsku] = {};
end

subitem.skulimit[limitsku].lower = limitentry.lower;
subitem.skulimit[limitsku].upper = limitentry.upper;

end
end
end
end
end
end
end
end
end


--[[
LoadWaiverList:  Set the 'waiver' flag dynamically on subitems base on a global waiver list.
--]]
function LoadWavierList()
for k,item in pairs(items) do

if (type(item) == "table") then
name = item["name"];
sub = item["sub"];

if (name and sub and (type(sub) == "table")) then

for j,subitem in pairs(sub) do
testkey = subitem["testkey"];
if (testkey) then
for _,w in pairs(waivers) do
if ( w == testkey ) then
subitem["waiver"] = true;
break;
end
end
end

end

end
end
end
end

function LoadSKUWaiverFile(waiverfile)

local wai = dofile(waiverfile);

if (type(wai) ~= "table") then
print("waiver in file "..waiverfile.." is not a table!");
return;
end

local waiversku = filenameWithoutExtension(basename(waiverfile));

for k,item in pairs(items) do

if (type(item) == "table") then
name = item.name;
sub = item.sub;

if (name and sub and (type(sub) == "table")) then

-- trim brackets
tmp = string.gsub(name, "^%[", "");
tmp = string.gsub(tmp, "%]$", "");
name = tmp;

for j,subitem in pairs(sub) do
testkey = subitem.testkey;
if (testkey) then

tid = subitem.tid;

-- add defaults

if (subitem.skuwaiver == nil) then
subitem.skuwaiver = {};
subitem.skuwaiver.default = false;
end

-- check limit table for value of this 'name' - 'tid' ('testkey')

for lk,waiverentry in pairs(wai) do
if (lk ~= "sku") then
if (waiverentry == testkey) then
subitem.skuwaiver[waiversku] = true;
end
end
end

end
end
end
end
end
end



function PrintItems()

for k,item in pairs(items) do
print("k=%s item=%s", k, tostring(item));

if (type(item) == "table") then
name = item["name"];
sub = item["sub"];
print("name=%s", name);
print("have sub");

if (name and sub and (type(sub) == "table")) then
for j,subitem in pairs(sub) do

print("  subitem = %s", tostring(subitem));

for sk,sv in pairs(subitem) do
print("    %s=%s", tostring(sk), tostring(sv));
end

needline = false;

testkey= subitem["testkey"];
if (testkey) then
print("testkey=%s ", testkey);
needline = true;
end

skulimit= subitem["skulimit"];
if (skulimit and type(skulimit) == "table") then
print("skulimit=\n");
for llk,llv in pairs(skulimit) do
print("    %s=%s\n", tostring(llk), tostring(llv));
end
needline = true;
end

waiver= subitem["waiver"];
--					if (waiver) then
--						print("waiver=%s ", tostring(waiver));
--						needline = true;
--					end

if (needline) then
io.write("\n");
end

end

end
end
end

end

function tprint (tbl, indent)
if not indent then indent = 0 end
for k, v in pairs(tbl) do
formatting = string.rep("  ", indent) .. k .. ": "
if type(v) == "table" then
print(formatting)
tprint(v, indent+1)
else
print(formatting .. tostring(v))
end
end
end

function basename(filename)
parts = split(filename, "/");
return parts[#parts];
end
function split(s, delimiter)
result = {};
for match in (s..delimiter):gmatch("(.-)"..delimiter) do
table.insert(result, match);
end
return result;
end

function filenameWithoutExtension(filename)
len = string.len(filename);
dot = string.len(filename);
for i = len,1,-1 do
-- print(string.byte(filename,i));

-- directory slash.  we didn't find an extension.
if (string.byte(filename,i) == 47) then
break;
end

-- found it!
if (string.byte(filename,i) == 46) then
dot = i;
break;
end
end

if (dot ~= len) then
return string.sub(filename,1,dot - 1);
end

return filename;
end

