local modname=...;
local M={};
_G[modname]=M;
package.loaded[modname]=M;

function M.fun()
    print("hello world");
end

