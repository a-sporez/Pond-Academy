
local Archives = {}
Archives.__index = Archives

-- dependencies
local sti       = require('libraries.sti') -- simple tiled implementation for loading maps
local Critter   = require('source.entities.critter') -- critter entity management
local Bunny     = require('source.entities.bunny') -- Player (bunny) entity management

-- path to map file
local MAP_PATH = 'assets.scenes.archives_map'

--[[
    Initializes the Archives scene
    @return (table) - A new archive scene instance.
--]]
function Archives:new()
    local instance = setmetatable({}, Archives)
    instance.map = sti(MAP_PATH) -- load map using STI
    instance.critters = {} -- table to store critters
    instance.walls = {} -- table to store wall collision tiles.
    instance.doors = {} -- table to store locked doors.
    instance.bunny = Bunny:new(
        math.floor(instance.map.width / 2),
        math.floor(instance.map.height / 2)
    ) -- create new bunny (player) instance.

    instance:loadCollisionData()
    return instance
end

-- load walls and collision data from the tiled map.
function Archives:loadCollisionData()
    if self.map.layers['wall'] then
        for y = 1, #self.map.layers['wall'].data do
            for x = 1, #self.map.layers['wall'].data[y] do
                if self.map.layers then
                    
                end
            end
        end
    end
end

return Archives