local Component = {}
Component.__index = Component

--[[
    Components are just data containers (like position, velocity, health)
    new(data) takes a table of data field, wraps it with a metatable
    and returns it as an instance of a component.
]]
function Component:new(data)
    return setmetatable(data or {}, self)
end

return Component