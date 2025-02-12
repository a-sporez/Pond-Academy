local Critter = {}
Critter.__index = Critter

--[[
    Creates a new Critter entity.
    @param name (string) - The name of the Critter.
    @param pos_x (number) - The X position of the Critter.
    @param pos_y (number) - The Y position of the Critter.
    @param file_path (string) - The file path to the Critter's sprite.
    @param dialogue_ID (string) - The ID of the Critter's dialogue tree.
    @return (table) - A new Critter instance.
--]]
function Critter:new(name, pos_x, pos_y, file_path, dialogue_ID)
    local instance = setmetatable({}, Critter)
    instance.name = name
    instance.pos_x = pos_x
    instance.pos_y = pos_y
    instance.dialogue_ID = dialogue_ID
    instance.sprite = love.graphics.newImage(file_path)  -- Load sprite from PNG
    return instance
end

function Critter:draw()
    love.graphics.draw(self.sprite, self.pos_x, self.pos_y)
end

function Critter:update(dt)
    -- Future behavior (e.g., idle animation, movement) can be added here.
end

function Critter:isInteracted(px, py)
    local distance = math.sqrt((px - self.pos_x)^2 + (py - self.pos_y)^2)
    return distance < 32 
end

function Critter:loadAll()
    return {
        Critter:new("Critter_1", 32 * 1, 32 * 1, "assets/sprites/critter_1.png", "critter_1"),
        Critter:new("Critter_2", 32 * 21, 32 * 1, "assets/sprites/critter_2.png", "critter_2"),
        Critter:new("Critter_3", 32 * 1, 32 * 17, "assets/sprites/critter_3.png", "critter_3"),
        Critter:new("Critter_4", 32 * 21, 32 * 17, "assets/sprites/critter_4.png", "critter_4")
    }
end

return Critter