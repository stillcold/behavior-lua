
Action = class("Action", BaseNode )  
Action.category = Behavior_Category.action
function Action:ctor(   )  
    report_dt('Action:ctor'   )
end

function Action:onDrive() 
    return Status.SUCCESS
end


return Action 