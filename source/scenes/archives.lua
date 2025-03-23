local Archives = {}
Archives.__index = Archives

-- Dependencies
local sti = require('libraries.sti')  -- Simple Tiled Implementation for loading maps
local Archivists = require('source.entities.archivists')  -- Critter entity management
local Bunny = require('source.entities.bunny')  -- Player (bunny) entity management
local Dialogue = require('source.dialogues.dialogue')  -- Dialogue system

-- Path to the Tiled map file
local MAP_PATH = "assets/scenes/archives_map.lua"

--[[ 
    Initializes the Archives scene.
    @return (table) - A new Archives scene instance.
--]]
function Archives:new(spawn_from)
    local instance = setmetatable({}, Archives)
    
    -- Load the map using STI
    instance.map = sti(MAP_PATH)

    -- Get tile size dynamically from map metadata
    instance.tile_size = instance.map.tilewidth  -- Assuming square tiles (tilewidth == tileheight)
    instance.to_library = {
        x = instance.tile_size * 1,
        y = instance.tile_size * 1,
        width = instance.tile_size,
        height = instance.tile_size
    }

    -- store default spawn location
    local bunny_x, bunny_y = instance.tile_size * 1, instance.tile_size * 4
    -- spawn_from is passed along in parameters
    if spawn_from == 'library' then
        bunny_x = instance.to_library.x
        bunny_y = instance.to_library.y + instance.tile_size  -- Spawn above transition tile
    end

    -- Initialize entities
    instance.archivists = Archivists:loadAll()
    instance.collidables = {}  -- Store wall collision tiles
    instance.bunny = Bunny:new(bunny_x, bunny_y)
    instance.dialogue = nil  -- No dialogue at start
    instance.inDialogue = false  -- Dialogue state tracker

    -- Debug: Print Critter loading
    for _, critter in ipairs(instance.archivists) do
        print("[DEBUG-archives] Loaded Critter:", critter.name, "at", critter.x, critter.y)
    end

    instance:loadCollisionData()  -- Load collidables
    return instance
end

--[[ 
    Loads wall collision data from the Tiled map.
--]]
function Archives:loadCollisionData()
    local layers = {'collidable', 'water'} -- Water should also be treated as collidable
    for _, layer_name in ipairs(layers) do
        if self.map.layers[layer_name] and self.map.layers[layer_name].data then
            for y = 1, #self.map.layers[layer_name].data do
                for x = 1, #self.map.layers[layer_name].data[y] do
                    if self.map.layers[layer_name].data[y][x] ~= 0 then
                        table.insert(self.collidables, { 
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
end

function Archives:isCollidingWithWall(x, y)
    local tile_x = math.floor(x / self.tile_size)
    local tile_y = math.floor(y / self.tile_size)

    if tile_x < 0 or tile_x >= self.map.width or tile_y < 0 or tile_y >= self.map.height then
        return true
    end

    for _, layer_name in ipairs({'collidable', 'water'}) do
        local tile_id = self.map.layers[layer_name].data[tile_y + 1]
                        and self.map.layers[layer_name].data[tile_y + 1][tile_x + 1] or nil
        if tile_id and tile_id ~= 0 then
            return true
        end
    end

    -- Check collision with collidable archivists
    for _, entity in ipairs(self.archivists) do
        if entity.collidable and
           math.floor(entity.pos_x / self.tile_size) == tile_x and
           math.floor(entity.pos_y / self.tile_size) == tile_y then
            return true
        end
    end

    return false
end

function Archives:checkForSceneSwitch()
    if self.bunny.pos_x == self.to_library.x and self.bunny.pos_y == self.to_library.y then
        return 'library'
    end
    return nil
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
        for _, critter in ipairs(self.archivists) do
            critter:update(dt)
        end
    end
end

--[[ 
    Draws the scene, Bunny, and archivists. Also draws dialogue if active.
--]]
function Archives:draw()
    self.map:draw()
    self.bunny:draw()
    for _, critter in ipairs(self.archivists) do
        critter:draw()
    end

    if self.inDialogue and self.dialogue then
        self.dialogue:draw()
    end
end

--[[ 
    Handles Bunny interaction with archivists.
    Starts dialogue if a Critter is interacted with.
--]]
function Archives:interact()
    if self.inDialogue then return end

    for _, critter in ipairs(self.archivists) do
        if critter:isInteracted(self.bunny.pos_x, self.bunny.pos_y) then
            local new_dialogue = Dialogue:new(critter.dialogue_ID)  -- Ensure dialogue_ID is used

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
        if key == 'escape' then
            print("[DEBUG-archives] Closing dialogue with escape key")
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
