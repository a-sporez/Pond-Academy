
local Archives = {}
Archives.__index = Archives

-- dependencies
local sti       = require('libraries.sti') -- simple tiled implementation for loading maps
local Critter   = require('source.entities.critter') -- critter entity management
local Bunny     = require('source.entities.bunny') -- Player (bunny) entity management
local Dialogue  = require('source.dialogues.dialogue')

-- path to map file
local MAP_PATH = 'assets/scenes/archives_map.lua'

--[[
    Initializes the Archives scene
    @return (table) - A new archive scene instance.
--]]
function Archives:new()
    local instance = setmetatable({}, Archives)
    instance.map = sti(MAP_PATH)                    -- load map using STI
    instance.critters = {}                          -- table to store critters
    instance.walls = {}                             -- table to store wall collision tiles.
    instance.doors = {}                             -- table to store locked doors.
    instance.bunny = Bunny:new(
        math.floor(instance.map.width / 2),
        math.floor(instance.map.height / 2)
    )                                               -- create new bunny (player) instance.
    instance.dialogue = nil                         -- No dialogue at the start.
    instance.inDialogue = false                     -- Dialogue state tracker (bool)

    instance:loadCollisionData()
    return instance
end

-- load walls and collision data from the tiled map.
function Archives:loadCollisionData()
    if self.map.layers['wall'] and self.map.layers['wall'].data then
        for y = 1, #self.map.layers['wall'].data do
            for x = 1, #self.map.layers['wall'].data[y] do
                if self.map.layers['wall'].data[y][x] ~= 0 then
                    table.insert(self.walls, {x = x * 32, y = y * 32, width = 32, height = 32})
                end
            end
        end
    end

    if self.map.layers['door'] and self.map.layers['door'].data then
        for y = 1, #self.map.layers['door'].data do
            for x = 1, #self.map.layers['door'].data[y] do
                if self.map.layers['door'].data[y][x] ~= 0 then
                    table.insert(self.doors, {x = x *32, y = y * 32, width = 32, height = 32, locked = true})
                end
            end
        end
    end
end

-- self contained wall collision
function Archives:isCollidingWithWall(x, y)
    for _, wall in ipairs(self.walls) do
        if x >= wall.x and x <= wall.x + wall.width and y >= wall.y and y <= wall.y + wall.height then
            return true
        end
    end
    return false
end

-- self contained locked door detection
function Archives:interactWithDoor(x, y)
    for _, door in ipairs(self.doors) do
        local distance = math.sqrt((x - door.x)^2 + (y - door.y)^2)
        if distance < 20 and door.locked then
            return door
        end
    end
    return nil
end

-- singleton to add critter to the stack of critters
function Archives:addCritter(critter)
    table.insert(self.critters, critter)
end

function Archives:update(dt)
    if self.inDialogue and self.dialogue then
        -- If in dialogue, update it instead of game world.
    else
        self.map:update(dt)
        self.bunny:update(dt)
        for _, critter in ipairs(self.critters) do
            critter:update(dt)
        end
    end
end

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

function Archives:interact()
    if self.inDialogue then return end -- ignore input during dialogue.

    for _, critter in ipairs(self.critters) do
        if critter:isInteracted(self.bunny.x, self.bunny.y) then
            self.dialogue = Dialogue:new(critter.dialogue_ID)
            self.inDialogue = true
            return
        end
    end
end

function Archives:keypressed(key)
    if self.inDialogue and self.dialogue then
        self.dialogue:keypressed(key)

        if key == 'return' then
            self.inDialogue = false
            self.dialogue = nil
        end
    else
        self.bunny:keypressed(key, self)
    end
end

return Archives