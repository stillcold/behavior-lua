
Condition = class("Condition", BaseNode )  
Condition.category = Behavior_Category.condition
function Condition:ctor()
    BaseNode.ctor(self)
end

function Condition:onDrive()
    return Status.SUCCESS
end

return Condition 