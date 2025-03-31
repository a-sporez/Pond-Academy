local sti = require 'libraries.sti'
local Bunny = require 'source.entities.bunny'
local Dialogue = require 'source.dialogues.dialogue'

local BaseScene = {}
BaseScene.__index = BaseScene

--[[
    Base class to instantiate a new scene.
    @param map_path (string)
    @param spawn_from (string)
    @param spawn_positions (table)
]]
function BaseScene:new(map_path, spawn_from, spawn_positions)
    local instance = setmetatable({}, BaseScene)

    --load STI map data
    instance.map = sti(map_path)
    instance.tile_size = instance.map.tilewidth
    instance.collidables = {}

    -- spawn bunny
    local spawn = spawn_positions.default
    if spawn_from and spawn_positions[spawn_from] then
        spawn = spawn_positions[spawn_from]
    end

    instance.bunny = Bunny:new(spawn.x, spawn.y)

    -- DIalogue states
    instance.dialogue = nil
    instance.inDialogue = false

    instance:loadCollisionData()

    return instance
end

function BaseScene:loadCollisionData()
    for _, layer_name in ipairs({'collidable', 'water'}) do
        local layer = self.map.layers[layer_name]
        if layer and layer.data then
            for y = 1, #layer.data do
                for x = 1, #layer.data[y] do
                    if layer.data[y][x] ~= 0 then
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

function BaseScene:isCollidingWithWall(x, y)
    local tile_x = math.floor(x / self.tile_size)
    local tile_y = math.floor(y / self.tile_size)

    if tile_x < 0 or tile_x >= self.map.width or tile_y < 0 or tile_y >= self.map.height then
        return true
    end

    for _, layer_name in ipairs({'collidable', 'water'}) do
        local layer = self.map.layers[layer_name]
        local row = layer and layer.data[tile_y + 1]
        local tile_id = row and row[tile_x + 1]
        if tile_id and tile_id ~= 0 then
            return true
        end
    end

    -- Check for archivists or other collidable entities.
    if self.archivists then
        for _, archivist in ipairs(self.archivists) do
            if archivist.collidable and
               math.floor(archivist.pos_x / self.tile_size) == tile_x and
               math.floor(archivist.pos_y / self.tile_size) == tile_y then
                return true
            end
        end
    end

    return false
end

-- BaseScene.lua

-- Safe fallback in case scene doesn't override
function BaseScene:interact()
    -- noop
end

function BaseScene:update(dt)
    if self.inDialogue then
        if self.dialogue and self.dialogue.update then
            self.dialogue:update(dt)
        end
    else
        self.bunny:update(dt)
    end
end

function BaseScene:draw()
    self.map:draw()
    self.bunny:draw()

    if self.inDialogue and self.dialogue then
        self.dialogue:draw()
    end
end

function BaseScene:keypressed(key)
    if self.inDialogue and self.dialogue then
        self.dialogue:keypressed(key)
        if key == 'escape' then
            self.inDialogue = false
            self.dialogue = nil
        end
    else
        self.bunny:keypressed(key, self)
    end
end

function BaseScene:mousepressed(x, y, button)
    if self.inDialogue and self.dialogue then
        self.dialogue:mousepressed(x, y, button)
        if not self.dialogue.current_node then
            self.inDialogue = false
            self.dialogue = nil
        end
    end
end

return BaseScene