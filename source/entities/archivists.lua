local Archivists = {}
Archivists.__index = Archivists

-- Set a fixed tile size (assuming tiles are 32x32)
local TILE_SIZE = 32

--[[ 
    Creates a new Archivist entity.
    @param name (string) - The name of the Archivist.
    @param tile_x (number) - X position in **tiles**.
    @param tile_y (number) - Y position in **tiles**.
    @param sprite_path (string) - Path to the Archivist's sprite.
    @param dialogue_ID (string) - The ID of the Archivist's dialogue tree.
    @return (table) - A new Archivist instance.
--]]
function Archivists:new(name, tile_x, tile_y, sprite_path, dialogue_ID)
    local instance = setmetatable({}, Archivists)
    instance.name = name

    -- Store position in tiles
    instance.tile_x = tile_x
    instance.tile_y = tile_y

    -- Convert tile position to pixel position
    instance.pos_x = tile_x * TILE_SIZE
    instance.pos_y = tile_y * TILE_SIZE

    -- Store dialogue reference
    instance.dialogue_ID = dialogue_ID

    -- Load sprite (no scaling needed)
    instance.sprite = love.graphics.newImage(sprite_path)

    return instance
end

--[[ 
    Draws the Archivist at its **tile-based** position.
--]]
function Archivists:draw()
    love.graphics.setColor(1, 1, 1) -- Reset color to default
    love.graphics.draw(self.sprite, self.pos_x, self.pos_y)
end

--[[ 
    Updates the Archivist (placeholder for future behavior).
    @param dt (number) - Delta time.
--]]
function Archivists:update(dt)
    -- Placeholder for AI or animation logic
end

--[[ 
    Checks if Bunny is in an **adjacent tile** (not just same tile).
    @param px (number) - Bunny's X **pixel** position.
    @param py (number) - Bunny's Y **pixel** position.
    @return (boolean) - True if Bunny is in any of the 8 surrounding tiles.
--]]
function Archivists:isInteracted(px, py)
    -- Convert Bunny's pixel position to tile coordinates
    local bunny_tile_x = math.floor(px / TILE_SIZE)
    local bunny_tile_y = math.floor(py / TILE_SIZE)

    -- Calculate tile distance
    local dx = math.abs(bunny_tile_x - self.tile_x)
    local dy = math.abs(bunny_tile_y - self.tile_y)

    -- Return true if Bunny is **in the same tile or any of the 8 surrounding tiles**
    return dx <= 1 and dy <= 1
end

--[[ 
    Loads all Archivists using **tile-based** positions.
    @return (table) - List of Archivist entities.
--]]
function Archivists:loadAll()
    return {
        Archivists:new("smug", 2, 1, "assets/sprites/smug.png", "smug"),
        Archivists:new("olive", 21, 1, "assets/sprites/olive.png", "olive"),
        Archivists:new("bambi", 2, 16, "assets/sprites/bambi.png", "bambi"),
        Archivists:new("wiz", 21, 16, "assets/sprites/wiz.png", "wiz")
    }
end

return Archivists
