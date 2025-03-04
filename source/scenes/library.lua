local Library = {}
Library.__index = Library

-- Dependencies
local sti        = require('libraries.sti')  -- Simple Tiled Implementation
local Bunny      = require('source.entities.bunny')
local Dialogue   = require('source.dialogues.dialogue')

-- Path to the Tiled map file for this scene
local MAP_PATH = "assets/scenes/library_map.lua"

function Library:new()
    local instance = setmetatable({}, Library)

    -- Load the map using STI
    instance.map = sti(MAP_PATH)
    instance.tile_size = instance.map.tilewidth  -- Assuming square tiles

    -- Initialize entities
    instance.collidables = {}
    instance.bunny = Bunny:new(instance.tile_size * 5, instance.tile_size * 5)  -- Spawn in center
    instance.dialogue = nil
    instance.inDialogue = false

    -- Load collision data
    instance:loadCollisionData()
    return instance
end

function Library:loadCollisionData()
    local layers = {"collidable", "water"} -- Water should also be treated as collidable
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

function Library:isCollidingWithWall(x, y)
    local tile_x = math.floor(x / self.tile_size)
    local tile_y = math.floor(y / self.tile_size)

    if tile_x < 0 or tile_x >= self.map.width or tile_y < 0 or tile_y >= self.map.height then
        return true
    end

    for _, layer_name in ipairs({"collidable", "water"}) do
        local tile_id = self.map.layers[layer_name].data[tile_y + 1] and self.map.layers[layer_name].data[tile_y + 1][tile_x + 1] or nil
        if tile_id and tile_id ~= 0 then
            return true
        end
    end

    return false
end

function Library:update(dt)
    if self.inDialogue then
        if self.dialogue then
            self.dialogue:update(dt)
        end
    else
        self.bunny:update(dt)
    end
end

function Library:draw()
    self.map:draw()
    self.bunny:draw()

    if self.inDialogue and self.dialogue then
        self.dialogue:draw()
    end
end

function Library:interact()
    if self.inDialogue then return end
end

function Library:keypressed(key)
    if self.inDialogue and self.dialogue then
        self.dialogue:keypressed(key)
        if key == "return" then
            self.inDialogue = false
            self.dialogue = nil
        end
    else
        self.bunny:keypressed(key, self)
    end
end

function Library:mousepressed(x, y, button)
    if self.inDialogue and self.dialogue then
        self.dialogue:mousepressed(x, y, button)
        if not self.dialogue.current_node then
            self.inDialogue = false
            self.dialogue = nil
        end
    end
end

return Library
