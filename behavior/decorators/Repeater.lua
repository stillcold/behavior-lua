
Repeater = class( "Repeater" , Decorator )
function Repeater:ctor( ... )
    self.repeatTimes = 0
end

function Repeater:onDrive()
    if not self.child then
        return Status.ERROR
    end

    while (self.repeatTimes < self.properties.maxLoop) do
        local status = self.child:drive()
        if status == Status.RUNNING then
            return Status.RUNNING
        end

        self.repeatTimes = 1 + (self.repeatTimes or 0)
    end

    self.repeatTimes = 0

    return Status.SUCCESS
end 