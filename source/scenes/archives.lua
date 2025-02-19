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
    
    -- Load the map using STI
    instance.map = sti(MAP_PATH)

    -- 🔹 Get tile size dynamically from map metadata
    instance.tile_size = instance.map.tilewidth  -- Assuming square tiles (tilewidth == tileheight)

    -- Initialize entities
    instance.critters = Critter:loadAll()
    instance.walls = {}  -- Store wall collision tiles
    instance.bunny = Bunny:new(instance.tile_size * 1, instance.tile_size * 4)
    instance.dialogue = nil  -- No dialogue at start
    instance.inDialogue = false  -- Dialogue state tracker

    -- Debug: Print Critter loading
    for _, critter in ipairs(instance.critters) do
        print("[DEBUG-archives] Loaded Critter:", critter.name, "at", critter.x, critter.y)
    end

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
                    table.insert(self.walls, { 
                        x = x * self.tile_size,
                        y = y * self.tile_size,
                        width = self.tile_size,
                        height = self.tile_size
                    })
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
    local tile_x = math.floor(x / self.tile_size)
    local tile_y = math.floor(y / self.tile_size)

    -- Debug: Print the tile coordinates Bunny is trying to move to
    print("[DEBUG-archives] Checking collision at tile:", tile_x, tile_y)

    -- Stay within map bounds
    if tile_x < 0 or tile_x >= self.map.width or tile_y < 0 or tile_y >= self.map.height then
        print("[DEBUG-archives] Out of bounds! Treating as collision.")
        return true
    end

    -- Get tile value at this position
    local tile_id = self.map.layers["wall"].data[tile_y + 1] and self.map.layers["wall"].data[tile_y + 1][tile_x + 1] or nil

    -- Debug: Print the tile ID Bunny is trying to step on
    if tile_id then
        print("[DEBUG-archives] Tile ID at collision point:", tile_id)
    else
        print("[DEBUG-archives] No tile data found at this position.")
    end

    -- If tile is not empty (not 0), it means it's a wall
    if tile_id and tile_id ~= 0 then
        print("[DEBUG-archives] Collision detected at tile:", tile_x, tile_y, "Tile ID:", tile_id)
        return true
    end

    return false
end

--[[ 
    Updates the scene.
    @param dt (number) - Delta time since last frame.
--]]
function Archives:update(dt)
    if self.inDialogue then
        if self.dialogue and self.dialogue.update then
            self.dialogue:update(dt)
        else
            print("[ERROR-archives] Dialogue object is nil or missing update()!")
            self.inDialogue = false
        end
    else
        self.bunny:update(dt)
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
    if self.inDialogue then return end

    for _, critter in ipairs(self.critters) do
        if critter:isInteracted(self.bunny.pos_x, self.bunny.pos_y) then
            local new_dialogue = Dialogue:new(critter.dialogue_ID)  -- ✅ Ensure dialogue_ID is used

            if new_dialogue then
                self.dialogue = new_dialogue
                self.inDialogue = true
                print("[DEBUG-archives] Started dialogue with:", critter.dialogue_ID)
            else
                print("[ERROR-archives] Failed to start dialogue for:", critter.dialogue_ID)
            end
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
        
        -- Close dialogue if return is pressed
        if key == "return" then
            print("[DEBUG-archives] Closing dialogue with Return key")
            self.inDialogue = false
            self.dialogue = nil
        end
    else
        self.bunny:keypressed(key, self)
    end
end

function Archives:mousepressed(x, y, button)
    if self.inDialogue and self.dialogue then
        self.dialogue:mousepressed(x, y, button)

        -- If dialogue was closed, set inDialogue to false
        if not self.dialogue.current_node then
            self.inDialogue = false
            self.dialogue = nil
        end
    end
end

return Archives
