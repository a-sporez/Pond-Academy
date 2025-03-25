-- Dependencies
local BaseScene = require 'source.scenes.BaseScene'
local Archivists = require 'source.entities.archivists'
local Dialogue = require 'source.dialogues.dialogue'

local Archives = setmetatable({}, { __index = BaseScene })
Archives.__index = Archives

local MAP_PATH = "assets/scenes/archives_map.lua"

-- Initializes the Archives scene.
function Archives:new(spawn_from)
    local spawn_positions = {
        default = {x = 1 * 32, y = 4 * 32},
        library = {x = 1 * 32, y = 2 * 32},
    }

    local instance = BaseScene.new(self, MAP_PATH, spawn_from, spawn_positions)
    setmetatable(instance, Archives)

    instance.library_unlocked   = false
    instance.sanctum_unlocked   = false
    instance.labyrinth_unlocked = false
    instance.atrium_unlocked    = false
    -- For displaying locked transition message
    instance.lock_message_timer = 0
    instance.lock_message_text = ""
    local tile_size = instance.tile_size
    instance.to_library = {
        x = tile_size * 1,
        y = tile_size * 1,
        width = tile_size,
        height = tile_size
    }
    instance.to_sanctum = {
        x = tile_size * 1,
        y = tile_size * 16,
        width = tile_size,
        height = tile_size
    }
    instance.to_labyrinth = {
        x = tile_size * 22,
        y = tile_size * 1,
        width = tile_size,
        height = tile_size
    }
    instance.to_atrium = {
        x = tile_size * 22,
        y = tile_size * 16,
        width = tile_size,
        height = tile_size
    }

    instance.archivists = Archivists:loadAll()
    for _, critter in ipairs(instance.archivists) do
        print("[DEBUG-archives] Loaded Critter:", critter.name, "at", critter.x, critter.y)
    end
    return instance
end

-- Updates game state logic, including archivists and dialogue state.
function Archives:update(dt)
    BaseScene.update(self, dt)

    if not self.inDialogue then
        for _, archivist in ipairs(self.archivists) do
            archivist:update(dt)
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
    BaseScene.draw(self)

    for _, archivist in ipairs(self.archivists) do
        archivist:draw()
    end

    local function drawCircle(area, unlocked)
        love.graphics.setColor(unlocked and {0,1,0,0.6}or{1,0,0,0.6})
        love.graphics.circle(
            'line',
            area.x + area.width / 2,
            area.y + area.height / 2,
            self.tile_size / 3
        )
    end

    drawCircle(self.to_library, self.library_unlocked)
    drawCircle(self.to_sanctum, self.sanctum_unlocked)
    drawCircle(self.to_labyrinth, self.labyrinth_unlocked)
    drawCircle(self.to_atrium, self.atrium_unlocked)

    love.graphics.setColor(1,1,1,1)

    if self.lock_message_timer > 0 and self.lock_message_text ~= "" then
        local width, height = love.graphics.getDimensions()
        love.graphics.setColor(1,0,0,1)
        love.graphics.printf(self.lock_message_text, 0, height / 2 - 20, width, 'center')
        love.graphics.setColor(1,1,1,1)
    end
end

function Archives:checkForSceneSwitch()
    local function check(area, unlocked, name)
        if self.bunny.pos_x == area.x and self.bunny.pos_y == area.y then
            if unlocked then
                return name
            else
                self.lock_message_text = name:sub(1,1):upper()..name:sub(2).." is locked."
                self.lock_message_timer = 1
            end
        end
    end

    return check(self.to_library, self.library_unlocked, 'library')
        or check(self.to_sanctum, self.sanctum_unlocked, 'sanctum')
        or check(self.to_labyrinth, self.labyrinth_unlocked, 'labyrinth')
        or check(self.to_atrium, self.atrium_unlocked, 'atrium')
end

-- Handles Bunny interaction with archivists and triggers dialogue or scene changes.
function Archives:interact()
    if self.inDialogue then return end

    for _, critter in ipairs(self.archivists) do
        if critter:isInteracted(self.bunny.pos_x, self.bunny.pos_y) then
            local conditions = {
                node_COND1 = function()
                    if critter.dialogue_ID == 'smug' then
                        print("[DEBUG] Unlocking Library")
                        self.library_unlocked = true
                    elseif critter.dialogue_ID == 'bambi' then
                        print("[DEBUG] Unlocking Sanctum")
                        self.sanctum_unlocked = true
                    elseif critter.dialogue_ID == 'olive' then
                        print("[DEBUG] Unlocking Labyrinth")
                        self.labyrinth_unlocked = true
                    elseif critter.dialogue_ID == 'wiz' then
                        print("[DEBUG] Unlocking Atrium")
                        self.atrium_unlocked = true
                    end
                end
            }

            self.dialogue = Dialogue:new(critter.dialogue_ID, conditions)

            if self.dialogue then
                self.inDialogue = true
                print("[DEBUG-archives] Started dialogue with:", critter.dialogue_ID)
            else
                print("[ERROR-archives] Failed to start dialogue for:", critter.dialogue_ID)
            end
            return
        end
    end
end

return Archives