local Scene = {}
Scene.__index = Scene

local Camera = require('source.utils.camera')

--[[
    Initializes a new scene
    @param map_path (string)
    @return (table)
--]]
function Scene:new(map_path)
    local instance = setmetatable({}, self)
    instance.map = require('libraries.sti')(map_path)
    instance.tile_size = instance.map.tilewidth

    local screen_w, screen_h = love.graphics.getWidth(), love.graphics.getHeight()
    instance.camera = Camera:new(screen_w, screen_h)
    instance.camera:setBounds(instance.map.width, instance.map.height, instance.tile_size)
    instance.collidables = {}
    instance.bunny = nil
    instance.dialogue = nil
    instance.inDialogue = false
    return instance
end

-- Loads wall collision data from the Tiled map.
function Scene:loadCollisionData()
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

function Scene:isCollidingWithWall(x, y)
    local tile_x = math.floor(x / self.tile_size)
    local tile_y = math.floor(y / self.tile_size)

    if tile_x < 0 or tile_x >= self.map.width or tile_y < 0 or tile_y >= self.map.height then
        return true
    end

    for _, layer_name in ipairs({'collidable', 'water'}) do
        local tile_id = self.map.layers[layer_name].data[tile_y + 1] and self.map.layers[layer_name].data[tile_y + 1][tile_x + 1] or nil
        if tile_id and tile_id ~= 0 then
            return true
        end
    end

    return false
end

function Scene:update(dt)
    if self.inDialogue then
        if self.dialogue and self.dialogue.update then
            self.dialogue:update(dt)
        else
            print("[ERROR-scene] Dialogue instance is nil")
            self.inDialogue = false
        end
    else
        if self.bunny then
            self.bunny:update(dt)
            self.camera:update(self.bunny.pos_x, self.bunny.pox_y)
        end
    end
end

function Scene:draw()
    self.camera:attach()
    self.map:draw()

    if self.bunny then
        self.bunny:draw()
    end

    self.camera:detach()

    if self.inDialogue and self.dialogue then
        self.dialogue:draw()
    end
end

function Scene:interact()
    if self.inDialogue then return end
end

function Scene:keypressed(key)
    if self.inDialogue and self.dialogue then
        self.dialogue:keypressed(key)
        if key == 'escape' then
            print('[DEBUG-scene] Closing dialogue')
            self.inDialogue = false
            self.dialogue = nil
        end
    else
        if self.bunny then
            self.bunny:keypressed(key, self)
        end
    end
end

function Scene:mousepressed(x, y, button)
    if self.inDialogue and self.dialogue then
        self.dialogue:mousepressed(x, y, button)
        if not self.dialogue.current_node then
            self.inDialogue = false
            self.dialogue = nil
        end
    end
end

return Scene