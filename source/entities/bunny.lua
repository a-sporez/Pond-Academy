
local Bunny = {}
Bunny.__index = Bunny

local TILE_SIZE = 32

--[[
    Creates new player (Bunny) entity.
    @param start_x (number) - starting x position
    @param start_y (number) - starting y location
    @return (table) - a new Bunny instance.
--]]
function Bunny:new(start_x, start_y)
    local instance = setmetatable({}, Bunny)
    instance.x = start_x * TILE_SIZE
    instance.y = start_y * TILE_SIZE
    instance.sprite = love.graphics.newImage('assets/sprites/bunny.png')
    return instance
end

function Bunny:move(dx, dy, archives)
    local new_x = self.x + (dx * TILE_SIZE)
    local new_y = self.y + (dy * TILE_SIZE)

    if not archives:isCollidingWithWall(new_x, new_y) then
        self.x = new_x
        self.y = new_y

        -- check for interactions with door
        local door = archives:interactWithDoor(self.x, self.y)
        if door then
            print('[GAME] LOCKED DOOR')
        end
    end
end

function Bunny:keypressed(key, archives)
    if key == 'up' or key == 'w' then
        self:move(0, -1, archives)
    elseif key == 'down' or key == 's' then
        self:move(0, 1, archives)
    elseif key == 'left' or key == 'a' then
        self:move(-1, 0)
    elseif key == 'right' or key == 'd' then
        self:move(1, 0)
    end
end

function Bunny:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

return Bunny