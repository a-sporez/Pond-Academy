local World = {}
World.__index = World

function World:new()
    return setmetatable({entities = {}, system = {}}, self)
end

function World:addEntity(entity)
    table.insert(self.entities, entity)
    for _, system in ipairs(self.systems) do
        system:addEntity(entity)
    end
end

function World:removeEntity(entity)
    for _, system in ipairs(self.systems) do
        system:removeEntity(entity)
    end
end

function World:addSystem(system)
    table.insert(self.systems, system)
    for _, entity in ipairs(self.entities) do
        system:addEntity(entity)
    end
end

function World:update(dt)
    for _, system in ipairs(self.systems) do
        if system.update then
            system.update(dt)
        end
    end
end

function World:draw()
    for _, system in ipairs(self.systems) do
        if system.draw then
            system:draw()
        end
    end
end

return World