local Archives = {}
Archives.__index = Archives

-- Dependencies
local sti = require('libraries.sti')
local Archivists = require('source.entities.archivists')
local Bunny = require('source.entities.bunny')
local Dialogue = require('source.dialogues.dialogue')

local MAP_PATH = "assets/scenes/archives_map.lua"

-- Initializes the Archives scene.
function Archives:new(spawn_from)
    local instance = setmetatable({}, Archives)

    instance.map = sti(MAP_PATH)
    instance.library_unlocked = false
    instance.sanctum_unlocked = false
    instance.labyrinth_unlocked = false
    instance.atrium_unlocked = false
    -- For displaying locked transition message
    instance.lock_message_timer = 0
    instance.lock_message_text = ""
    instance.tile_size = instance.map.tilewidth
    instance.to_library = {
        x = instance.tile_size * 1,
        y = instance.tile_size * 1,
        width = instance.tile_size,
        height = instance.tile_size
    }
    instance.to_sanctum = {
        x = instance.tile_size * 1,
        y = instance.tile_size * 16,
        width = instance.tile_size,
        height = instance.tile_size
    }
    instance.to_labyrinth = {
        x = instance.tile_size * 22,
        y = instance.tile_size * 1,
        width = instance.tile_size,
        height = instance.tile_size
    }
    instance.to_atrium = {
        x = instance.tile_size * 22,
        y = instance.tile_size * 16,
        width = instance.tile_size,
        height = instance.tile_size
    }

    local bunny_x, bunny_y = instance.tile_size * 1, instance.tile_size * 4
    if spawn_from == 'library' then
        bunny_x = instance.to_library.x
        bunny_y = instance.to_library.y + instance.tile_size
    end

    instance.archivists = Archivists:loadAll()
    instance.collidables = {}
    instance.bunny = Bunny:new(bunny_x, bunny_y)
    instance.dialogue = nil
    instance.inDialogue = false

    for _, critter in ipairs(instance.archivists) do
        print("[DEBUG-archives] Loaded Critter:", critter.name, "at", critter.x, critter.y)
    end

    instance:loadCollisionData()
    return instance
end

-- Loads wall collision data from the Tiled map.
function Archives:loadCollisionData()
    local layers = {'collidable', 'water'}
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

-- Checks wall and archivist collision at a given position.
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

    for _, entity in ipairs(self.archivists) do
        if entity.collidable and
           math.floor(entity.pos_x / self.tile_size) == tile_x and
           math.floor(entity.pos_y / self.tile_size) == tile_y then
            return true
        end
    end

    return false
end

-- Checks if Bunny is standing on any of the scene switch tiles.
function Archives:checkForSceneSwitch()
    if self.bunny.pos_x == self.to_library.x and self.bunny.pos_y == self.to_library.y then
        if self.library_unlocked then
            return 'library'
        else
            print("[DEBUG] Library access locked.")
            self.lock_message_text = "Library is locked."
            self.lock_message_timer = 2
        end
    elseif self.bunny.pos_x == self.to_sanctum.x and self.bunny.pos_y == self.to_sanctum.y then
        if self.sanctum_unlocked then
            return 'sanctum'
        else
            print("[DEBUG] Sanctum access locked.")
            self.lock_message_text = "Sanctum is locked."
            self.lock_message_timer = 2
        end
    elseif self.bunny.pos_x == self.to_labyrinth.x and self.bunny.pos_y == self.to_labyrinth.y then
        if self.labyrinth_unlocked then
            return 'labyrinth'
        else
            print("[DEBUG] Labyrinth access locked.")
            self.lock_message_text = "Labyrinth is locked."
            self.lock_message_timer = 2
        end
    elseif self.bunny.pos_x == self.to_atrium.x and self.bunny.pos_y == self.to_atrium.y then
        if self.atrium_unlocked then
            return 'atrium'
        else
            print("[DEBUG] Atrium access locked.")
            self.lock_message_text = "Atrium is locked."
            self.lock_message_timer = 2
        end
    end

    return nil
