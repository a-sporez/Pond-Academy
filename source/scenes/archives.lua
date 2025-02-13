local Archives = {}
Archives.__index = Archives

-- Dependencies
local sti = require('libraries.sti')  -- Simple Tiled Implementation for loading maps
local Critter = require('source.entities.critter')  -- Critter entity management
local Bunny = require('source.entities.bunny')  -- Player (bunny) entity management
local Dialogue = require('source.dialogues.dialogue')  -- Dialogue system

-- Path to the Tiled map file
local MAP_PATH = "assets/scenes/archives_map.lua"

--[[
    Initializes the Archives scene.
    @return (table) - A new Archives scene instance.
--]]
function Archives:new()
    local instance = setmetatable({}, Archives)
    
    -- Load the map using STI (only floor & walls)
    instance.map = sti(MAP_PATH)
    
    instance.critters = {}  -- Store Critter entities
    instance.walls = {}  -- Store wall collision tiles
    instance.bunny = Bunny:new(32, 32)  -- Move Bunny to the second tile (1-based index, Lua problems
    instance.dialogue = nil  -- No dialogue at start
    instance.inDialogue = false  -- Dialogue state tracker

    instance:loadCollisionData()  -- Load walls
    return instance
end

--[[
    Loads wall collision data from the Tiled map.
--]]
function Archives:loadCollisionData()
    if self.map.layers["wall"] and self.map.layers["wall"].data then
        for y = 1, #self.map.layers["wall"].data do
            for x = 1, #self.map.layers["wall"].data[y] do
                if self.map.layers["wall"].data[y][x] ~= 0 then
                    table.insert(self.walls, { x = x * 32, y = y * 32, width = 32, height = 32 })
                end
            end
        end
    end
end

--[[
    Checks if Bunny is colliding with a wall.
    @param x (number) - X position to check.
    @param y (number) - Y position to check.
    @return (boolean) - True if colliding, false otherwise.
--]]
function Archives:isCollidingWithWall(x, y)
    -- Convert pixel position to tile index
    local tile_x = math.floor(x / 32)
    local tile_y = math.floor(y / 32)

    -- Debug: Print the tile coordinates Bunny is trying to move to
    print("[DEBUG] Checking collision at tile:", tile_x, tile_y)

    -- Stay within map bounds
    if tile_x < 0 or tile_x >= self.map.width or tile_y < 0 or tile_y >= self.map.height then
        print("[DEBUG] Out of bounds! Treating as collision.")
        return true
    end

    -- Get tile value at this position
    local tile_id = self.map.layers["wall"].data[tile_y + 1] and self.map.layers["wall"].data[tile_y + 1][tile_x + 1] or nil

    -- Debug: Print the tile ID Bunny is trying to step on
    if tile_id then
        print("[DEBUG] Tile ID at collision point:", tile_id)
    else
        print("[DEBUG] No tile data found at this position.")
    end

    -- If tile is not empty (not 0), it means it's a wall
    if tile_id and tile_id ~= 0 then
        print("[DEBUG] Collision detected at tile:", tile_x, tile_y, "Tile ID:", tile_id)
        return true
    end

    return false
end

--[[
    Updates the scene.
    @param dt (number) - Delta time since last frame.
--]]
function Archives:update(dt)
    if self.inDialogue and self.dialogue then
        self.dialogue:update(dt)  -- Update dialogue instead of game world
    else
        self.bunny:update(dt)  -- Update Bunny movement
        for _, critter in ipairs(self.critters) do
            critter:update(dt)
        end
    end
end

--[[
    Draws the scene, Bunny, and Critters. Also draws dialogue if active.
--]]
function Archives:draw()
    self.map:draw()
    self.bunny:draw()
    for _, critter in ipairs(self.critters) do
        critter:draw()
    end
    
    if self.inDialogue and self.dialogue then
        self.dialogue:draw()
    end
end

--[[
    Handles Bunny interaction with Critters.
    Starts dialogue if a Critter is interacted with.
--]]
function Archives:interact()
    if self.inDialogue then return end  -- Ignore input during dialogue
    
    for _, critter in ipairs(self.critters) do
        if critter:isInteracted(self.bunny.x, self.bunny.y) then
            self.dialogue = Dialogue:new(critter.dialogue_ID)  -- Start dialogue
            self.inDialogue = true
            return
        end
    end
end

--[[
    Handles key input.
    @param key (string) - The key pressed.
--]]
function Archives:keypressed(key)
    if self.inDialogue and self.dialogue then
        self.dialogue:keypressed(key)
        
        -- Example: End dialogue when pressing return
        if key == "return" then
            self.inDialogue = false
            self.dialogue = nil
        end
    else
        self.bunny:keypressed(key, self)
    end
end

return Archives