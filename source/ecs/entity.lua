local Entity = {}
Entity.__index = Entity

-- creates a new entity with an empty table and a unique id
function Entity:new()
    return setmetatable({
        components= {},
        id = tostring(math.random())..tostring(os.clock())
    })
end

function Entity:addComponent(name, component)
    self.components[name] = component
end

function Entity:getComponent(name)
    return self.components[name]
end

function Entity:hasComponent(name)
    return self.components[name] ~= nil
end

return Entity