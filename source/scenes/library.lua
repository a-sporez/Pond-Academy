local BaseScene = require("source.scenes.BaseScene")

local Library = setmetatable({}, { __index = BaseScene })
Library.__index = Library

local MAP_PATH = "assets/scenes/library_map.lua"

function Library:new(spawn_from)
    local spawn_positions = {
        default = { x = 22 * 32, y = 1 * 32 },
        archives = { x = 12 * 32, y = 8 * 32 }, -- Just above transition tile
    }

    local instance = BaseScene.new(self, MAP_PATH, spawn_from, spawn_positions)
    setmetatable(instance, Library)

    local t = instance.tile_size
    instance.to_archives = {
        x = 12 * t,
        y = 9 * t,
        width = t,
        height = t
    }

    return instance
end

function Library:checkForSceneSwitch()
    if self.bunny.pos_x == self.to_archives.x and self.bunny.pos_y == self.to_archives.y then
        return "archives"
    end
end

return Library