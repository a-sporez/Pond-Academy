
local Critter = {}
Critter.__index = Critter

--[[
    Metatable to create entities sub-classes with common variables.
    @param pos_x (number) - Initial X position (in pixels).
    @param pos_y (number) - Initial Y position (in pixels).
    @param sprite_path (string)
    @param dialogue_ID (string)
    @return (table) - A new critter subclass instance
--]]

function Critter:new(name, pos_x, pos_y, sprite_path, dialogue_ID)
    local instance = setmetatable({}, Critter)
    instance.name = name
    instance.pos_x = pos_x
    instance.pos_y = pos_y
    instance.dialogue_ID = dialogue_ID

    -- Load and store sprite
    instance.sprite = love.graphics.newImage(sprite_path)
    instance.width = instance.sprite:getWidth()
    instance.height = instance.sprite:getHeight()

    -- Scale factor for proper display
    instance.scale_x = 32 / instance.width
    instance.scale_y = 32 / instance.height

    return instance
end

function Critter:draw()
    love.graphics.setColor(1, 1, 1) -- reset colour
    love.graphics.draw(self.sprite, self.pos_x, self.pos_y)
end

return Critter