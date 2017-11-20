

Sequence = class("Sequence", Composite ) 
Sequence.category = Behavior_Category.composite
 
function Sequence:getName() 
    return "Sequence"
end

function Sequence:onDrive()
    if self.status ~= Status.RUNNING then
        self.idx = 1
    end

    while (self.idx <= #self.children) do
        local child = self.children[self.idx]
        local status = child:drive()
        if status == Status.RUNNING or status == Status.FAILURE then
            self.status = status
            return status
        end

        self.idx = self.idx + 1

    end

    return Status.SUCCESS
end   

return Sequence
