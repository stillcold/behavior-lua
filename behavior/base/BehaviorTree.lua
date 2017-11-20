
Behavior_Category = {
    composite = "composite" ,   -- 
    decorator = "decorator" ,   -- 
    action    = "action" ,      -- 
    condition = "condition" ,   -- 
}

Status = {
    ERROR   = "ERROR",           -- 
    SUCCESS = "SUCCESS",        -- 
    FAILURE = "FAILURE",        --
    RUNNING = "RUNNING",        -- 
    
}

-- ---------------------
-- 各种基类
-- ---------------------
require("behavior.base.BaseNode")
require("behavior.base.Action")
require("behavior.base.Composite")
require("behavior.base.Condition")
require("behavior.base.Decorator")

-- ---------------------
-- 4类节点
-- ---------------------
require("behavior.composites.Sequence")

require("behavior.decorators.Repeater")

require("behavior.conditions.Checker")

require("behavior.actions.DoSay")

Behavior_composites = {
    Sequence    = Sequence,
}

Behavior_decorator = { 
    Repeater    = Repeater,
}

Behavior_conditions = {
    Checker         = Checker,
}

Behavior_actions = { 
    DoSay           = DoSay,
}

Behavior = class("Behavior" ) 
Behavior.__index = Behavior

function Behavior:ctor() 
    self.id             = 0
    self.title          = 'BT'
    self.description    = ''
    self.properties     = {}
    self.root           = nil 
end

-- 将文件中的json全部读出来
function Behavior:readFile(path)
    local file = io.open(path, "r")

    local jsonStr = file:read("*a")
    file:close()

    return jsonStr
end

-- 预处理 json 字符串
-- 用一个更容易读的懂的lua tbl(readableJsonObj) 来表示 json
function Behavior:jsonStr2readableObj(jsonStr)
    local readableJsonObj = {}
    readableJsonObj.map = {}
    readableJsonObj.rootNode = {}
    readableJsonObj.nodes = {}
    readableJsonObj.custom_nodes = {}

    readableJsonObj.map = json.decode( jsonStr )

    readableJsonObj.rootNode = readableJsonObj.map.root 
    readableJsonObj.nodes = readableJsonObj.map.nodes

    for i,v in ipairs(readableJsonObj.map.custom_nodes) do
        readableJsonObj.custom_nodes[ v.name ] = v
    end

    return readableJsonObj
end

-- 将预处理过的jsonObj转成BT
function Behavior:readableJsonObj2BT(readableJsonObj)

    local tree_nodes = {}

    -- 根据描述找到对应的类,将每一个节点实例化出来
    for k, v in pairs(readableJsonObj.nodes) do
        local spec = v
        local cls

        if      Behavior_composites[ spec.name ]  then
            cls = Behavior_composites[ spec.name ]
        elseif  Behavior_decorator[ spec.name ] then
            cls = Behavior_decorator[ spec.name ]
        elseif  Behavior_conditions[ spec.name ] then
            cls = Behavior_conditions[ spec.name ]
        elseif  Behavior_actions[ spec.name ] then
            cls = Behavior_actions[ spec.name ]
        else
            print('Invalid node name + "'.. spec.name .. '".')
        end

        if cls then
            local node = cls:new( spec )
            node:setObj( spec )
            node.id = spec.id or node.id
            node.title = spec.title or node.title
            node.description = spec.description or node.description
            node.properties = spec.properties or node.properties
            node.parameters = spec.parameters or node.parameters
            tree_nodes[ node.id ] = node
        end

    end

    -- 找到所有节点的子节点,建立节点之间的联系
    for id, v in pairs(readableJsonObj.nodes) do
        local spec = readableJsonObj.nodes[ id ] 
        local node = tree_nodes[ id ]

        -- 这类节点的子节点有可能不止一个
        if node.category == Behavior_Category.composite and spec.children then
            for i=1,#spec.children do
                node.children = node.children or {}
                local cid = spec.children[i]
                table.insert( node.children , tree_nodes[ cid ]) 
            end

        -- 这类节点的子节点只有一个
        elseif node.category == Behavior_Category.decorator and spec.child  then
            local cid = spec.child 
            node.child = tree_nodes[ cid ] 
        end

    end

    -- 将root的id作为这棵树的id
    self.id = tree_nodes[ readableJsonObj.rootNode ].id
    self.root = tree_nodes[ readableJsonObj.rootNode ]

end

function Behavior:loadRawJsonStrToBT(jsonStr)
    local readableJsonObj = self:jsonStr2readableObj(jsonStr)
    
    self:readableJsonObj2BT(readableJsonObj)
end

function Behavior:loadFileToBT(path)
    local jsonStr = self:readFile(path)

    self:loadRawJsonStrToBT(jsonStr)
end


function Behavior:drive()
    local state = self.root:drive()
    return state 
end

function Behavior:onTick()
    self:drive()
end


return Behavior
