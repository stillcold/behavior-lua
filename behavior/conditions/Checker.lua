
Checker = class("Checker", Condition )  
Checker.category = Behavior_Category.condition 

function Checker:onDrive()  
    for k,v in pairs(self.properties) do
        if self.properties.cond then
            return Status.SUCCESS
        end
    end
    return Status.FAILURE
end

return Checker
