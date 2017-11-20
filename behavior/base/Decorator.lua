
Decorator = class("Decorator", BaseNode )  
Decorator.category = Behavior_Category.decorator

function Decorator:ctor()
    self.child = settings.child or nil
end

function Decorator:onDrive() 
    return Status.SUCCESS
end

return Decorator