local Archivists = {}
Archivists.__index = Archivists

--[[ 
    Creates a new Archivist entity.
    @param name (string) - The name of the Archivist.
    @param pos_x (number) - X position in pixels.
    @param pos_y (number) - Y position in pixels.
    @param sprite_path (string) - Path to the Archivist's sprite.
    @param dialogue_ID (string) - The ID of the Archivist's dialogue tree.
    @return (table) - A new Archivist instance.
--]]
function Archivists:new(name, pos_x, pos_y, sprite_path, dialogue_ID)
    local instance = setmetatable({}, Archivists)
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

--[[ 
    Draws the Archivist at its position.
--]]
function Archivists:draw()
    love.graphics.setColor(1, 1, 1) -- Reset color to default
    love.graphics.draw(self.sprite, self.pos_x, self.pos_y, 0, self.scale_x, self.scale_y)
end

--[[ 
    Updates the Archivist (placeholder for future AI behavior).
    @param dt (number) - Delta time.
--]]
function Archivists:update(dt)
    -- Placeholder for future logic.
end

--[[ 
    Checks if Bunny is interacting with an Archivist.
    @param px (number) - Bunny's X position.
    @param py (number) - Bunny's Y position.
    @return (boolean) - True if within interaction range.
--]]
function Archivists:isInteracted(px, py)
    local distance = math.sqrt((px - self.pos_x)^2 + (py - self.pos_y)^2)
    return distance < 32  -- Interaction within 1 tile
end

--[[ 
    Loads and returns all Archivists at fixed positions.
--]]
function Archivists:loadAll()
    return {
        Archivists:new("smug", 32, 32, "assets/sprites/smug.png", "smug"),
        Archivists:new("olive", 704, 32, "assets/sprites/olive.png", "olive"),
        Archivists:new("bambi", 32, 512, "assets/sprites/bambi.png", "bambi"),
        Archivists:new("wiz", 704, 512, "assets/sprites/wiz.png", "wiz")
    }
end

return Archivists
