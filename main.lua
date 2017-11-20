
require("class")
if not json then
    json = require "json"
end

function __G__TRACKBACK_DEFAULT(msg)
    print("__G__TRACKBACK_DEFAULT: " .. tostring(msg) .. "\n")
    print(debug.traceback())
end

require("behavior.base.BehaviorTree")

local function load_run_bt(  )
    local bt = Behavior:new()
    bt:loadFileToBT( "yonge.json" )

    local driveTimes = 1
    for i=1,driveTimes do
        local s = bt:onTick()  
    end
end

local function main() 
    load_run_bt()  
end 

xpcall(main, __G__TRACKBACK_DEFAULT)