end

-- Updates game state logic, including archivists and dialogue state.
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
    -- Update lock message timer
    if self.lock_message_timer > 0 then
        self.lock_message_timer = self.lock_message_timer - dt
        if self.lock_message_timer <= 0 then
            self.lock_message_text = ""
        end
    end
end

-- Draws map, bunny, archivists, debug indicators, and dialogue overlay.
function Archives:draw()
    local window_width = love.graphics.getWidth()
    local window_height = love.graphics.getHeight()

    self.map:draw()
    self.bunny:draw()
    for _, critter in ipairs(self.archivists) do
        critter:draw()
    end

    -- Draw debug indicators for locked/unlocked scene exits
    love.graphics.setColor(self.library_unlocked and {0,1,0,0.6} or {1,0,0,0.6})
    love.graphics.circle('line', self.to_library.x + self.tile_size/2, self.to_library.y + self.tile_size/2, self.tile_size/3)
    love.graphics.setColor(self.sanctum_unlocked and {0,1,0,0.6} or {1,0,0,0.6})
    love.graphics.circle('line', self.to_sanctum.x + self.tile_size/2, self.to_sanctum.y + self.tile_size/2, self.tile_size/3)
    love.graphics.setColor(self.labyrinth_unlocked and {0,1,0,0.6} or {1,0,0,0.6})
    love.graphics.circle('line', self.to_labyrinth.x + self.tile_size/2, self.to_labyrinth.y + self.tile_size/2, self.tile_size/3)
    love.graphics.setColor(self.atrium_unlocked and {0,1,0,0.6} or {1,0,0,0.6})
    love.graphics.circle('line', self.to_atrium.x + self.tile_size/2, self.to_atrium.y + self.tile_size/2, self.tile_size/3)
    love.graphics.setColor(1,1,1,1)
    -- draw locked warning
    if self.lock_message_timer > 0 and self.lock_message_text ~= "" then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.printf(self.lock_message_text, 0, window_height / 2 - 20, window_width, "center")
        love.graphics.setColor(1, 1, 1, 1)
    end

    if self.inDialogue and self.dialogue then
        self.dialogue:draw()
    end
end

-- Handles Bunny interaction with archivists and triggers dialogue or scene changes.
function Archives:interact()
    if self.inDialogue then return end

    for _, critter in ipairs(self.archivists) do
        if critter:isInteracted(self.bunny.pos_x, self.bunny.pos_y) then
            local conditions = {
                node_COND1 = function()
                    if critter.dialogue_ID == "smug" then
                        print("[DEBUG] Unlocking Library")
                        self.library_unlocked = true
                    elseif critter.dialogue_ID == "bambi" then
                        print("[DEBUG] Unlocking Sanctum")
                        self.sanctum_unlocked = true
                    elseif critter.dialogue_ID == "olive" then
                        print("[DEBUG] Unlocking Labyrinth")
                        self.labyrinth_unlocked = true
                    elseif critter.dialogue_ID == "wiz" then
                        print("[DEBUG] Unlocking Atrium")
                        self.atrium_unlocked = true
                    end
                end
            }

            local new_dialogue = Dialogue:new(critter.dialogue_ID, conditions)

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

-- Handles key input events during dialogue or exploration.
function Archives:keypressed(key)
    if self.inDialogue and self.dialogue then
        self.dialogue:keypressed(key)

        if key == 'escape' then
            print("[DEBUG-archives] Closing dialogue with escape key")
            self.inDialogue = false
            self.dialogue = nil
        end
    else
        self.bunny:keypressed(key, self)
    end
end

-- Handles mouse input during dialogue interactions.
function Archives:mousepressed(x, y, button)
    if self.inDialogue and self.dialogue then
        self.dialogue:mousepressed(x, y, button)

        if not self.dialogue.current_node then
            self.inDialogue = false
            self.dialogue = nil
        end
    end
end

return Archives