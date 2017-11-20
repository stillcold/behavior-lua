
Composite = class("Composite", BaseNode ) 
Composite.category = Behavior_Category.composite

function Composite:ctor()
end

function Composite:setObj(setting)
    self.name  			= setting.name  or ""
    self.title 			= setting.title or self.name   
    self.description 	= setting.description or ""
    self.properties 	= setting.properties or nil
end

function Composite:onDrive()
    return Status.SUCCESS
end

return Composite
