local System = {}
System.__index = System

function System:new(filter_func)
    return setmetatable({filter = filter_func, entities = {}}, self)
end

function System:addEntity(entity)
    if self.filter(entity) then
        table.insert(self.entities, entity)
    end
end

function System:removeEntity(entity)
    for itr, ent in ipairs(self.entities) do
        if ent == entity then
            table.remove(self.entities, itr)
            break
        end
    end
end

function System:update(dt)
end

function System:draw()
end

return System