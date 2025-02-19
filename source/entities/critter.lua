local Critter = {}
Critter.__index = Critter

--[[
    Creates a new Critter entity.
    @param name (string) - The name of the Critter.
    @param tile_x (number) - The X tile position of the Critter.
    @param tile_y (number) - The Y tile position of the Critter.
    @param file_path (string) - The file path to the Critter's sprite.
    @param dialogue_ID (string) - The ID of the Critter's dialogue tree.
    @return (table) - A new Critter instance.
--]]
function Critter:new(name, tile_x, tile_y, file_path, dialogue_ID)
    local instance = setmetatable({}, Critter)
    instance.name = name
    instance.x = tile_x * 32  -- Convert tile position to pixel position
    instance.y = tile_y * 32  -- Convert tile position to pixel position
    instance.dialogue_ID = dialogue_ID

    -- Load and store sprite
    instance.sprite = love.graphics.newImage(file_path)
    instance.width = instance.sprite:getWidth()
    instance.height = instance.sprite:getHeight()

    -- Scale factor for better visuals (modify if needed)
    instance.scale_x = 32 / instance.width
    instance.scale_y = 32 / instance.height

    return instance
end

--[[
    Draws the Critter at its location.
--]]
function Critter:draw()
--    print("[DEGUG] Drawing critter", self.name, " @ ", self.x, self.y)
    love.graphics.setColor(1, 1, 1) -- Reset to white in case of any tinting
    love.graphics.draw(self.sprite, self.x, self.y, 0, self.scale_x, self.scale_y)
end

--[[
    Updates the Critter (for potential animations in future).
    @param dt (number) - Delta time.
--]]
function Critter:update(dt)
    -- Placeholder for future AI behavior or animations.
end

--[[
    Checks if Bunny is interacting with the Critter.
    @param px (number) - Bunny X position.
    @param py (number) - Bunny Y position.
    @return (boolean) - True if close enough to interact.
--]]
function Critter:isInteracted(px, py)
    local distance = math.sqrt((px - self.x)^2 + (py - self.y)^2)
    return distance < 32  -- Interaction within 1 tile
end

--[[
    Loads and returns all Critters at fixed positions.
--]]
function Critter:loadAll()
    return {
        Critter:new("smug", 1, 1, "assets/sprites/smug.png", "smug"),
        Critter:new("olive", 22, 1, "assets/sprites/olive.png", "olive"),
        Critter:new("bambi", 1, 16, "assets/sprites/bambi.png", "bambi"),
        Critter:new("wiz", 22, 16, "assets/sprites/wiz.png", "wiz")
    }
end

return Critter
