

BaseNode = class("BaseNode" ) 
BaseNode.__index = BaseNode
BaseNode.parameters = {}
BaseNode.properties = {}
BaseNode.status = nil

function BaseNode:ctor()
end

function BaseNode:setObj(setting)
    self.name           = setting.name          or ""
    self.title          = setting.title         or self.name
    self.description    = setting.description   or ""
end

function BaseNode:drive()
    return self:onDrive()
end

function BaseNode:onDrive(tick)
    return Status.SUCCESS
end

return BaseNode